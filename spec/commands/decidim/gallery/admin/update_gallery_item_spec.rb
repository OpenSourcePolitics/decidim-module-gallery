# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Gallery
    module Admin
      describe UpdateGalleryItem do
        subject { described_class.new(form, gallery_item) }

        shared_examples_for "manage gallery item" do |_options|
          let(:base_attributes) { { invalid?: invalid, title: { en: title }, current_component: current_component, weight: 1 } }

          let(:title) { "Gallery item" }
          let(:attributes) { {} }
          let(:form) do
            double(base_attributes.merge(attributes))
          end

          let(:invalid) { false }
          context "when the form is not valid" do
            let(:invalid) { true }

            it "is not valid" do
              expect { subject.call }.to broadcast(:invalid)
            end

            it "doesn't update the item" do
              expect(gallery_item).not_to receive(:update!)
              subject.call
            end
          end

          context "when everything is ok" do
            let(:title) { "New title" }

            it "updates the title" do
              subject.call
              expect(translated(gallery_item.title)).to eq title
            end

            it "broadcasts ok" do
              expect { subject.call }.to broadcast(:ok)
            end

            it "creates a searchable resource" do
              expect { subject.call }.to change(Decidim::SearchableResource, :count).by_at_least(1)
            end
          end
        end

        context "when image" do
          it_behaves_like "manage gallery item" do
            let(:current_user) { create :user, :admin, organization: current_component.organization }
            let(:current_component) { create :gallery_component, :video }
            let(:gallery_item) { create :video_gallery_item, component: current_component, author: current_user }
            let(:attributes) { { video_url: "http://www.youtube.com/watch?v=iwGFalTRHDA" } }
          end
        end

        context "when video" do
          it_behaves_like "manage gallery item" do
            let(:current_user) { create :user, :admin, organization: current_component.organization }
            let(:current_component) { create :gallery_component, :image }
            let(:gallery_item) { create :image_gallery_item, component: current_component, author: current_user }
            let(:attributes) { { photo: Decidim::Dev.test_file("city.jpeg", "image/jpeg") } }
          end
        end
      end
    end
  end
end
