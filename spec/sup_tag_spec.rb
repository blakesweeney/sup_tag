require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "SupTag" do
  context 'respond_to' do
    it 'responds to taggable methods' do
      [ :from, :subj, :to, :replyto ].each do |meth|
        SupTag.new(get_short_message).respond_to?(meth).should be_true
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

    context 'tagging methods' do
      it 'can tag using from name' do
        @tagger.tag do
          from /Fake Sender/i, :test
        end
        @mess.labels.to_a.should == [ :test ]
      end
      it 'can tag using from email' do
        @tagger.tag do
          from /example.invalid/i, :test
        end
        @mess.labels.to_a.should == [ :test ]
      end
      it 'can tag using to' do
        @tagger.tag do
          to /Fake/i, :test
        end
        @mess.labels.to_a.should == [ :test ]
      end
      it 'can tag using to email' do
        @tagger.tag do
          to /@localhost/, :test
        end
        @mess.labels.to_a.should == [ :test ]
      end
      it 'can tag using subj' do
        @tagger.tag do
          subj /Test/, :test
        end
        @mess.labels.to_a.should == [ :test ]
      end
      it 'can tag using cc' do
        @tagger.tag do
          cc /@someplace/, :test
        end
        @mess.labels.to_a.should == [ :test ]
      end
      it 'can tag using bcc' do
        @tagger.tag do
          bcc /@important/, :test
        end
        @mess.labels.to_a.should == [ :test ]
      end
      it 'can tag using recipients' do
        @tagger.tag do
          recipients /@important/, :test
        end
        @mess.labels.to_a.should == [ :test ]
      end
      it 'can tag using date' do
        @tagger.tag do
          date /2007/, :old
        end
        @mess.labels.should == Set[:old]
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
      it 'can tag if the method returns an array' do
        @tagger.tag do
          to 'Fake', :test
        end
        @mess.labels.should == Set[:test]
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
    before do
      @mess = get_short_message
      @mess.add_label(:inbox)
      @tagger = SupTag.new(@mess)
    end
    it 'will add a given tag' do
      @tagger.archive do
        subj /Test/i, :test
      end
      @mess.labels.should == Set[:test]
    end
    it 'removes the inbox tag' do
      @tagger.archive do
        subj /Test/i, nil
      end
      @mess.labels.should == Set[]
    end
  end
end
