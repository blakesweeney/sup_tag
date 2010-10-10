require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "SupTag" do
  context 'taggable' do
    it 'can use the from feild' do
      SupTag.taggable?(:from).should be_true
    end
    it 'can use subj' do
      SupTag.taggable?(:subj).should be_true
    end
    it 'can use subject' do
      SupTag.taggable?(:subject).should be_true
    end
  end

  context 'respond_to' do
    it 'responds to taggable methods' do
      [ :from, :subj, :subject ].each do |meth|
        SupTag.new(nil).respond_to?(meth).should be_true
      end
    end
  end

  context 'tags' do
    before do
      @mess = get_short_message
      @tagger = SupTag.new(@mess)
    end

    context 'removing tags' do
      it 'can remove a given tag' do
        @mess.add_label(:t)
        @tagger.remove(:t)
        @mess.labels.to_a.should == []
      end
      it 'can remove many tags' do
        @mess.add_label(:t)
        @mess.add_label(:t2)
        @tagger.remove([:t, :t2])
        @mess.labels.to_a.should == []
      end
    end

    context 'adding tags' do
      it 'can tag using a regexp' do
        @tagger.tag do
          subj /Test/, :test
        end
        @mess.labels.to_a.should == [ :test ]
      end
      it 'can tag using a string'
      it 'does not remove the inbox tag'
      it 'uses all tags given'
      it 'will set the tag to the given string if no tag given'
      it 'will set the tag to the given regexp source if no tag given'
    end
  end

  context 'archiving' do
    it 'removes the inbox tag'
    it 'sets the tag to the given one'
    it 'does not tag if _NO_TAG_ tag given'
  end

  context 'aliases' do
    it 'can define custom aliases'
  end
end
