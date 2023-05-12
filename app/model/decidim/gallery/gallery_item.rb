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

      translatable_fields :title

      component_manifest_name "gallery"

      has_one_attached :photo

      scope :created_at_desc, -> { order(arel_table[:created_at].desc) }

      def visible?
        participatory_space.try(:visible?) && component.try(:published?)
      end
    end
  end
end
