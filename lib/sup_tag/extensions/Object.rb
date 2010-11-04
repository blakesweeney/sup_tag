require 'sup_tag/extensions/binding'
# Modify Object to support tag and archive methods.

class Object

  # Tag messages using the given block.
  #
  # @param [Block] block Block to tag with.
  # @return [Set] The Set of tags on the message.
  def tag(&block)
    tagger = get_tagger(&block)
    tagger.tag(&block)
  end

  # Archive messages using the given block.
  #
  # @param [Block] A block to use to tag.
  # @return [Set] The Set of tags on the message.
  def archive(&block)
    tagger = get_tagger(&block)
    tagger.archive(&block)
  end

  # Get the SupTag object for the given block.
  #
  # @param [Block] A Block to generate the tagger object with.
  # @return [SupTag] A SupTag object.
  def get_tagger(&block)
    return SupTag.new(block.binding[:message])
  end
end
