json.links links(current_page: @athletes.current_page, resource: :athletes, total_pages: @athletes.total_pages)

json.athletes @athletes.each do |athlete|
  json.partial! 'shared/admin/athlete', athlete: athlete
end
