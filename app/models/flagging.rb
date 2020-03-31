class Flagging < ApplicationRecord
  enum status: { pending_review: 0, approved: 1, rejected: 2 }
end
