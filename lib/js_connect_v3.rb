require "jwt"

# Implements the jsConnect v3 protocol.
class JsConnectV3
  VERSION = "java:3"

  ALG_HS256 = "HS256"
  ALG_HS384 = "HS384"
  ALG_HS512 = "HS512"

  FIELD_UNIQUE_ID = "id"
  FIELD_PHOTO = "photo"
  FIELD_NAME = "name"
  FIELD_EMAIL = "email"
  FIELD_ROLES = "roles"
  FIELD_JWT = "jwt"
  FIELD_STATE = "st"
  FIELD_USER = "u"
  FIELD_REDIRECT_URL = "rurl"
  FIELD_CLIENT_ID = "kid"
  FIELD_TARGET = "t"

  FIELD_MAP = {
      "uniqueid" => FIELD_UNIQUE_ID,
      "photourl" => FIELD_PHOTO,
  }

  TIMEOUT = 600

  @secret

  @client_id

  @user

  @guest

  @algorithm

  @version

  @timestamp

  def initialize
    super

    @user = {}
    @guest = false
    @algorithm = ALG_HS256
    @version = "ruby:3"
    @timestamp = 0
  end

  # @param [String] value
  def set_client_id(value)
    @client_id = value
  end

  # @param [String] value
  def set_secret(value)
    @secret = value
  end

  # @param [String] key
  def set_user_field(key, value)
    key = FIELD_MAP.fetch key.downcase, key

    @user[key] = value
  end

  # @param [String] value
  def set_email(value)
    set_user_field FIELD_EMAIL, value
  end

  # @param [String] value
  def set_name(value)
    set_user_field FIELD_NAME, value
  end

  # @param [String] value
  def set_photo_url(value)
    set_user_field FIELD_PHOTO, value
  end

  # @param [String] value
  def set_unique_id(value)
    set_user_field FIELD_UNIQUE_ID, value
  end

  # @param [Boolean] value
  def set_guest(value)
    @guest = value
  end

  # Validate that a field in a collection exists.
  def validate_field_exists(field, collection, collection_name = "payload", validate_empty = true)
    if collection == nil
      raise "Invalid collection: #{collection_name}"
    end

    unless collection.has_key?(field)
      raise "Missing field: #{collection_name}[#{field}]"
    end

    if validate_empty && collection[field] == ""
      raise "Field cannot be empty: #{collection_name}[#{field}]"
    end

    return collection[field]
  end

  # Decode a JWT token.
  def jwt_decode(jwt)
    begin
      decoded = JWT.decode jwt, @secret, true
    rescue JWT::DecodeError => e;
      raise(JWT::DecodeError, "There was an error decoding the JWT: " + e.message)
    end
    header = decoded[1]
    payload = decoded[0]

    return payload
  end

  # Get the current timestamp used to sign and validate tokens.
  def get_timestamp
    @timestamp > 0 ? @timestamp : Time.now.to_i
  end

  # Encode a JWT and add default headers.
  def jwt_encode(payload)
    payload = {
        "v" => @version,
        "iat" => get_timestamp,
        "exp" => get_timestamp + TIMEOUT
    }.merge(payload)

    jwt = JWT.encode(payload, @secret, @algorithm, header_fields = { FIELD_CLIENT_ID => @client_id })

    return jwt
  end

  # Generate the response location.
  # Call this method and then 302 redirect to the returned URL.
  def generate_response_location(query)
    jwt = validate_field_exists FIELD_JWT, query, "query"
    request = jwt_decode jwt
    url = validate_field_exists FIELD_REDIRECT_URL, request

    if @guest
      data = {
          FIELD_USER => {},
          FIELD_STATE => request.fetch(FIELD_STATE, {})
      }
    else
      data = {
          FIELD_USER => @user,
          FIELD_STATE => request.fetch(FIELD_STATE, {})
      }
    end

    response = jwt_encode data
    location = url + "#jwt=" + response

    return location
  end
end
