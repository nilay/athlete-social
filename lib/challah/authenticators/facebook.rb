module Challah
  module Authenticators
    class Facebook

      attr_reader :fb_uid, :token, :current_user, :new_user_attributes, :user_type

      # Main method for authenticating or creating new accounts via FB
      def self.authenticate(*args)
        new(*args).authenticate
      end

      def initialize(options={})
        @fb_uid = options.fetch(:fb_uid, nil)
        @token  = options.fetch(:fb_user_access_token)
        @user_type = options.fetch(:user_type, :fan)
        @current_user = options.fetch(:current_user, nil)
      end

      def authenticate
        if authorizations.empty?
          link_existing_or_create_new_user fb_uid, token, current_user
        else
          authorizations.first.user
        end
      end

      private

      # Will create a new User or link FB account to existing account
      def link_existing_or_create_new_user(fb_uid, token, current_user)
        if current_user.nil?
          create_new_user fb_uid, token, user_type
        else
          set_provider current_user.id
        end
      end

      # Will query FB and create a new User if successful
      # @param [String] fb_uid
      # @param [String] token
      # @returns [User] or nil
      def create_new_user(fb_uid, token, user_type)
        begin
          user_hash = get_user_info_from_access_token(extended_token).symbolize_keys
        rescue Koala::Facebook::APIError => e
          ReportError.call(exception: e)
          return false
        end
        user = user_class.where(email: user_hash[:email]).first_or_initialize
        user.password!(user.generate_password)
        if user.update(first_name: user_hash[:first_name], last_name: user_hash[:last_name])
          set_provider(user.id)
          AutoFollowerJob.new.perform(user.id, user_class)
          user
        else
          ReportError.call(exception: user.errors)
          return false
        end
      end

      def get_user_info_from_access_token(extended_token)
        result = {}
        fb_user = get_user_object_from_access_token(extended_token)
        ::Challah::Facebook.user_fields.each do |field|
          if fb_user.has_key?(field)
            result[field] = fb_user[field]
          else
            result[field] = nil
          end
        end
        result['email'] = result['email'] || "#{fb_uid}@challah.me"
        result
      end

      def get_user_object_from_access_token(access_token)
        graph = ::Koala::Facebook::API.new(access_token)
        graph.get_object("me?fields=#{Challah::Facebook.user_fields.join(',')}")
      end

      # @returns [String] token or false
      def extended_token
        @extended_token ||= begin
          Challah::Facebook::Interface.get_extended_token(token)
        rescue Koala::Facebook::APIError
          false
        end
      end

      # @returns [ActiveRecord::Relation] of Authorizations for FB
      def authorizations
        authorizations = Fan.authorization_model.where(uid: fb_uid, provider: :facebook) + Athlete.authorization_model.where(uid: fb_uid, provider: :facebook)
        authorizations = authorizations.none if fb_uid.nil?
        authorizations
      end

      # Will create an Authorization instance for the FB provider
      def set_provider(user_id)
        user_class.authorization_model.create(uid: fb_uid, token: extended_token, user_id: user_id, provider: "facebook")
      end

      def user_class
        user_type.to_s.capitalize.constantize
      end

    end
  end
end
