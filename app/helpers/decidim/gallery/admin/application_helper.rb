# frozen_string_literal: true

module Decidim
  module Gallery
    module Admin
      module ApplicationHelper
        def formatted_gallery_name(gallery)
          text = I18n.t("formatted_text",
                        component_name: translated_attribute(gallery.name),
                        space_name: translated_attribute(gallery.participatory_space.title),
                        scope: "decidim.gallery.admin")

          [text, gallery.id]
        end
      end
    end
  end
end
