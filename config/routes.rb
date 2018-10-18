Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
 get '/basics/ps1'
 get '/basics/ps2'
 get '/basics/quotations'
 post '/basics/quotations'
 get  '/basics/quotations/:id', to: 'basics#kill'
 get  '/basics/search', to: 'basics#search'
 get  '/basics/erase', to: 'basics#erase'
 get  '/basics/exportXML', to: 'basics#exportXML'
 get  '/basics/exportJSON', to: 'basics#exportJSON'
 get  '/basics/import', to: 'basics#import'
 get '/sqlps', :to => redirect('/sqlps')
 get '/stocks', :to => redirect('/stocks')
 get '/transcript', :to => redirect('/transcript')
 get'/basics/divbyzero', to: 'basics#divbyzero'
 get '/basics/news', to: 'basics#news'
 root 'basics#index'

end
