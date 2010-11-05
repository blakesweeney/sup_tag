require 'spec_helper'

describe 'Binding' do
  context '[]' do
    it 'can get the value of a variable' do
      @message = 'hi'
      binding[:@message].should == 'hi'
    end
    it 'can get the value of a method' do
      def bob
        return 'jones'
      end
      binding['bob'].should == 'jones'
    end
  end
end
