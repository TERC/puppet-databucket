#! /usr/bin/env ruby -S rspec
require 'spec_helper'

describe "Puppet::Parser::Functions.function(:get_bucketed)" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }
  
  it "should exist" do
    Puppet::Parser::Functions.function("get_bucketed").should == "function_get_bucketed"
  end
  
  it "should raise an ArgumentError if no bucket type is passed" do
    lambda { scope.function_get_bucketed()}.should raise_error(ArgumentError)
  end
end
