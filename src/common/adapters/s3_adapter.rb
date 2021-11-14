# frozen_string_literal: true

require 'aws-sdk-s3'
require 'logger'

class S3Adapter
  def initialize
    @client = Aws::S3::Client.new
  end

  def send_message(message)
    client.send_message(
      queue_url: ENV['QUEUE_URL'],
      message_body: message
    )
    logger.info('Created S3 message')
  rescue Aws::S3::Errors::ServiceError => error
    logger.error(error)
  end

  private

  attr_reader :client

  def logger
    @logger ||= Logger.new($stdout)
  end
end
