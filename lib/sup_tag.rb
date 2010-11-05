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
    tag(&block)
    remove(:inbox) if @labels
    return @message.labels
  end

  # Tag a message.
  #
  # @param [Block] Block for adding tags.
  # @return [Array] The tags on the message.
  def tag(&block)
    @labels = nil
    cloaker(&block).bind(self).call
    @labels.each { |l| @message.add_label(l) } if @labels
    return @message.labels
  end

  # Test queries across several feilds to add tags.
  #
  # @param [Symbol, Array] labels Labels to add.
  # @param [Block] Block for adding tags.
  # @return [Array] The tags on the message
  def multi(*labels, &block)
    @multi = true
    cloaker(&block).bind(self).call
    @labels = nil # Really don't like this hack
    labels.each { |t| @message.add_label(t) } if @multi
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

  # Override to include methods from messages.
  def respond_to?(method, include_private = false)
    return @message.respond_to?(method) || super
  end

  # Override method missing to allow for matching the results of
  # a method on message against some queries.
  def method_missing(method, *args, &block)
    super if !respond_to?(method)
    parts = split_args(args)
    queries = parts.first
    results = Array(@message.send(method))
    count = match_args(results, queries)
    if count.size == queries.size
      @labels ||= []
      @multi &= true
      @labels.concat(parts.last.compact)
    else
      @multi = false
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
