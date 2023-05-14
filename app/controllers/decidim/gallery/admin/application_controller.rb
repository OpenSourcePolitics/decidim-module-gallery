# frozen_string_literal: true

module Decidim
  module Gallery
    module Admin
      # This controller is the abstract class from which all other controllers of
      # this engine inherit.
      #
      # Note that it inherits from `Decidim::Admin::Components::BaseController`, which
      # override its layout and provide all kinds of useful methods.
      class ApplicationController < Decidim::Admin::Components::BaseController
        helper_method :gallery_items, :gallery_item

        def gallery_items
          @gallery_items ||= GalleryItem.where(component: current_component).page(params[:page]).per(15)
        end

        def gallery_item
          @gallery_item ||= gallery_items.find(params[:id])
        end
      end
    end
  end
end
