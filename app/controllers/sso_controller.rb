require "js_connect"

class SsoController < ActionController::Base
  protect_from_forgery except: :index
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
      jsResponse = JsConnect.getJsConnectResponse(user, self.params, client_id, secret, Digest::SHA1)
      
    rescue StandardError => e
      # 4a. You should handle an error and render out an appropriate response.
      jsResponse = JsConnect::Response.new 400, "text/plain", e.message
    end
    # To use the jsConnect v2 protocol only use:
    # json = JsConnect.getJsConnectString(user, self.params, client_id, secret, secure, Digest::SHA1)

    if jsResponse.status == 302
      redirect_to jsResponse.content, :status => jsResponse.status
    else
      response.status = jsResponse.status
      response.content_type = jsResponse.content_type
      render :js => jsResponse.content
    end
  end
end
