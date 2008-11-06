require File.dirname(__FILE__) + '/../spec_helper'

# dummy class on which to test
class DummyPersonForTestOfValidateable
  include Validateable
  attr_accessor :age, :emails
  validates_numericality_of :age
  validates_length_of       :emails,    :within => 3..1000
  validates_format_of       :emails, :with => %r{(\S*)@(\S*)\s*(,\s*(\S*)@(\S*))*}, :allow_blank => false
end

describe "validateable module" do
  Person = DummyPersonForTestOfValidateable

  describe "validation" do
    it "handles valid record" do
      person = Person.new
      person.age = '47'
      person.emails = 'tnakajima@brain-tokyo.jp'
      person.should be_valid
    end

    it "handles validates_nemericality_of" do
      person = Person.new
      person.age = 'not a number'
      person.emails = 'tnakajima@brain-tokyo.jp'
      person.should_not be_valid
    end

    it "handles validates_length_of" do
      person = Person.new
      person.age = '47'
      person.emails = 'tnakajima' * 1000 + '@brain-tokyo.jp'
      person.should_not be_valid
    end

    it "handles validates_format_of" do
      person = Person.new
      person.age = '47'
      person.emails = 'tnakajima'
      person.should_not be_valid
    end
  end

  describe "error message" do
    it "handles error messages" do
      person = Person.new
      person.age = 'not a number'
      person.emails = 'tnakajima'
      person.should_not be_valid
      person.should have(2).errors
      person.errors[:age].should == "is not a number"
      person.errors[:emails].should == "is invalid"
    end
  end
end

