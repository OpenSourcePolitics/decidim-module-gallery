# frozen_string_literal: true

module Decidim
  module Gallery
    class VideoCell < Decidim::ViewModel
      include Decidim::SanitizeHelper

      PROVIDERS = {
        "youtube" => :youtube,
        "youtu.be" => :youtube,
        "vimeo" => :vimeo,
        "dai.ly" => :dailymotion,
        "dailymotion" => :dailymotion
      }.freeze

      def show
        return if embeded_video_url.nil?

        render
      end

      def translated_title
        @translated_title ||= translated_attribute(model.settings.title)
      end

      def cache_hash
        hash = []
        hash.push(I18n.locale)
        hash.push(model.cache_key_with_version)
        hash.join(Decidim.cache_key_separator)
      end

      private

      def video_url
        model.settings.video_url
      end

      def embeded_video_url
        send("#{video_provider}_url".to_sym) if video_provider
      end

      def youtube_url
        return if video_id_youtube.blank?

        "//www.youtube.com/embed/#{video_id_youtube}"
      end

      def vimeo_url
        return if video_id_vimeo.blank?

        "//player.vimeo.com/video/#{video_id_vimeo}"
      end

      def dailymotion_url
        return if video_id_dailymotion.blank?

        "//www.dailymotion.com/embed/video/#{video_id_dailymotion}"
      end

      def video_id_youtube
        @video_id_youtube ||= begin
          regex_id = %r{(?:youtube(?:-nocookie)?\.com/(?:[^/\n\s]+/\S+/|(?:v|e(?:mbed)?)/|\S*?[?&]v=)|youtu\.be/)([a-zA-Z0-9_-]{7,11})}
          match_value = regex_id.match(video_url)
          match_value[1] if match_value && match_value[1].present?
        end
      end

      def video_id_dailymotion
        @video_id_dailymotion ||= begin
          regex_id = %r{(?:dailymotion\.com|dai\.ly)/(?:embed/)?(?:video/)?([a-zA-Z0-9]*)}
          match_value = regex_id.match(video_url)
          match_value[1] if match_value && match_value[1].present?
        end
      end

      def video_id_vimeo
        @video_id_vimeo ||= begin
          regex_id = %r{vimeo\.com/(?:channels/(?:\w+/)?|groups/[^/]*/videos/|video/|)(\d+)(?:|/\?)}
          match_value = regex_id.match(video_url)
          match_value[1] if match_value && match_value[1].present?
        end
      end

      def video_provider
        @video_provider ||= begin
          regex_prov = /(youtube|youtu\.be|vimeo|dai\.ly|dailymotion)/
          match_prov = regex_prov.match(video_url)
          return unless match_prov && match_prov[1].present?

          PROVIDERS[match_prov[1]]
        end
      end
    end
  end
end
