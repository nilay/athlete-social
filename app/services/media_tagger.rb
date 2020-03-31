class MediaTagger
  attr_reader :media_id, :media_type, :tags

  def initialize(media_id, media_type, tags)
    @media_id   = media_id
    @media_type = media_type
    @tags       = tags
  end

  def run
    append_tags_to_media
    notify_tagged_users
  end

  def self.call(*args)
    new(*args).run
  end

  private

  def append_athlete_tags_to_media
    media.athletes_tagged_list = tags.select{ |t| t.exclude?('#') }.join(', ')
  end

  def append_hash_tags_to_media
    media.hashtag_list = tags.select{ |t| t.include?('#') }.join(', ')
  end

  def append_tags_to_media
    append_athlete_tags_to_media
    append_hash_tags_to_media
    media.save!
  end

  def notify_tagged_users
    global_ids = media.tagged_athletes.map { |a| a.to_global_id.to_s }
    PushNotifierJob.perform_async(global_ids,
                                  "You have been tagged in #{media.owner_name}'s #{media_type}!",
                                  "pros://#{media_type.pluralize}/#{media_id}")
  end

  def media
    @media ||= media_type.capitalize.constantize.find(media_id)
  end

end
