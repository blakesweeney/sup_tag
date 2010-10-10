$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'sup_tag'
require "rubygems"
require "sup"
require 'spec'
require 'spec/autorun'
require 'stringio'
require 'rmail'
require 'uri'
require 'set'
require 'dummy_source'

SHORT_STR =<<-EOM
Return-path: <fake_sender@example.invalid>
Envelope-to: fake_receiver@localhost
Delivery-date: Sun, 09 Dec 2007 21:48:19 +0200
Received: from fake_sender by localhost.localdomain with local (Exim 4.67)
      (envelope-from <fake_sender@example.invalid>)
      id 1J1S8R-0006lA-MJ
      for fake_receiver@localhost; Sun, 09 Dec 2007 21:48:19 +0200
Date: Sun, 9 Dec 2007 21:48:19 +0200
Mailing-List: contact example-help@example.invalid; run by ezmlm
Precedence: bulk
List-Id: <example.list-id.example.invalid>
List-Post: <mailto:example@example.invalid>
List-Help: <mailto:example-help@example.invalid>
List-Unsubscribe: <mailto:example-unsubscribe@example.invalid>
List-Subscribe: <mailto:example-subscribe@example.invalid>
Delivered-To: mailing list example@example.invalid
Delivered-To: moderator for example@example.invalid
From: Fake Sender <fake_sender@example.invalid>
To: Fake Receiver <fake_receiver@localhost>
CC: Fake Person <fake_person@someplace>
BCC: Important Person <person@important>
Subject: Re: Test message subject
Message-ID: <20071209194819.GA25972@example.invalid>
References: <E1J1Rvb-0006k2-CE@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1J1Rvb-0006k2-CE@localhost.localdomain>
User-Agent: Sup/0.3

Test message!
EOM

# Simple method to get a short message
def get_short_message
  source = Redwood::DummySource.new("sup-test://test_simple_message")
  source.messages = [ SHORT_STR ]
  source_info = 0
  mess = Redwood::Message.new( {:source => source, :source_info => source_info } )
  mess.load_from_source!
  return mess
end
