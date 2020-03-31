json.links links(current_page: @brands.current_page, resource: :brands, total_pages: @brands.total_pages)

json.athletes @brands.each do |brand|
  json.(brand, :id, :name, :description)
  json.avatar do
    json.thumbnail_url athlete.avatar.file.url(:thumb)
    json.medium_url    athlete.avatar.file.url(:medium)
    json.original_url  athlete.avatar.file.url
  end
end
