json.set! @session.user.class.to_s.underscore do
  json.partial! 'shared/api/v1/user', user: @session.user
end
