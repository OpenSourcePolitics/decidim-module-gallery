# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Gallery
    module Admin
      describe UnpublishGalleryItem do
        let(:current_user) { create :user, :admin, organization: current_component.organization }
        let(:current_component) { create :gallery_component, settings: { gallery_type: "video" } }
        let(:gallery_item) { create :gallery_item, component: current_component, author: current_user, published_at: Time.current }

        let(:command) { described_class.new(gallery_item, current_user) }

        context "when unpublish action is performed" do
          it "broadcasts ok" do
            expect { command.call }.to broadcast(:ok)
          end

          it "publishes the amendment and the emendation" do
            expect(gallery_item.class.last.published?).to be(true)
            command.call
            expect(gallery_item.class.last.published?).to be(false)
          end

          it "traces the action", versioning: true do
            expect(Decidim.traceability)
              .to receive(:perform_action!)
              .with(
                :unpublish,
                gallery_item,
                current_user,
                { visibility: "all" }
              ).and_call_original

            expect { command.call }.to change(Decidim::ActionLog, :count).by(1)
          end
        end

        context "when gallery item is already unpublished" do
          before do
            gallery_item.update!(published_at: nil)
          end

          it "broadcasts invalid" do
            expect { command.call }.to broadcast(:invalid)
          end
        end
      end
    end
  end
end
