#! /usr/bin/env ruby -S rspec
require 'spec_helper'

describe "Puppet::Parser::Functions.function(:bucketed)" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }
  
  it "should exist" do
    Puppet::Parser::Functions.function("bucketed").should == "function_bucketed"
  end
  
  it "should raise an ArgumentError if no bucket type is passed" do
    lambda { scope.function_bucketed()}.should raise_error(ArgumentError)
  end
end
