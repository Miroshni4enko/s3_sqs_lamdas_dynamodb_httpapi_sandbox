# frozen_string_literal: true

require 'json'

class Response
  def success(body)
    build_response(200, body)
  end

  def failure(body)
    build_response(500, body)
  end

  private

  def build_response(status_code, body)
    {
      status_code: status_code,
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Credentials": true
      },
      body: body.to_json
    }
  end
end
