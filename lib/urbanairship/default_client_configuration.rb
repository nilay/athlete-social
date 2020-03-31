require "urbanairship"
 require "urbanairship/configuration"
 
 module Urbanairship
   module DefaultClientConfiguration
     def initialize(key: nil, secret: nil)
       super(key: key, secret: secret)
       @key    ||= Urbanairship.configuration.application_key
       @secret ||= Urbanairship.configuration.master_secret
     end
   end
 
   Urbanairship::Client.prepend(DefaultClientConfiguration)
 end
