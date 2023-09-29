# frozen_string_literal: true

module Decidim
  module Gallery
    class MainCell < Decidim::ViewModel
      delegate :public_name_key, :has_settings?, to: :model
      delegate :snippets, to: :view_context

      def show
        snippets.add(:foot, helpers.javascript_pack_tag("decidim_gallery", defer: false))

        render gallery_type.to_sym if gallery_component.present?
      end

      def collection
        render "#{gallery_type}_collection"
      end

      def list_items
        return "" if gallery_type == "video"

        render "#{gallery_type}_list"
      end

      def items
        @items ||= Decidim::Gallery::GalleryItem
                   .published
                   .where(decidim_component_id: gallery_component.id)
                   .order(weight: :asc, published_at: :asc)
                   .page(options[:page])
                   .per(per_page)
      end

      def gallery_path(**options)
        current_params = try(:params) || {}
        EngineRouter.main_proxy(gallery_component).root_path({ locale: current_params[:locale] }.reverse_merge(options))
      end

      Settings = Struct.new(:video_url, :title, keyword_init: true)
      Video = Struct.new(:settings, :cache_key_with_version, keyword_init: true)

      def stubbed_video_object(item)
        Video.new(settings: Settings.new(
          video_url: translated_attribute(item.video_url),
          title: translated_attribute(item.title)
        ),
                  cache_key_with_version: item.cache_key_with_version)
      end

      def title
        translated_attribute(gallery_component.name)
      end

      def gallery_component
        @gallery_component ||= Decidim::Component.find_by(id: model.gallery_id)
      end

      def browser
        @browser ||= Browser.new(
          request.headers["User-Agent"],
          accept_language: request.headers["Accept-Language"]
        )
      end

      def current_participatory_space
        controller.try(:current_participatory_space)
      end

      protected

      def view_context
        context.fetch(:view_context)
      end

      def per_page
        gallery_component.settings.items_per_page
      end

      def show_title?
        gallery_component.settings.show_title
      end

      private

      def gallery_type
        gallery_component.settings.gallery_type
      end
    end
  end
end
