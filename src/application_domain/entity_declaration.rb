#
# Class representing an abstract declaration
#
# Author: Benoît Duhoux
# Date: 2018
#
class EntityDeclaration

	class << self

		def new()
			declaration = super()
			declaration.generate_all_getters()
			return declaration
		end

	end

	def generate_all_getters()
		self.instance_variables.each { 
			|attribute|  
			self.class.send(:define_method, attribute[1..-1].to_sym()) {
				instance_variable_get("#{attribute.to_s()}")
			}
		}
	end

end