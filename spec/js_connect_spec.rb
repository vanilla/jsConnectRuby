require_relative "../lib/js_connect.rb"
require 'cgi'
require 'digest/md5'

describe JsConnect do

  let(:client_id) { '12345' }
  let(:secret) { 'thisisasecrethash' }
  let(:data) do
    {
      'uniqueid' => '1',
      'name' => 'John Doe',
      'email' => 'john@doe.com',
      'photourl' => 'http://johndoe.com/avatar.jpg'
    }
  end

  describe "signJsConnect" do
    it "returns a signature" do
      signature = JsConnect.signJsConnect(data, client_id, secret)
      signature.should eq('d4a550344e2557116a328c15eebcc997')
    end

    it "converts the data hash values to string for hexdigest" do
      data['uniqueid'] = 1
      signature = JsConnect.signJsConnect(data, client_id, secret)
      signature.should eq('d4a550344e2557116a328c15eebcc997')
    end
  end

end