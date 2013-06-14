require_relative "../lib/js_connect.rb"
require 'cgi'
require 'digest/md5'
require 'json'

class DummyJSON

  def self.encode(result)
    result
  end

end

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
    it "returns a signature based on MD5" do
      signature = JsConnect.signJsConnect(data, client_id, secret)
      signature.should eq('d4a550344e2557116a328c15eebcc997')
    end

    it "converts the data hash values to string for hexdigest" do
      data['uniqueid'] = 1
      signature = JsConnect.signJsConnect(data, client_id, secret)
      signature.should eq('d4a550344e2557116a328c15eebcc997')
    end

    context "when specifying SHA1 as digest" do
      it "returns a signature with SHA1 as digest" do
        signature = JsConnect.signJsConnect(data, client_id, secret, false, Digest::SHA1)
        signature.should eq('d57a237e617f19454ac888047d386e5878d78fe7')
      end
    end    
  end

  describe "getJsConnectString" do
    before(:each) do
      stub_const("ActiveSupport::JSON", DummyJSON)
    end

    it "uses MD5 digest by default" do
      timestamp = Time.now.to_i
      signature = Digest::MD5.hexdigest(timestamp.to_s + secret)
      request = { 'client_id' => '12345', 'timestamp' => timestamp.to_s, 'signature' => signature }

      Digest::MD5.should_receive(:hexdigest).with(timestamp.to_s + secret).and_call_original
      JsConnect.should_receive(:signJsConnect).with(data, client_id, secret, true, Digest::MD5)
      JsConnect.getJsConnectString(data, request, client_id, secret)
    end

    context "when specifying a SHA1 as digest" do
      it "uses SHA1 digest instead of the default" do
        timestamp = Time.now.to_i
        signature = Digest::SHA1.hexdigest(timestamp.to_s + secret)
        request = { 'client_id' => '12345', 'timestamp' => timestamp.to_s, 'signature' => signature }

        Digest::SHA1.should_receive(:hexdigest).with(timestamp.to_s + secret).and_call_original
        JsConnect.should_receive(:signJsConnect).with(data, client_id, secret, true, Digest::SHA1)
        JsConnect.getJsConnectString(data, request, client_id, secret, true, Digest::SHA1)
      end
    end
  end

end