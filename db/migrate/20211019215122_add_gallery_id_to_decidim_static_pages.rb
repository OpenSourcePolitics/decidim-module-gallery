# frozen_string_literal: true

class AddGalleryIdToDecidimStaticPages < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_static_pages, :gallery_id, :integer, default: 0
  end
end
