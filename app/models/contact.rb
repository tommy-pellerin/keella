class Contact < ApplicationRecord
    belongs_to :user

    validates :issue,
    presence: true,
    length: { in: 4..140 }

  validates :message,
    presence: true,
    length: { in: 20..1000 }
end
