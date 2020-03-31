module ErrorSerializer

  def self.serialize(errors)
    return if errors.nil?

    json = {}
    json[:errors] = errors.to_hash.map do |key, message|
      [message].flatten.map {|msg| { id: key, title: msg } }
    end.flatten
    json
  end

end
