module Urbanairship
  def self.configuration
    @configuration ||= Urbanairship::Configuration.new
  end

  def self.configure(&block)
    yield configuration
  end

  class Configuration
    attr_accessor :application_key
    attr_accessor :master_secret

    def initialize
      @application_key = ENV["URBANAIRSHIP_APPLICATION_KEY"]
      @master_secret   = ENV["URBANAIRSHIP_MASTER_SECRET"]
    end
  end
end
