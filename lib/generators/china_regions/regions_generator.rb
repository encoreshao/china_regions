# frozen_string_literal: true

module ChinaRegions
  class RegionsGenerator < Rails::Generators::Base
    source_root File.expand_path('../../../app', __dir__)

    def copy_models_file
      copy_file 'models/province.rb', 'app/models/province.rb'
      copy_file 'models/city.rb',     'app/models/city.rb'
      copy_file 'models/district.rb', 'app/models/district.rb'
    end

    def copy_js_file
      copy_file 'assets/javascripts/region_select.js', 'app/assets/javascripts/region_select.js'
    end
  end
end
