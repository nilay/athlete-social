class AdminConstraint

  attr_reader :request

  def initialize(request)
    @request = request
  end

  def authorized?
    user && user.class == CmsAdmin
  end

  def self.matches?(request)
    new(request).authorized?
  end

  protected

  def session
    @session ||= Challah::Session.find(request, {}, User)
  end

  def user
    session.user
  end

end
