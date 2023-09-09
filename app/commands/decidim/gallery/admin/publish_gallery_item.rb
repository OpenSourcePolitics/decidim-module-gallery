# frozen_string_literal: true

module Decidim
  module Gallery
    module Admin
      class PublishGalleryItem < ::Decidim::Gallery.base_command_class
        def initialize(gallery_item, current_user)
          @gallery_item = gallery_item
          @current_user = current_user
        end

        def call
          return broadcast(:invalid) if @gallery_item.published?

          transaction do
            publish_gallery_item!
          end

          broadcast(:ok, @gallery_item)
        end

        private

        def publish_gallery_item!
          @gallery_item = Decidim.traceability.perform_action!(
            :publish,
            @gallery_item,
            @current_user,
            visibility: "all"
          ) do
            @gallery_item.publish!
            @gallery_item
          end
        end
      end
    end
  end
end
