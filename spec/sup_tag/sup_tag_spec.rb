require 'spec_helper'

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
      it 'can tag using several criteria at once' do
        @tagger.tag do
          date /2/, /7/, :self
        end
        @mess.labels.should == Set[:self]
      end
      it 'requires all criteria to match' do
        @tagger.tag do
          date /2/, /blake/, :me
        end
        @mess.labels.should == Set.new
      end
      it 'uses all requirements as the labels if none given' do
        @tagger.tag do
          date /2/, /7/
        end
        @mess.labels.should == Set['2'.to_sym, '7'.to_sym]
      end
      it 'can use a multi tag block to specify requirements on several results' do
        @tagger.tag do
          multi :bob do
            subj /test/i
            date /2/
          end
        end
        @mess.labels.should == Set[:bob]
      end
      it 'requires that all queries in the multi block match to tag' do
        @tagger.tag do
          multi :bob do
            subj /test/i
            date '-1'
          end
        end
        @mess.labels.should == Set[]
      end
      it 'can add several tags with a multi block' do
        @tagger.tag do
          multi :jo, :bob do
            subj /test/i
            date /2/
          end
        end
        @mess.labels.should == Set[:jo, :bob]
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
    it 'does not tag if there is no match' do
      @tagger.archive do
        subj /AWESOME/, :me
      end
      @mess.labels.should == Set[]
    end
    it 'will archive if all querires in a multi block hit' do
      @tagger.archive do
        multi :me do
          subj /Test/
          date '2'
        end
      end
      @mess.labels.should == Set[:me]
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
    it 'does not remove the inbox tag if there is no match' do
      @tagger.archive do
        subj /AWESOME/, :me
        to /other/, :bob
        from /you/, :joe
      end
      @mess.labels.should == Set[:inbox]
    end
    it 'removes the inbox tag if any of the rules match' do
      @tagger.archive do
        subj /AWESOME/, :me
        subj /test/i, :me
        to /people/, :people
      end
      @mess.labels.should == Set[:me]
    end
    it 'archives if all queries hit' do
      @tagger.archive do
        subj /t/, /e/, :hi
      end
      @mess.labels.should == Set[:hi]
    end
    it 'will not archive if all queries do not hit' do
      @tagger.archive do
        subj /t/, /J/, :hi
      end
      @mess.labels.should == Set[:inbox]
    end
  end
end
