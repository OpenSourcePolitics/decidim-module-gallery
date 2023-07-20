# frozen_string_literal: true

require "deface"
require "decidim/gallery/admin"
require "decidim/gallery/engine"
require "decidim/gallery/admin_engine"
require "decidim/gallery/component"

module Decidim
  # This namespace holds the logic of the `Gallery` component. This component
  # allows users to create gallery in a participatory space.
  module Gallery
    include ActiveSupport::Configurable

    config_accessor :enable_animation do
      false
    end
  end
end
