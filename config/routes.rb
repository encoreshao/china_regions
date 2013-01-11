Rails.application.routes.draw do
  match '/china_region/fetch_options', to: ChinaRegion::FetchOptionsController.action(:index)
end