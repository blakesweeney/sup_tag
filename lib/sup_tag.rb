# Class to make tagging 
class SupTag

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

  # Archive a message. This adds the matching tags and removes the
  # inbox tag.
  #
  # @param [Block] block Block to add tags.
  # @return [Array] Tags on the message.
  def archive(&block)
    remove(:inbox)
    tag(&block)
  end

  # Tag a message.
  #
  # @param [Block] Block for adding tags.
  # @return [Array] The tags on the message.
  def tag(&block)
    cloaker(&block).bind(self).call
    @message.labels
  end

  # Instance eval for blocks stolen from Trollop. Orignally from:
  # http://redhanded.hobix.com/inspect/aBlockCostume.html, which now
  # seems to be down.
  #
  # @param [Block] b A block to bind.
  # @return [Block] The given block bound so it will eval in this
  # instance context.
  def cloaker(&b)
    (class << self; self; end).class_eval do
      define_method :cloaker_, &b
      meth = instance_method :cloaker_
      remove_method :cloaker_
      meth
    end
  end

  def respond_to?(method, include_private = false)
    return @message.respond_to?(method) || super
  end

  def method_missing(method, *args)
    super if !respond_to?(method)

    match = args.shift
    match_string = (match.is_a?(Regexp) ? match.source : match.to_s)
    tags = (args.empty? ? [match_string.downcase] : args).compact
    query = @message.send(method)
    if (!query.is_a?(Array) && query.to_s.match(match)) ||
      (query.is_a?(Array) && query.any? { |q| q.to_s.match(match) } )
      tags.map { |t| @message.add_label(t) }
    end
  end
end
