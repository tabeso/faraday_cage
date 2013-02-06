require 'active_support/core_ext/module/delegation'
require 'active_support/concern'

require 'faraday_middleware'

require 'faraday_cage/version'
require 'faraday_cage/errors'
require 'faraday_cage/config'
require 'faraday_cage/helpers'
require 'faraday_cage/response'
require 'faraday_cage/server'
require 'faraday_cage/status'

module FaradayCage
  extend self

  def configure
    yield(config)
  end

  def config
    @config ||= Config.new
  end

  def server
    @server ||= Server.new
  end

  def connection
    server.connection
  end

  def reset!
    @server = nil
  end

  delegate(*Config.public_instance_methods(false), to: :config)
end # FaradayCage
