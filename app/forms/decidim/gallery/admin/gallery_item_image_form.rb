# frozen_string_literal: true

module Decidim
  module Gallery
    module Admin
      class GalleryItemImageForm < GalleryItemForm
        include Decidim::HasUploadValidations

        attribute :photo
        attribute :remove_photo, Boolean, default: false
      end
    end
  end
end
