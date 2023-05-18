# frozen_string_literal: true

require "decidim/core/test/factories"

FactoryBot.define do
  VIDEO_LIST = [
    "http://www.youtube.com/watch?v=iwGFalTRHDA",
    "https://www.dailymotion.com/video/x8kvv9s",
    "http://vimeo.com/channels/staffpicks/48237094"
  ].freeze

  factory :gallery_component, parent: :component do
    name { Decidim::Components::Namer.new(participatory_space.organization.available_locales, :gallery).i18n_name }
    manifest_name { :gallery }
    participatory_space { create(:assembly) }
    published_at { 4.hours.ago }

    trait :video do
      settings do
        {
          gallery_type: :video
        }
      end
    end

    trait :image do
      settings do
        {
          gallery_type: :image
        }
      end
    end

    trait :with_items do
      after(:create) do |gallery, _evaluator|
        create_list("#{gallery.settings.gallery_type}_gallery_item".to_sym, 6, :published, component: gallery)
      end
    end
  end

  factory :gallery_item, class: "Decidim::Gallery::GalleryItem" do
    component { build(:component, :published, manifest_name: "gallery") }
    author { build(:user, :confirmed, organization: component.organization) }
    title { Decidim::Faker::Localized.sentence(word_count: 3) }

    trait :published do
      published_at { Time.current }
    end
  end

  factory :image_gallery_item, parent: :gallery_item do
    photo { Decidim::Dev.test_file("city.jpeg", "image/jpeg") }
  end

  factory :video_gallery_item, parent: :gallery_item do
    sequence(:video_url) { |n| { en: VIDEO_LIST[n % 3] } }
  end
end
