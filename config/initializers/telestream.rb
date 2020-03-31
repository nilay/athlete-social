TelestreamCloud.configure(YAML.load(ERB.new(File.read("#{Rails.root}/config/telestream.yml")).result)[Rails.env])
