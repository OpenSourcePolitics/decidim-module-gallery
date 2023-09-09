# frozen_string_literal: true

module Decidim
  module Gallery
    module Admin
      class CreateGalleryItem < ::Decidim::Gallery.base_command_class
        include ::Decidim::AttachmentAttributesMethods

        def initialize(form, current_user)
          @form = form
          @current_user = current_user
        end

        def call
          return broadcast(:invalid) if @form.invalid?

          transaction do
            create_gallery_item!
          end

          broadcast(:ok, @gallery_item)
        end

        private

        attr_reader :form

        def create_gallery_item!
          @gallery_item = Decidim.traceability.create!(
            GalleryItem,
            @current_user,
            attributes,
            visibility: "all"
          )
        end

        def attributes
          @hash = { title: form.title, component: form.current_component, author: @current_user, weight: form.weight }

          if form.current_component.settings["gallery_type"] == "image"
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
