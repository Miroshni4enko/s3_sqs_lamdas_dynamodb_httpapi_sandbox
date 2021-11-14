# frozen_string_literal: true

require 'json'
require 'uuid'
require_relative '../../../common/adapters/dynamo_db_adapter'
require_relative '../../../common/adapters/response'

def call(event:, context:)
  request_payload = JSON.parse(event.body)
  id = UUID.new.generate
  name = request_payload['name']
  description = request_payload['description']
  status = request_payload['status']

  return json error: "Please provide both 'id' and 'name'" unless id && name

  result = DynamoDBAdapter.new.create_item({
    item: {
      'id': id,
      'name': name,
      'description': description,
      'status': status,
    }
  })
  Response.new.success(result)
end
