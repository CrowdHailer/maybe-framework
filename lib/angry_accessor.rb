module AngryAccessor
  InstanceVariableError = Class.new(IndexError)
  def attr_fetcher(*variables)
    variables.each do |variable|
      define_method variable do
        raise InstanceVariableError, "variable not found: :#{variable}" unless instance_variables.include?("@#{variable}".to_sym)
        instance_variable_get("@#{variable}".to_sym)
      end
    end
  end

  # Instance variable hash
  # delete instance variable
end
