# Modify Binding to extract value.

class Binding

  # Get the value of a variable of method in this binding.
  #
  # @param [Symbol, String] name Object to get value of.
  # @return [Object] The value.
  def [](name)
    return eval("lambda { #{name.to_s} }", self).call
  end
end
