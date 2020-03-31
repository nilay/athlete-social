class Ability
  include CanCan::Ability

  def initialize(user)
    if user.class == Athlete
      can :show, Post
      can :index, Post
      can :like, Post
      can :top, Post
      can :by_athlete, Post
      can :flag, Post
      can :unlike, Post
      can :dislike, Post
      can :undislike, Post
      can :manage, Post, athlete_id: user.id
      can :show, Question
      can :like, Question
      can :unlike, Question
      can :dislike, Question
      can :undislike, Question
      can :manage, Question, { questioner_id: user.id, questioner_type: "athlete" }
      can :like, Comment
      can :dislike, Comment
      can :manage, Comment, athlete_id: user.id
      can :follow, Athlete
      can :unfollow, Athlete
      can :manage, Athlete, id: user.id
      can :create, Invitation
    elsif user.class == Fan
      can :show, Post
      can :top, Post
      can :by_athlete, Post
      can :index, Post
      can :flag, Post
      can :like, Post
      can :unlike, Post
      can :dislike, Post
      can :undislike, Post
      can :follow, Athlete
      can :unfollow, Athlete
      cannot :create, Question
      can :show, Question
      can :like, Question
      can :unlike, Question
      can :dislike, Question
      can :undislike, Question
      can :like, Comment
      can :dislike, Comment
      can :manage, Fan, id: user.id
    elsif user.class == BrandUser
      can :manage, Question, { questioner_id: user.id, questioner_type: "athlete" }
      can :manage, BrandUser, { brand_id: user.brand_id }
    elsif user.class == CmsAdmin
      can :manage, :all
      can :create, Invitation
    end
  end
end
