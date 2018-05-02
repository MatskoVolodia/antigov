class Unit < ApplicationRecord
  mount_uploader :file, FileUploader

  enum status: %i[pending uploaded]
end
