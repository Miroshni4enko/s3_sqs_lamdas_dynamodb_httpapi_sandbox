# frozen_string_literal: true

require 'json'
require_relative '../../../common/adapters/dynamo_db_adapter'
require_relative '../../../common/adapters/response'

def call(event:, context:)
  result = DynamoDBAdapter.new.delete_item(event["pathParams"]["id"])

  if result
    Response.new.success("'deleted': true")
  else
    Response.new.failure("'error': 'Could not find task with id: #{event["pathParams"]["id"]}'")
  end
end
