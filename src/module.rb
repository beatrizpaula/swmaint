#
# Updating the class Module to add some macros and some behaviours
#
# Author: Benoît Duhoux
# Date: 2017, 2020
#
class Module

	class << self

		def find_feature_module(feature_name)
			unless self.const_defined?(feature_name)
				raise(NameError, "#{feature_name} is not declared as a feature.")
			end
			return self.const_get(feature_name)
		end

	end

	attr_reader :prologue, :epilogue

	@prologue = []
	@epilogue = []

	def adapts_class(klass)
		@adapts_class = klass
	end

	def symbol_of_targeted_class()
		return @adapts_class
	end

	def find_all_targeted_classes()
		all_classes = []
		self.find_all_sub_modules().each do
			|sub_module|
			all_classes << sub_module.symbol_of_targeted_class()
		end
		return all_classes
	end

	def find_all_sub_modules()
		sub_modules = []

		self.constants.each do
			|sub_module_name|
			sub_module = self.const_get(sub_module_name)
			if sub_module.instance_of?(Module)
				sub_modules << sub_module
			end
		end

		return sub_modules
	end

	def ctx_attr_writer(*ctx_vars)
		ctx_vars.each { 
			|ctx_var|  
			define_method("#{ctx_var}=") {
				|new_val|  
				instance_variable_set("@#{ctx_var}", new_val)
				update_vars_store(self.class, ctx_var, new_val)
			}
		}
	end

	def ancestors_to(to_class)
		self.ancestors - to_class.ancestors
	end

	def set_prologue(*methods)
		@prologue = methods
	end

	def set_epilogue(*methods)
		@epilogue = methods
	end

	def user_interface_adaptation()
	end

	def behaviour_adaptation()
	end

end