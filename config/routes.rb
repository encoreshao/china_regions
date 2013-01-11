Rails.application.routes.draw do
  match '/china_regions/fetch_options', to: ChinaRegions::FetchOptionsController.action(:index)
end