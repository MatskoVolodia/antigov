class Unit < ApplicationRecord
  mount_uploader :file, FileUploader

  enum status: %i[pending uploaded]

  has_many :chunks
end
