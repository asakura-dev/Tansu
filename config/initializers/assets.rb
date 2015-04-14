# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += %w( dropdown.js )
Rails.application.config.assets.precompile += %w( ko_bind.js )
Rails.application.config.assets.precompile += %w( member_request.js )
Rails.application.config.assets.precompile += %w( member_authority.js )
Rails.application.config.assets.precompile += %w( user_form.js )
Rails.application.config.assets.precompile += %w( product_form.js )
