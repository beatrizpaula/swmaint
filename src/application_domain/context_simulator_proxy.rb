require_relative '../utils/context_simulator_communication'

module ContextSimulatorProxy

  def generate_environment(model)
    deepest_abstract_contexts = _get_deepest_abstract_contexts(model)
    data = _convert_deepest_abstract_contexts_to_flatten_data(deepest_abstract_contexts)
    ContextSimulatorCommunication.instance.send_message({'init' => data})
  end

  private

  def _get_deepest_abstract_contexts(model)
    queue = [model]
    deepest_abstract_contexts = []
    while !queue.empty?()
      node = queue.shift()
      if node.deepest_abstract?()
        deepest_abstract_contexts << node
      else
        if node.abstract?()
          node.relations.each do
            |_, relation|
            if relation.is_a?(Constraint)
              queue += relation.nodes
            end
          end
        end
      end
    end
    return deepest_abstract_contexts
  end

  def _convert_deepest_abstract_contexts_to_flatten_data(deepest_abstract_contexts)
    list_of_abstracts_contexts = []
    deepest_abstract_contexts.each do
      |abstract_context|
      value = {}
      value['context'] = abstract_context.name
      relations_of_abstract_context = []
      abstract_context.relations.each do
        |type, relation|
        new_relation = {}
        new_relation['type'] = type
        if abstract_context.strategy_ico_mandatory_parent
          new_relation['default'] = abstract_context.strategy_ico_mandatory_parent.select_default_entity().name
        end
        new_relation['children'] = relation.nodes.map do
          |context|
          context.name
        end
        relations_of_abstract_context << new_relation
      end
      value['relations'] = relations_of_abstract_context
      list_of_abstracts_contexts << value
    end
    return list_of_abstracts_contexts
  end

end