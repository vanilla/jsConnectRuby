require "js_connect"

# A sample SSO controller that shows you how to use jsConnect
class SsoController < ActionController::Base
  protect_from_forgery except: [:index, :v3]

  @signed_in

  def initialize
    super
    @signed_in = true
  end

  # This endpoint implements jsConnect v3.
  # If you are implementing any new SSO for jsConnect use this method.
  def v3
    jsc = JsConnectV3.new

    # 1. Configure your client ID and secret.
    jsc.set_client_id "123"
    jsc.set_secret "123"

    # 2. Set details of the current user or mark the connection as a guest.
    if @signed_in
      jsc.set_unique_id "123"
      jsc.set_name "John Ruby"
      jsc.set_email "john.ruby@example.com"
      jsc.set_photo_url ""
    else
      jsc.set_guest true
    end

    # 3. Get the redirect URL.
    begin
      url = jsc.generate_response_location self.params
      redirect_to url, :status => 302
    rescue StandardError => e
      # There could be an error too. Make sure to output an appropriate response.
      response.status = 400
      response.content_type = "text/plain"
      render :js => e.message
    end
  end

  # This method supports both v2 and v3 of jsConnect.
  # If you are upgrading your jsConnect you should look at this method.
  def index
    # 1. Get your client ID and secret here. These must match those in your jsConnect settings.
    client_id = "123"
    secret = "123"

    # 2. Grab the current user from your session management system or database here.
    signedIn = true # this is just a placeholder

    # YOUR CODE HERE.

    # 3. Fill in the user information in a way that Vanilla can understand.
    user = {}

    if signedIn
      # CHANGE THESE FOUR LINES.
      user["uniqueid"] = "123"
      user["name"] = "John Ruby"
      user["email"] = "john.ruby@example.com"
      user["photourl"] = ""
    end

    # 4. Generate the jsConnect string.
    begin
      jsResponse = JsConnect.getJsConnectResponse user, self.params, client_id, secret, Digest::SHA1

    rescue StandardError => e
      # 4a. You should handle an error and render out an appropriate response.
      jsResponse = JsConnect::Response.new 400, "text/plain", e.message
    end
    # To use the jsConnect v2 protocol only use:
    # json = JsConnect.getJsConnectString user, self.params, client_id, secret, secure, Digest::SHA1

    if jsResponse.status == 302
      redirect_to jsResponse.content, :status => jsResponse.status
    else
      response.status = jsResponse.status
      response.content_type = jsResponse.content_type
      render :js => jsResponse.content
    end
  end
end
