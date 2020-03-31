json.applinks do
  json.apps do
    json.array! []
  end
  json.details do
    json.array! do
      json.appID  ENV["DEEP_LINK_ID"]
      json.paths do
        json.array! [ "*" ]
      end
    end
  end
end
