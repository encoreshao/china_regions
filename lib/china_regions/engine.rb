require "rails"

module ChinaRegions
  if ::Rails.version > "3.1"
    class Engine < ::Rails::Engine; end
  else
    class Railtie < ::Rails::Railtie
      ActiveSupport.on_load(:action_view) do
        ::ActionView::Base.send :include, ChinaRegions::Helpers::FormHelper
      end  
    end
  end
end