# frozen_string_literal: true

module Decidim
  module Gallery
    # This is the engine that runs on the public interface of `Gallery`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::Gallery::Admin

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil

      routes do
        resources :gallery_item do
          member do
            put :publish
            put :unpublish
          end
        end
        root to: "gallery_item#index"
      end

      def load_seed
        nil
      end
    end
  end
end
