# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w(angular.js jquery.js jquery-ui.js jquery_ujs.js wysiwyg.js wysiwyg.css)
# Controllers
Rails.application.config.assets.precompile += %w(bios
                                                 books
                                                 book_versions
                                                 campaigns
                                                 contributions
                                                 fulfillments
                                                 inquiries
                                                 pages
                                                 payments
                                                 rewards
                                                 subscribers).flat_map{|a| ["#{a}.js", "#{a}.css"]}
Rails.application.config.assets.precompile += %w(bios
                                                 books
                                                 book_versions
                                                 products
                                                 campaigns
                                                 confirmations
                                                 fulfillments
                                                 house_rewards
                                                 inquiries
                                                 payments
                                                 subscribers
                                                 users).flat_map{|c| ["admin/#{c}.js", "admin/#{c}.css"]}
# Angular apps
Rails.application.config.assets.precompile += %w(controllers/contribution_controller.js)

Rails.application.config.assets.precompile << /\.(?:svg|eot|woff|ttf)\z/
