Rails.application.routes.draw do
  # get 'home/index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html


  namespace :v1, defaults: {format: 'json'} do
    get "api/view", to: 'api#view'
    get "api/add", to: 'api#add'
    get "deck", to: 'apideck#index'
    get "deck/addgamedeck", to: 'apideck#addGameDeck'
    get "deck/init", to: 'apideck#init'
    get "deck/initgame", to: 'apideck#initgame'
    get "deck/getdeck", to: 'apideck#getgamedeck'
    get "deck/join", to: 'apideck#addplayer'
    get "deck/leave", to: 'apideck#removeplayer'
    get "deck/close", to: 'apideck#closegame'
    get "deck/start", to: 'apideck#startgame'
    get "deck/getgamedata", to: 'apideck#getGameData'
    get "deck/getplayercard", to: 'apideck#getplayercard'

    get "card/throwcard", to:'apicard#throwcard'
    get "card/applycardeffect", to: 'apicard#applycardeffect'
    get "card/movenextforce", to: 'apicard#movenextforce'
  end

  root 'home#index'

  get "*page", to: 'home#index', constraints: ->(req) do
    !req.xhr? && req.format.html?
  end
end
