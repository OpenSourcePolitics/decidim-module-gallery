# frozen_string_literal: true

module Decidim
  module Gallery
    class Permissions < Decidim::DefaultPermissions
      def permissions
        return permission_action unless user

        # Delegate the admin permission checks to the admin permissions class
        return Decidim::Gallery::Admin::Permissions.new(user, permission_action, context).permissions if permission_action.scope == :admin

        allow!
        permission_action
      end
    end
  end
end
