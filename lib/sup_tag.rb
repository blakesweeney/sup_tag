# Class to make tagging 
class SupTag

  # List of all methods in a message we can use to tag.
  TAGGABLE = [ :subj, :subject, :from ]

  # Check if we can tag using the given method name.
  #
  # @param [Symbol] method Method name to tag with.
  # @return [Boolean] true if the method is taggable.
  def self.taggable?(method)
    TAGGABLE.include?(method)
  end

  # Create a new SupTag.
  #
  # @param [Redwood::Message] message A Message to tag.
  def initialize(message)
    @message = message
  end

  # Remove the given tags from the message.
  #
  # @param [Symbol, Array] tags Tags to remove.
  # @return [Array] The tags on the message.
  def remove(tags)
    Array(tags).each { |t| @message.remove_label(t) }
    return @message.labels
  end

  # Tag a message.
  #
  # @return [Array] The tags on the message.
  def tag(&block)
    cloaker(&block).bind(self).call
    @message.labels
  end

  # Instance eval for blocks stolen from Trollop. Orignally from:
  # http://redhanded.hobix.com/inspect/aBlockCostume.html.
  def cloaker(&b)
    (class << self; self; end).class_eval do
      define_method :cloaker_, &b
      meth = instance_method :cloaker_
      remove_method :cloaker_
      meth
    end
  end

  def respond_to?(method, include_private = false)
    return self.class.taggable?(method) || super
  end

  def method_missing(method, *args)
    super if !respond_to?(method)

    match = args.shift
    match_string = (match.is_a?(Regexp) ? match.source : match.to_s)
    tags = (args.empty? ? [match_string.downcase] : args)
    if @message.send(method).match(match)
      tags.map { |t| @message.add_label(t) }
    end
  end
end
