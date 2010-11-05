Sup Tag
========

A gem to make tagging messages in sup cleaner.

Usage
=====

Messages are tagged using by either the tag or archive block. The tag block will
add the labels while archive adds labels and removes the inbox tag. Each block
consists of methods of the message to call, what they should match against and
the tags to add if the messages match. Tags must always be a symbol, while the
queries may be either strings or regular expressions. It's easiest to see with 
an example:

    tag do
        from 'blake', :self
    end

This would tag any message from 'blake' with self. If no tag is provided then
the given queries are converted to strings and used as labels. For example:

    tag do
        from /blake/i
    end

Here if a message is from 'blake' the message would be tagged as 'blake'. It is
possible to use several queries in one rule as well.

    archive do
        from /blake/, /sweeney/, :self
    end

This would archive any message where the from matches both 'blake' and
'sweeney' as self and the inbox tag would be removed. If the self tag had not
been provided then the message would have been tagged as both 'blake' and
'sweeney'. Tag and archive blocks may have many rules. For example:

    tag
        from /blake/, :self
        subj /sup-talk/i
    end

Here messages from 'blake' are marked as self, while messages with 'sup-talk' in
the subject line are marked as sup talk.

If you wish to tag against several different fields then simply use a multi
block. A multi block will require that all rules in the block hit in order to
tag. 

    tag
        multi :ann, 'ruby-talk'.to_sym do
            recipients /ruby-talk/
            subj /ANN/
        end
    end

This would tag any messages going to 'ruby-talk' with 'ANN' in the subject line.
If tags are provided to the rules in the multi block they will be ignored. 

There are some other probably less useful options. It is possible to archive a
message directly without adding any tags. To do this provide a nil as the tag. 

    archive do
        from /Boring/i, nil
    end

This will archive any message from 'Boring' without adding any tags.

Example
-------

My before-add-message.rb looks something like:

    require 'sup_tag'
    require "sup_tag/extensions/object"

    archive do
      subj /sup-talk/i
      subj /MongoMapper/i, :MM
      subj /easyb-users/i, :easyb
      recipients /ruby-talk/i
      recipients /vim(_|-)mac/i, :vim
      recipients /buildr.apache.org/i, :buildr

      multi :ann do
        recipients /ruby-talk/i
        subj /ANN/i
      end
    end

    tag do
      subj /BIOL\.1010/, :ta
      subj /BIOL\.5870/, :ta
      from /Mbuthia/, :ta
      subj /Nucl. Acids Res/, :nar
      subj /Database Table of Contents/, :biodb
      from /rna@faseb.org/i, :rna
      from /jnls.cust.serv@oxfordjournals.org/, :oxford
    end

Note on Patches/Pull Requests
=============================

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a 
  commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

Copyright
=========

Copyright (c) 2010 Blake Sweeney. See LICENSE for details.
