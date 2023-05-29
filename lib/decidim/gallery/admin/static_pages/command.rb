# frozen_string_literal: true

module Decidim
  module Gallery
    module Admin
      module StaticPages
        module Command
          def attributes
            super.merge(gallery_id: form.gallery_id)
          end
        end
      end
    end
  end
end
