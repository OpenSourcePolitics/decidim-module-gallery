# frozen_string_literal: true

require "rails"
require "decidim/core"
require "deface"

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

      #initializer "decidim_gallery.deface" do
      #  Rails.application.configure do
      #    config.deface.enabled = true
      #  end
      #end

      initializer "decidim_gallery.webpacker.assets_path" do
        Decidim.register_assets_path File.expand_path("app/packs", root)
      end

      initializer "decidim_gallery.add_cells_view_paths" do
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::Gallery::Engine.root}/app/cells")
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::Gallery::Engine.root}/app/views") # for partials
      end

      initializer "decidim_gallery.action_controller" do
        Rails.application.reloader.to_prepare do
          ActiveSupport.on_load :action_controller do
            ::Decidim::Admin::StaticPagesController.helper Decidim::Gallery::Admin::ApplicationHelper
            ::Decidim::Admin::StaticPageForm.prepend Decidim::Gallery::Admin::StaticPages::Form
            ::Decidim::Admin::CreateStaticPage.prepend Decidim::Gallery::Admin::StaticPages::Command
            ::Decidim::Admin::UpdateStaticPage.prepend Decidim::Gallery::Admin::StaticPages::Command
          end
        end
      end

      initializer "decidim_gallery.register_blocks" do
        Decidim.content_blocks.register(:gallery_page, :gallery_container) do |content_block|
          content_block.cell = "decidim/gallery/main_container"
          content_block.settings_form_cell = "decidim/gallery/page_main_container_settings_form"
          content_block.public_name_key = "decidim.gallery.content_blocks.header.name"

          content_block.settings do |settings|
            settings.attribute :title, type: :string, translated: true
            settings.attribute :gallery_id, type: :integer
            settings.attribute :gallery_per_page, type: :integer, default: 12
            settings.attribute :css, type: :string, default: "medium-up-2 large-up-2"
          end
        end
      end
    end
  end
end
