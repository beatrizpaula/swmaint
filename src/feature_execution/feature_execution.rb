require 'method_source'
require 'singleton'

require_relative 'empty_module'
require_relative 'feature_execution_proxy'
require_relative 'invalid_alteration_error'
require_relative '../application_domain/alteration'
require_relative '../code_execution'

#
# Class representing the behaviour of the feature execution component
#
# Author: Benoît Duhoux
# Date: 2017, 2020
#
class FeatureExecution

  include CodeExecution
  include FeatureExecutionProxy
  include Singleton

  def initialize()
    @vars_store = {}
    @proceeds_methods = {}
  end

  def execute_activation(activated_features)
    activated_features.each {
        |activated_feature|
      alter(:activate, activated_feature)
    }
  end

  def execute(to_execute)
    global_features_to_execute = {
      :activate => [],
      :deactivate => []
    }

    to_execute.each do
      |action_on_feature|
      global_features_to_execute[action_on_feature.action] << action_on_feature.entity
      if action_on_feature.action == :deactivate
        run_code_of_features(:epilogue, [action_on_feature.entity])
      end
      begin
        alter(action_on_feature.action, action_on_feature.entity)
      rescue InvalidAlterationError => error
        run_code_of_features(:prologue, [action_on_feature.entity])
        raise
      end
    end

    if Bootstrap.bootstrap_done?()
      run_code_of_features(:prologue, global_features_to_execute[:activate])
    end
  end

  def alter(action, feature_entity)
    global_feature_module = Module.find_feature_module(feature_entity.name)

    feature_sub_modules = global_feature_module.find_all_sub_modules()
    feature_sub_modules.each do
      |feature_sub_module|
      if feature_entity.targeted_classes.include?(feature_sub_module.symbol_of_targeted_class().to_s())
        targeted_class = Class.find_class(feature_sub_module.symbol_of_targeted_class())
        _save_default_behaviours(targeted_class)
        self.send("_#{action}_behaviour", feature_sub_module, targeted_class)
        feedback_for_feature_visualiser(action, feature_sub_module, targeted_class)
      else
        error = "You cannot #{action} the feature #{feature_sub_module.name} in the class #{feature_sub_module.symbol_of_targeted_class().to_s}."
        error_feedback_for_feature_visualiser(error)
        raise(InvalidAlterationError, error)
      end
    end

    return feature_sub_modules
  end

  def proceed(current_instance, current_classname, current_method, *args, &block)
    current_class = Object.const_get(current_classname)

    key = "#{current_classname}##{current_method}"
    current_version = @proceeds_methods[key].pop()
    previous_version = @proceeds_methods[key].pop()

    _deploy(current_class, previous_version)
    method_to_execute = look_up_method(current_instance, current_class, current_method)
    res = method_to_execute.call(*args, &block)
    _deploy(current_class, current_version)

    return res
  end

  # This method aims to find the method in the right class in an hierarchy of classes.
  # (The right class is the class on which the proceed statement is executed.)
  # Assume two classes {A, B}, where B is the subclass of A.
  # Both classes implement a method "m" and B calls the super method of "m" before continuing its execution.
  # Assume two features {A1, B1}, where A1 (resp. B1) adapts the behaviour of the class A (resp. B).
  # Each of features implements an adaptation of the method "m"
  # and calls the previous adaptation with the keyword 'proceed' before executing its next statements.
  # After activating {A1, B1}, when executing the method "m" on a instance of B,
  # The stack is the following: B1, B, A1, A.
  # Without this method, the stack of the execution would have been the following: B1, B, A1, B, A.
  # The problem comes from we call a method "m" on the current instance (instance of B) during the proceed statement.
  # So when we call "m" in the adaptation A1, we execute "m" on B and not on the concerned class (i.e. A).
  # To solve that, we compute the difference between the ancestors of the two classes ([B] = [B, A, ...] - [A, ...]),
  # and we loop on each ancestor to get the super method bounded to the right class (i.e. "m" bounded to A).
  def look_up_method(current_instance, current_class, current_method)
    method_to_execute = current_instance.method(current_method)
    if current_instance.is_a?(current_class)
      ancestors = current_instance.class.ancestors_to(current_class)
      ancestors.each {
        method_to_execute = method_to_execute.super_method()
      }
    end
    return method_to_execute
  end

  def search_var_in_store(current_class, ctx_var)
    key = "#{current_class}##{ctx_var}"
    res = @vars_store[key]
    return res
  end

  def update_vars_store(current_class, ctx_var, new_val)
    key = "#{current_class}##{ctx_var}"
    @vars_store[key] = new_val
  end

  private

  def _get_all_methods(klass)
    all_methods = klass.instance_methods(false)
    begin
      klass.instance_method(:initialize)
      all_methods << :initialize
    rescue NameError
    end
    return all_methods
  end

  # Save the default behaviour when the class contains a default behaviour
  def _save_default_behaviours(klass)
    _get_all_methods(klass).each do
      |method_name|
      key = "#{klass}##{method_name}"
      if !@proceeds_methods[key]
        default_alteration = Alteration.new(klass.name, method_name, klass.instance_method(method_name))
        @proceeds_methods[key] = [default_alteration]
      end
    end
  end

  def _activate_behaviour(feature_module, targeted_class)
    _get_all_methods(feature_module).each do
      |method_name|
      method_code = _get_method_code(feature_module, method_name, targeted_class)
      alteration = Alteration.new(feature_module.name, method_name, method_code)
      _deploy(targeted_class, alteration)
    end
  end

  def _get_method_code(feature_module, method_name, targeted_class)
    method_code = feature_module.instance_method(method_name)

    method_code_string = method_code.source()
    if method_code_string.include?("proceed")
      method_code_string, is_rewritten = _modify_source_code_if_needed(method_code_string, targeted_class)
      if is_rewritten
        EmptyModule.module_eval(method_code_string)
        method_code = EmptyModule.instance_method(method_name)
      end
    end

    return method_code
  end

  def _modify_source_code_if_needed(method_code_string, targeted_class)
    new_code_source = ""
    proceed_is_rewritten = false
    method_code_string.lines.map(&:chomp).each do
    |method_code_line|
      if _is_not_a_proceed_line_as_comment(method_code_line) && _is_a_proceed_line(method_code_line)
        new_code_source << _modify_proceed_line(method_code_line, targeted_class)
        proceed_is_rewritten = true
      else
        new_code_source << method_code_line
      end
      new_code_source << "\n"
    end

    return new_code_source, proceed_is_rewritten
  end

  def _is_not_a_proceed_line_as_comment(line)
    # This regex don't take account if the line is a comment
    return line.strip() =~ /^(?!#[^.*\{]).*$/
  end

  def _is_a_proceed_line(line)
    # This regex tests and accepts all of these following lines:
    # 		proceed
    # 		proceed()
    # 		proceed(my_var)
    # 		puts "#{proceed}"
    # 		puts "#{proceed()}"
    # 		puts "#{proceed(my_var)}"
    # 		puts "proceed = #{proceed}"
    # 		puts "proceed = #{proceed(my_var, my_list)}"
    # 		my_method(proceed)
    # 		my_method(proceed())
    # 		my_method(proceed(my_var))
    # and negates this kind of lines:
    # 		puts "Print before the proceed mechanism..."
    return line.include?("proceed") && line.strip() =~ /^(?!puts.*).*$|^puts\s*".*#\{.*\}".*$/
  end

  def _modify_proceed_line(line, targeted_class)
    before_proceed = line.match(/(.*)proceed.*/).captures[0]
    proceed_args = line.match(/.*proceed\(?([a-zA-Z0-9_,&\.\s]*)\)?\n?/).captures[0].strip()
    new_code_proceed = "#{before_proceed}proceed('#{targeted_class}'"
    if !proceed_args.empty?()
      new_code_proceed << ", #{proceed_args}"
    end
    count_opened_parentheses = new_code_proceed.count("(")
    count_closed_parentheses = new_code_proceed.count(")")
    if count_opened_parentheses > count_closed_parentheses
      diff_parentheses = count_opened_parentheses - count_closed_parentheses
      new_code_proceed << ')' * diff_parentheses
    end
    return new_code_proceed
  end

  def _deactivate_behaviour(feature_module, targeted_class)
    _get_all_methods(feature_module).each do
      |method_name|

      key = "#{targeted_class}##{method_name}"
      stack = @proceeds_methods[key]

      index_of_last_activation = stack.rindex do
        |alteration|
        feature_module.name == alteration.feature_name && method_name = alteration.method_name
      end

      if index_of_last_activation < stack.length() - 1
        proceed_detected = false
        if stack[index_of_last_activation + 1].method_code.owner() == EmptyModule
          # This assumption comes from the fact that we only use the EmptyModule module
          # when we need to overwrite the proceed statement of the feature
          proceed_detected = true
        else
          proceed_detected = stack[index_of_last_activation + 1].method_code.source().include?('proceed')
        end

        if proceed_detected && index_of_last_activation == 0
          raise(InvalidAlterationError,
                "You cannot remove the adaptation '#{feature_module.name}' because some features activated after this are based on it.")
        end
      end

      stack.delete_at(index_of_last_activation)

      if index_of_last_activation == stack.length()
        _undeploy(targeted_class, method_name, stack)
      end
    end
  end

  # For the moment, the deploy method runs well.
  # However if I must sort the different methods with a specific strategy, this code runs in O(n) = n²
  # Solution: use the principle of method dispatch
  # 	-> idea: get all methods and order them to finally push in the proceed
  def _deploy(targeted_class, alteration)
    # As I use define_method I cannot get method_code from a class due to the problem of binding.
    # If method_code from a class, I would get the following error
    # `define_method': bind argument must be a subclass of F1 (TypeError).
    targeted_class.send(:define_method, alteration.method_name, alteration.method_code)

    key = "#{targeted_class}##{alteration.method_name}"
    stack = @proceeds_methods[key]
    if stack
      stack.push(alteration)
    else
      @proceeds_methods[key] = [alteration]
    end
  end

  def _undeploy(targeted_class, current_method, stack)
    # I must use the meta method to bypass
    # that the method remove_method is private for a class
    targeted_class.send(:remove_method, current_method)

    if !stack.empty?()
      alteration = stack.pop()
      _deploy(targeted_class, alteration)
    end
  end

end