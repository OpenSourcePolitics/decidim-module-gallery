# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Gallery
    module Admin
      describe CreateGalleryItem do
        subject { described_class.new(form, current_user) }

        let(:current_user) { create :user, :admin, organization: current_component.organization }
        let(:current_component) { create :gallery_component, settings: { gallery_type: "video" } }
        let(:title) { "Gallery item" }

        let(:invalid) { false }
        let(:form) do
          double(
            invalid?: invalid,
            title: { en: title },
            current_component: current_component,
            video_url: "http://www.youtube.com/watch?v=iwGFalTRHDA",
            weight: 1,
            photo: Decidim::Dev.test_file("city.jpeg", "image/jpeg")
          )
        end

        context "when the form is not valid" do
          let(:invalid) { true }

          it "is not valid" do
            expect { subject.call }.to broadcast(:invalid)
          end
        end

        context "when everything is ok" do
          let(:item) { GalleryItem.last }

          it "creates the item" do
            expect { subject.call }.to change(GalleryItem, :count).by(1)
          end

          it "creates a searchable resource" do
            expect { subject.call }.to change(Decidim::SearchableResource, :count).by_at_least(1)
          end

          it "sets the title" do
            subject.call
            expect(translated(item.title)).to eq title
          end

          it "sets the video_url" do
            subject.call
            expect(translated(item.video_url)).to eq "http://www.youtube.com/watch?v=iwGFalTRHDA"
          end
        end
      end
    end
  end
end
