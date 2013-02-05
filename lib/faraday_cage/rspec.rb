require 'faraday_cage'
require 'rspec/core'

RSpec.configure do |config|
  [:feature, :request].each do |group|
    config.include FaradayCage::Helpers, type: group
  end

  config.after do
    if self.class.include?(FaradayCage::Helpers)
      FaradayCage.reset!
    end
  end
end
