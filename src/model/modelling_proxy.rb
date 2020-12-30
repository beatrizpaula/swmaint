require_relative '../utils/context_feature_model_communication'

#
# Module allowing to send to the visualization tool information 
# about the feature modelling in a static and dynamic way
# with their (de)activations
#
# Author: Benoît Duhoux and Hoo Sing Leung
# Date: 2018
#
module ModellingProxy

	def feedback_for_tool(action, data)
		if ContextFeatureModelCommunication.instance.dev_env?
			ContextFeatureModelCommunication.instance.send_message({
				:action => action,
				:data => _actions_on_features_to_js_objects(action, data),
			})
		end
	end

	def _actions_on_features_to_js_objects(action, data)
		js_object = {}
		case action.to_s
		when 'entity_node'
			js_object['name'] = data.name
			js_object['type'] = data.class
			js_object['methods'] = []
			js_object['classes'] = []
			if data.class.to_s.eql?("Feature")
				if Module.const_defined?(data.name)
					js_object['classes'] = _create_class_node_for_tool(data.name)
					js_methods = []
					Module.const_get(data.name).find_all_sub_modules().each do
						|sub_module|
						rubyMethods = sub_module.instance_methods(false)
						if rubyMethods.any?
							rubyMethods.each{
									|method|
								js_method = {}
								js_method['name'] = method.to_s
								js_methods.push(js_method)
							}
						end
					end
					js_object['methods'] = js_methods
				end
			end
			js_object['counter'] = data.committed_counter

		when 'relations'
			js_object = {}
			js_object['origin'] = data[0].name
			js_object['group'] = data[0].class

			destinations = []
			data[1].each { 
				|targets|  
				classesPackage =  []
				if targets.class.to_s.eql?("Feature")
					if Module.const_defined?(targets.name)
						classes = Module.const_get(targets.name).find_all_targeted_classes()
						if classes.any?
							classes.each{
								|classe|
								element = {}
								parentsClass = []
								element['name'] = classe
								iter = Class.const_get(classe).superclass.name
								while iter != "Object" do
									parentsClass.push(iter)
									iter = Class.const_get(iter).superclass.name
								end
								element['ancestors'] = parentsClass
								classesPackage.push(element)
							}
						end
					end
				end
				destinations.push([targets.name.to_s + targets.class.to_s, classesPackage])
			}
			js_object['destinations'] = destinations
			js_object['type'] = data[2]
			js_object['isConstraint'] = data[3]
		
		when 'mapping'
			mapping = []
			data.each {
			|key, value|  
			if key.kind_of?(Array)
				key.each{
					|context|
					mapping = _js_mapping(context, value, mapping)
				}
			else
				mapping = _js_mapping(key, value, mapping)
			end
			js_object = mapping
		}

		when 'activation'
			if data.pending_counter < 2
				js_object = data.name.to_s + data.class.to_s
			end
		when 'deactivation'
			if data.pending_counter < 1
				js_object = data.name.to_s + data.class.to_s
			end
		end
		
		return js_object
	end

	def _js_mapping(context, features, mapping)
		if features.kind_of?(Array)
			features.each{
				|feature|
				mapping.push([context.name, feature.name])
			}
		else
			mapping.push([context.name, features.name])
		end
		return mapping
	end

	def _create_class_node_for_tool(name)
		result = []
		classes = Module.const_get(name).find_all_targeted_classes()
		classes.each{
			|classname|
			js_class = {'name' => classname}
			inter = Class.const_get(classname).instance_methods(false)
			js_classMethod = []
			if !(inter.nil? || inter.empty?)
				inter.each{
					|value|
					js_meth = {}
					args = Class.const_get(classname).instance_method(value).parameters.map(&:last).map(&:to_s)
					js_args = []
					if !(args.nil? || args.empty?)
						args.each{
							|arg|
							js_args.push({'name' => arg})
						}
					end
					js_meth['name'] = value
					js_meth['parameters'] = js_args
					js_classMethod.push(js_meth)
				}
			end
			js_class['methods'] = js_classMethod
			props = Class.const_get(classname).instance_variables
			js_props =[]
			if !(props.nil? || props.empty?)
				props.each{
					|prop|
					js_props.push({'name' => prop})
				}
			end
			js_class['properties'] = js_props
			
			result.push(js_class)
		}
		return result
	end

end