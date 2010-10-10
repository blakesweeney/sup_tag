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
      it 'can tag using a string' do
        @tagger.tag do
          subj 'Test', :test
        end
        @mess.labels.to_a.should == [ :test ]
      end
      it 'does not remove any tags' do
        @mess.add_label :a
        @mess.add_label :c
        @tagger.tag do
          subj 'Test', :test
        end
        @mess.labels.should == Set[ :a, :c, :test ]
      end
      it 'uses all tags given' do
        @tagger.tag do
          subj 'Test', :test, :a, :c
        end
        @mess.labels.should == Set[ :a, :c, :test ]
      end
      it 'will set the tag to the given downcased string if no tag given' do
        @tagger.tag do
          subj 'Test'
        end
        @mess.labels.should == Set[ :test ]
      end
      it 'will set the tag to the given regexp source if no tag given' do
        @tagger.tag do
          subj /Test/i
        end
        @mess.labels.should == Set[ :test ]
      end
      it 'will not add a nil tag' do
        @tagger.tag do
          subj /Test/i, nil
        end
        @mess.labels.should == Set[ ]
      end
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
