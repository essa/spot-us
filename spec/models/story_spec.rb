require File.dirname(__FILE__) + '/../spec_helper'

describe Story do

  requires_presence_of Story, :headline
  requires_presence_of Story, :location
  
  it { Factory(:story).should belong_to(:pitch) }
  it { Factory(:story).should belong_to(:user) }
  
  describe "to support STI" do
    it "descends from NewItem" do
      Story.ancestors.include?(NewsItem)
    end
  end
  
  describe "A Story's status" do
    before(:each) do
      @story = Factory(:story)
    end
    
    it "should be initialized as 'draft'" do
      @story.should be_draft
    end
    
    it "should transition from 'draft' to 'fact_check'" do
      @story.update_attribute(:status,'draft')
      @story.verify!
      @story.should be_fact_check
    end
    
    it "should transition from 'fact_check' to 'ready'" do
      @story.update_attribute(:status,'fact_check')
      @story.accept!
      @story.should be_ready
    end
    
    it "should transition from 'fact_check' to 'draft'" do
      @story.update_attribute(:status,'fact_check')
      @story.reject!
      @story.should be_draft
    end
    
    
    
    it "should transition from 'ready' to 'published'" do
      @story.update_attribute(:status,'ready')
      @story.publish!
      @story.should be_published
    end
  end

end