Rails.application.routes.draw do
  scope '/api' do
    scope '/v1' do
      resources :pages, except: :update
    end
    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  end
end
