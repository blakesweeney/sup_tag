require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'sup_tag/extensions/object'

describe 'Object' do
  before do
    def message
      get_short_message
    end
  end
  context 'tagger' do
    it 'can make the tagger' do
      (get_tagger { 'a' }).should_not be_nil
    end
  end

  context 'tagging' do
    it 'can tag a message' do
      tags = tag do
        subj /test/i
      end
      tags.should == Set[:test]
    end
    it 'can archive messages' do
      def message
        m = get_short_message
        m.add_label(:inbox)
        return m
      end
      tags = archive do
        subj /test/i, :bob
      end
      tags.should == Set[:bob]
    end
  end
end
