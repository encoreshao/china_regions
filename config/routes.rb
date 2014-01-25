Rails.application.routes.draw do
  get '/china_regions/fetch_options', to: ChinaRegions::FetchOptionsController.action(:index)
end
