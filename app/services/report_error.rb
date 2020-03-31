class ReportError
  def self.call(exception:, **options)
    Rails.logger.info exception.inspect
    NewRelic::Agent.notice_error(exception, options)
  end
end
