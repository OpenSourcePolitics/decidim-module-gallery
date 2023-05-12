# frozen_string_literal: true

module Decidim
  module Gallery
    module Admin
      class UpdateGalleryItem < Rectify::Command
        include ::Decidim::AttachmentAttributesMethods

        def initialize(form, gallery_item)
          @form = form
          @gallery_item = gallery_item
        end

        def call
          return broadcast(:invalid) if form.invalid?

          transaction do
            update_gallery_item!
          end

          broadcast(:ok, @gallery_item)
        end

        private

        attr_reader :form

        def update_gallery_item!
          @gallery_item.update!(**attributes)
        end

        def attributes
          @hash = { title: form.title, weight: form.weight }
          if @form.current_component.settings["gallery_type"] == "image"
            @hash.merge!(attachment_attributes(:photo))
          else
            @hash.merge!(video_url: form.video_url)
          end
          @hash
        end
      end
    end
  end
end
