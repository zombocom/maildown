Rails.application.routes.draw do
  get "handlers/:id", to: "handlers#show"
end
