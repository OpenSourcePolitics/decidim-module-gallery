# frozen_string_literal: true

module Decidim
  module Gallery
    module Admin
      class GalleryItemController < ::Decidim::Gallery::Admin::ApplicationController
        def index
          enforce_permission_to :list, :gallery
        end

        def new
          enforce_permission_to :create, :gallery
          @form = form(fetch_form).instance
        end

        def create
          enforce_permission_to :create, :gallery
          @form = form(fetch_form).from_params(params, current_component: current_component)

          CreateGalleryItem.call(@form, current_user) do
            on(:ok) do
              flash[:notice] = I18n.t("gallery_item.create.success", scope: "decidim.gallery.admin")
              redirect_to EngineRouter.admin_proxy(current_component).root_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("gallery_item.create.invalid", scope: "decidim.gallery.admin")
              render action: "new"
            end
          end
        end

        def edit
          enforce_permission_to :update, :gallery, gallery_item: gallery_item
          @form = form(fetch_form).from_model(gallery_item)
        end

        def update
          enforce_permission_to :update, :gallery, gallery_item: gallery_item
          @form = form(fetch_form).from_params(params, current_component: current_component)

          UpdateGalleryItem.call(@form, gallery_item) do
            on(:ok) do
              flash[:notice] = I18n.t("gallery_item.update.success", scope: "decidim.gallery.admin")
              redirect_to EngineRouter.admin_proxy(current_component).root_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("gallery_item.update.invalid", scope: "decidim.gallery.admin")
              render action: "edit"
            end
          end
        end

        def publish
          enforce_permission_to :update, :gallery, gallery_item: gallery_item

          Decidim::Gallery::Admin::PublishGalleryItem.call(gallery_item, current_user) do
            on(:ok) do
              flash[:notice] = I18n.t("gallery_item.publish.success", scope: "decidim.gallery.admin")
              redirect_to EngineRouter.admin_proxy(current_component).root_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("gallery_item.publish.invalid", scope: "decidim.gallery.admin")
              render action: "index"
            end
          end
        end

        def unpublish
          enforce_permission_to :update, :gallery, gallery_item: gallery_item

          Decidim::Gallery::Admin::UnpublishGalleryItem.call(gallery_item, current_user) do
            on(:ok) do
              flash[:notice] = I18n.t("gallery_item.unpublish.success", scope: "decidim.gallery.admin")
              redirect_to root_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("gallery_item.unpublish.invalid", scope: "decidim.gallery.admin")
              render action: "index"
            end
          end
        end

        def destroy
          enforce_permission_to :destroy, :gallery, gallery_item: gallery_item
          gallery_item.destroy!

          flash[:notice] = I18n.t("gallery_item.destroy.success", scope: "decidim.gallery.admin")

          redirect_to root_path
        end

        private

        def fetch_form
          current_component.settings["gallery_type"] == "image" ? GalleryItemImageForm : GalleryItemVideoForm
        end
      end
    end
  end
end
