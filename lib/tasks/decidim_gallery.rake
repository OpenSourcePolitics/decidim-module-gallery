# frozen_string_literal: true

namespace :decidim do
  namespace :gallery do
    # task upgrade: [:choose_target_plugins, :"railties:install:migrations"]

    desc "Setup environment so that only decidim migrations are installed."
    task :choose_target_plugins do
      ENV["FROM"] = "#{ENV.fetch("FROM", nil)},decidim_gallery"
    end
  end
end

Rake::Task["decidim:choose_target_plugins"].enhance do
  Rake::Task["decidim:gallery:choose_target_plugins"].invoke
end
