# frozen_string_literal: true

module Decidim
  module Gallery
    module Admin
      class Permissions < Decidim::DefaultPermissions
        def permissions
          return permission_action if permission_action.scope != :admin

          allow! if permission_action.subject == :gallery
          allow! if permission_action.subject == :gallery_item

          permission_action
        end
      end
    end
  end
end
