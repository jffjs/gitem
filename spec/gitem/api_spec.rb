require 'spec_helper'

describe Gitem::API do
  
  describe ".watched_repos" do
    
    before do
      stub_request(:get, Gitem::API.base_uri + '/repos/watched/jffjs').
        to_return(:body => fixture('watched_repos.json'),
                  :headers => { :content_type => 'application/json; charset=utf8' })
    end
    
    it "should retrieve the correct resource" do
      Gitem::API.watched_repos("jffjs")
      a_request(:get, Gitem::API.base_uri + '/repos/watched/jffjs').
        should have_been_made
    end
  end

  describe ".repo" do

     before do
      stub_request(:get, Gitem::API.base_uri + '/repos/show/schacon/grit').
        to_return(:body => fixture('repo.json'),
                  :headers => { :content_type => 'application/json; charset=utf8' })
    end
   
    it "should retrieve the correct resource" do
      Gitem::API.repo("schacon", "grit")
      a_request(:get, Gitem::API.base_uri + '/repos/show/schacon/grit').
        should have_been_made
    end
  end
end
