# frozen_string_literal: true

module Decidim
  module Gallery
    module Admin
      class GalleryItemVideoForm < GalleryItemForm
        translatable_attribute :video_url, String
        validates :video_url, translatable_presence: true
      end
    end
  end
end
