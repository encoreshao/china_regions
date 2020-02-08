# frozen_string_literal: true

Rails.application.routes.draw do
  match '/china_regions/fetch_options' =>
    ChinaRegions::FetchOptionsController.action(:index), via: [:get]
end
