require_relative 'feature_execution/feature_execution'

#
# Updating the class Object to add some behaviour as the proceed mechanism for example
#
# Author: Benoît Duhoux
# Date: 2017
#
class Object

	def proceed(current_classname, *args, &block)
		current_method = caller.first[/`(.*)'/, 1]
		FeatureExecution.instance.proceed(self, current_classname, current_method, *args, &block)
	end

	def update_vars_store(current_class, ctx_var, new_val)
		FeatureExecution.instance.update_vars_store(current_class, ctx_var, new_val)
	end

	def previous_value(ctx_var)
		FeatureExecution.instance.search_var_in_store(self.class, ctx_var)
	end

end