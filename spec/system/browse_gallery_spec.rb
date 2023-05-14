# frozen_string_literal: true

require "spec_helper"

describe "Browse gallery", type: :system do
  let(:organization) { create(:organization) }
  let(:participatory_space) { create(:participatory_process, organization: organization) }

  before do
    switch_to_host(organization.host)
    page.visit main_component_path(gallery_component)
  end

  context "with image gallery" do
    let!(:gallery_component) { create(:gallery_component, :image, :with_items, name: "My gallery block", participatory_space: participatory_space) }

    it "displays gallery" do
      expect(page).to have_content(/My gallery block/i)
      expect(page).to have_selector(".gallery-heading", count: 1)
      expect(page).to have_selector(".gallery.image", count: 1)
      within ".gallery.image" do
        expect(page).to have_selector(".gallery-item", count: 6)
      end
    end

    it_behaves_like "gallery accessible page"
  end

  context "with video gallery" do
    let!(:gallery_component) { create(:gallery_component, :video, :with_items, name: "My gallery block", participatory_space: participatory_space) }

    it "displays gallery" do
      expect(page).to have_content(/My gallery block/i)
      expect(page).to have_selector(".gallery-heading", count: 1)
      expect(page).to have_selector(".gallery.video", count: 1)
      within ".gallery.video" do
        expect(page).to have_selector(".gallery-item", count: 6)
      end
    end

    it_behaves_like "gallery accessible page"
  end
end
