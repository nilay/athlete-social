json.links links(current_page: @athletes.current_page, resource: @user.class.to_s.pluralize.underscore.to_sym, total_pages: @athletes.total_pages, action: params[:action], user_id: @user.id)

json.athletes @athletes.each do |athlete|
  json.partial! 'shared/api/v1/athlete', athlete: athlete
  json.avatar athlete, partial: "shared/api/v1/avatar", as: :user
  json.followed_by_current_user athlete.followed_by?(current_user)
end
