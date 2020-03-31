module ApplicationHelper
  def links(current_page:, resource:, total_pages:, user_id: nil, action: nil)
    {
      next: next_paginated_href(current_page: current_page, resource: resource, total_pages: total_pages, user_id: user_id, action: action),
      previous: previous_paginated_href(current_page: current_page, resource: resource, total_pages: total_pages, user_id: user_id, action: action)
    }
  end

  def next_paginated_href(current_page:, resource:, total_pages:, user_id:, action:)
    if current_page < total_pages
      next_page = current_page + 1
      if user_id && action
        polymorphic_url([:api, :v1, action, resource], page: next_page)
      else
        polymorphic_url([:api, :v1, resource], page: next_page)
      end
    end
  end

  def previous_paginated_href(current_page:, resource:, total_pages:, user_id:, action:)
    if current_page > 1
      previous_page = current_page - 1
      if user_id && action
        polymorphic_url([:api, :v1, action, resource], page: previous_page)
      else
        polymorphic_url([:api, :v1, resource], page: previous_page)
      end
    end
  end

  def get_current_user_type(current_user)
    current_user.class.to_s.underscore.to_sym
  end

  def athlete_user?(current_user)
    @user = get_current_user_type(current_user)
    @user.eql? :athlete
  end

  def get_player_status(player)
    if player
      "active"
    else
      "inactive"
    end
  end

  def render_title(title: nil)
    title || "Pros | Admin"
  end
end
