# frozen_string_literal: true

require 'aws-sdk-dynamodb'
require 'logger'

class DynamoDBAdapter
  def initialize
    @client = Aws::DynamoDB::Client.new
  end

  def create_item(item)
    @client.put_item(table_item(item))
    logger.info("Created dynamoDB item with id=#{item[:id]}")
  rescue Aws::DynamoDB::Errors::ServiceError => error
    logger.error(error)
  end

  def get_item(id)
    result = @client.get_item(
      key: { 'id': id},
      table_name: ENV['TASKS_TABLE']
    )

    logger.info("Found item #{item.to_s}")

    result.item
  rescue Aws::DynamoDB::Errors::ServiceError => error
    logger.error(error)
  end

  def get_items
    result = @client.scan(
      table_name: ENV['TASKS_TABLE']
    )

    logger.info("Found items #{items.to_s}")

    result.items
  rescue Aws::DynamoDB::Errors::ServiceError => error
    logger.error(error)
  end

  def update_item(id, body)
    table_item = {
      table_name: ENV['TASKS_TABLE'],
      key: {
        id: body['id'],
      },
      update_expression: "SET #task_name = :name, description = :description, #task_status = :status",
      expression_attribute_values: {
        ':name': body['name'],
        ':description': body['description'],
        ':status': body['status']
      },
      expression_attribute_names: {
        '#task_name': "name",
        '#task_status': "status"
      },
      return_values: 'UPDATED_NEW'
    }
    result = @client.update_item(table_item)

    logger.info("Item updated successfully #{result.attributes}")

    result.attributes
  rescue Aws::DynamoDB::Errors::ServiceError => error
    logger.error(error)
  end

  def delete_item(id)
    result = dynamodb_client.delete_item(
      key: { 'id': params[:id] },
      table_name: ENV['TASKS_TABLE']
    )
    logger.info("Deleted dynamoDB item with id=#{id}")

    result
  rescue Aws::DynamoDB::Errors::ServiceError => error
    logger.error(error)
  end

  private

  def logger
    @logger ||= Logger.new($stdout)
  end

  def table_item(item)
    {
      table_name: ENV['TABLE_NAME'],
      item: item
    }
  end
end
