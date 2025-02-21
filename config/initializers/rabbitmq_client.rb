require 'bunny'

class RabbitMQClient
  def self.connection
    @connection ||= Bunny.new(
      host: ENV['RABBITMQ_HOST'],
      port: ENV['RABBITMQ_PORT'],
      user: ENV['RABBITMQ_USER'],
      password: ENV['RABBITMQ_PASSWORD']
    ).tap(&:start)
  end

  def self.channel
    @channel ||= connection.create_channel
  end
end
