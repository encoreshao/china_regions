# encoding: utf-8

module ChinaRegions
  class ResgionsGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('../../../../../app', __FILE__)

    def copy_models_file
      copy_file "models/province.rb", "app/models/province.rb"
      copy_file "models/city.rb",     "app/models/city.rb"
      copy_file "models/district.rb", "app/models/district.rb"
    end
  end
end
