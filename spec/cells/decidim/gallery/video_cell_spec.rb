# frozen_string_literal: true

require "spec_helper"

describe Decidim::Gallery::VideoCell, type: :cell do
  include Decidim::TranslationsHelper

  subject { my_cell.call }

  let!(:my_cell) { cell("decidim/gallery/video", model) }
  let!(:model) do
    Video.new(settings: Settings.new(
      video_url: translated_attribute(settings[:video_url]),
      title: translated_attribute(settings[:title])
    ), cache_key_with_version: Time.zone.now)
  end
  let(:settings) do
    {
      title: { en: "Video title", ro: "Titlu pentru video" },
      video_url: "http://youtu.be/iwGFalTRHDA"
    }
  end
  let!(:organization) { create(:organization) }

  Settings = Struct.new(:video_url, :title, keyword_init: true)
  Video = Struct.new(:settings, :cache_key_with_version, keyword_init: true)

  before do
    # To allow expectations on `nil` and suppress this message
    RSpec::Mocks.configuration.allow_message_expectations_on_nil = true
    allow(controller).to receive(:current_organization).and_return(organization)
  end

  it "renders the title" do
    expect(subject).to have_content("Video title")
  end

  context "when having different video providers" do
    context "with youtube link" do
      let(:settings) do
        {
          video_url: "http://www.youtube.com/watch?v=iwGFalTRHDA"
        }
      end

      it "renders the video_url" do
        expect(subject).to have_css(".class-youtube")
        expect(subject).to have_css('iframe[src="//www.youtube.com/embed/iwGFalTRHDA"]')
      end
    end

    context "with youtube link embeded" do
      let(:settings) do
        {
          video_url: "https://www.youtube.com/embed/Dhfy9TPga-c"
        }
      end

      it "renders the video_url" do
        expect(subject).to have_css(".class-youtube")
        expect(subject).to have_css('iframe[src="//www.youtube.com/embed/Dhfy9TPga-c"]')
      end
    end

    context "with dailymotion link" do
      let(:settings) do
        {
          video_url: "https://www.dailymotion.com/video/x84iajl?playlist=x6lgtp"
        }
      end

      it "renders the video_url" do
        expect(subject).to have_css(".class-dailymotion")
        expect(subject).to have_css('iframe[src="//www.dailymotion.com/embed/video/x84iajl"]')
      end
    end

    context "with dailymotion link embeded" do
      let(:settings) do
        {
          video_url: "https://www.dailymotion.com/embed/video/x84j6fx?autoplay=1"
        }
      end

      it "renders the video_url" do
        expect(subject).to have_css(".class-dailymotion")
        expect(subject).to have_css('iframe[src="//www.dailymotion.com/embed/video/x84j6fx"]')
      end
    end

    context "with vimeo link" do
      let(:settings) do
        {
          video_url: "http://vimeo.com/channels/staffpicks/48237094"
        }
      end

      it "renders the video_url" do
        expect(subject).to have_css(".class-vimeo")
        expect(subject).to have_css('iframe[src="//player.vimeo.com/video/48237094"]')
      end
    end
  end
end
