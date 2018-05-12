class Unit < ApplicationRecord
  enum status: %i[pending uploaded]

  has_many :chunks
end
