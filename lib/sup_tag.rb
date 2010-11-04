# Class to make tagging simple.
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
    @match = false
    cloaker(&block).bind(self).call
    remove(:inbox) if @match
    return @message.labels
  end

  # Tag a message.
  #
  # @param [Block] Block for adding tags.
  # @return [Array] The tags on the message.
  def tag(&block)
    cloaker(&block).bind(self).call
    return @message.labels
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

  def method_missing(method, *args, &block)
    super if !respond_to?(method)

    parts = split_args(args)
    queries = parts.first
    results = Array(@message.send(method))
    count = match_args(results, queries)
    if count.size == queries.size
      @match = true
      parts.last.compact.each { |l| @message.add_label(l) }
    end
  end

  private
    # Split the arguments into labels and queries.
    #
    # @param [Array] arguments Arguments to split.
    def split_args(arguments)
      parts = arguments.partition { |e| !e.is_a?(Symbol) && e }

      # Generate labels if none given
      if parts[1].empty?
        parts[1] = parts[0].map do |part|
          (part.is_a?(Regexp) ? part.source : part.to_s).downcase
        end
      end
      
      return parts
    end

    # Match the results against the queries and count how many match.
    #
    # @param [Array] results Results to check.
    # @param [Array] queries Queries to look for.
    def match_args(results, queries)
      queries.map do |query|
        (results.any? { |r| r.to_s.match(query) } ? 1 : nil)
      end.compact
    end
end
