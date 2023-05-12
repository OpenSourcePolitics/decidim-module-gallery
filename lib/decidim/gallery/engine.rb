# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module Gallery
    # This is the engine that runs on the public interface of gallery.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Gallery

      routes do
        # Add engine routes here
        # resources :gallery
        root to: "gallery#index"
      end

      initializer "decidim_gallery.webpacker.assets_path" do
        Decidim.register_assets_path File.expand_path("app/packs", root)
      end

      initializer "decidim_gallery.add_cells_view_paths" do
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::Gallery::Engine.root}/app/cells")
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::Gallery::Engine.root}/app/views") # for partials
      end
    end
  end
end
