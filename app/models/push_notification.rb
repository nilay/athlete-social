class PushNotification < ApplicationRecord
  enum status: { pending: 0, successful: 1, failed: 2 }

end
