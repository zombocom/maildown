Rails.application.routes.draw do

  mount Maildown::Engine => "/maildown"
end
