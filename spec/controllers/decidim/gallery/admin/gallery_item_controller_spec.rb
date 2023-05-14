# frozen_string_literal: true

require "spec_helper"

describe Decidim::Gallery::Admin::GalleryItemController, type: :controller do
  routes { Decidim::Gallery::AdminEngine.routes }

  let(:organization) { create(:organization) }
  let(:user) { create :user, :admin, :confirmed, organization: gallery_component.organization }
  let!(:assembly) { create(:assembly, organization: organization) }
  let!(:gallery_component) { create(:gallery_component, :with_items, organization: organization, participatory_space: assembly) }
  let!(:gallery_item) { create(:gallery_item, component: gallery_component, author: user) }

  before do
    request.env["decidim.current_organization"] = gallery_component.organization
    request.env["decidim.current_participatory_space"] = gallery_component.participatory_space
    request.env["decidim.current_component"] = gallery_component
    sign_in user, scope: :user
  end

  describe "create" do
    it "performs create action with redirect" do
      post :create, params: {
        component_id: gallery_component.id,
        title: { en: "Gallery item" },
        weight: 1
      }

      expect(response).to have_http_status(:found) # redirect
      expect(response).to redirect_to Decidim::EngineRouter.admin_proxy(gallery_component).root_path
      expect(flash[:notice]).to eq("Valid")
    end

    it "performs create action with alert" do
      post :create, params: {
        component_id: gallery_component.id,
        weight: 1
      }

      expect(flash.now[:alert]).to eq("Invalid")
    end
  end

  describe "edit" do
    it "performs edit action" do
      get :edit, params: {
        id: gallery_item.id,
        component_id: gallery_component.id,
        title: { en: "New Gallery item" },
        weight: 1
      }

      expect(response).to have_http_status(:ok)
    end
  end

  describe "new" do
    it "performs edit action" do
      get :new, params: {
        component_id: gallery_component.id,
        title: { en: "Gallery item" },
        weight: 1
      }

      expect(response).to have_http_status(:ok)
    end
  end

  describe "update" do
    it "performs update action with redirect" do
      patch :update, params: {
        id: gallery_item.id,
        component_id: gallery_component.id,
        title: { en: "New Gallery item" },
        weight: 1
      }

      expect(response).to have_http_status(:found) # redirect
      expect(response).to redirect_to Decidim::EngineRouter.admin_proxy(gallery_component).root_path
      expect(flash[:notice]).to eq("Successfully updated")
    end

    it "performs update action with alert" do
      patch :update, params: {
        id: gallery_item.id,
        component_id: gallery_component.id,
        weight: 1
      }

      expect(flash.now[:alert]).to eq("There was an error updating the resource")
    end
  end
end
