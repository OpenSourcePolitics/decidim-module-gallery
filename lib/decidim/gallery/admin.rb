# frozen_string_literal: true

module Decidim
  module Gallery
    # This module contains all the domain logic associated to Decidim's Gallery
    # component admin panel.
    module Admin
      module StaticPages
        autoload :Command, "decidim/gallery/admin/static_pages/command"
        autoload :Form, "decidim/gallery/admin/static_pages/form"
      end
    end
  end
end
