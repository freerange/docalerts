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

use Rack::Auth::Basic do |username, password|
  true
end

get "/feed.xml" do
  auth = Rack::Auth::Basic::Request.new(request.env)
  auth_key = GoogleAuthorize.new.get_auth_key(auth.credentials[0], auth.credentials[1])
  GoogleDocs.new.list_docs(auth_key)
end