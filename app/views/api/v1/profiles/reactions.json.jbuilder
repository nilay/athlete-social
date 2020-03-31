json.links links(current_page: @posts.current_page, resource: :posts, total_pages: @posts.total_pages)

json.posts @posts.each do |post|
  json.partial! 'shared/api/v1/post', post: post, complete: true
end
