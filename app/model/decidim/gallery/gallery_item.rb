# frozen_string_literal: true

module Decidim
  module Gallery
    class GalleryItem < ApplicationRecord
      include Decidim::Resourceable
      include Decidim::HasComponent
      include Decidim::Authorable
      include Decidim::TranslatableResource
      include Decidim::Publicable
      include Decidim::HasUploadValidations

      include Traceable
      include Loggable

      translatable_fields :title, :video_url

      component_manifest_name "gallery"

      has_one_attached :photo
      validates_upload :photo, uploader: Decidim::ImageUploader

      scope :created_at_desc, -> { order(arel_table[:created_at].desc) }

      def visible?
        participatory_space.try(:visible?) && component.try(:published?)
      end

      def video_url=(value)
        data[:video_url] = value
      end

      def video_url
        data.fetch("video_url", {})
      end
    end
  end
end
