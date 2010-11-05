require 'rubygems'
require 'bundler'
Bundler.setup

require 'sinatra'
require 'httparty'

class GoogleAuthorize
  include HTTParty

  def get_auth_key(email, password)
    options = { :body => {"accountType" => "HOSTED", "Email" => email, "Passwd" => password,
      "service" => "writely", "source" => "gofreerange-docalerts-v0.1"}
    }
    response = self.class.post('https://www.google.com/accounts/ClientLogin', options)
    response.body.split("Auth=")[1].chomp
  end
end

class GoogleDocs
  include HTTParty

  def list_docs(auth_key)
    doc_list = "https://docs.google.com/feeds/default/private/full"
    response = self.class.get(doc_list, :headers => {
      "Authorization" => "GoogleLogin auth=#{auth_key}", "GData-Version" => "3.0"
    })
    response.body
  end
end

get '/' do
  "Google-doc-alerts, usage: GET /feed.xml?email=email&password=password"
end

get "/feed.xml" do
  auth_key = GoogleAuthorize.new.get_auth_key(params[:email], params[:password])
  GoogleDocs.new.list_docs(auth_key)
end