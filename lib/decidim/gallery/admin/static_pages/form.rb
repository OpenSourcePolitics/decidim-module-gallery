# frozen_string_literal: true

module Decidim
  module Gallery
    module Admin
      module StaticPages
        module Form
          def self.prepended(base)
            base.class_eval do
              attribute :gallery_id, Integer
            end
          end

          def galleries
            @galleries ||= Decidim::Component.where(participatory_space: current_organization.public_participatory_spaces, manifest_name: "gallery")
          end
        end
      end
    end
  end
end
