# frozen_string_literal: true

module Decidim
  module Gallery
    module Admin
      class GalleryItemForm < Decidim::Form
        alias organization current_organization

        include Decidim::TranslatableAttributes
        translatable_attribute :title, String
        attribute :weight, Integer, default: 0

        validates :title, translatable_presence: true
      end
    end
  end
end
