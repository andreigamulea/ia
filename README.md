Merge bine pana aici, cele 2 tabele functioneaza bine, paginarea si mutatul de pe o pagina pe alta butoanele DELETE merg la Results
La Menu am pus Sign Out cu link_to si am scos button_to
am dat bundle exec rails assets:precompile   #aceasta  va face ca siteul sa aiba preinstalat css
acum pot seta in production: config.assets.compile = false   

Merge f bine dupa ce am dat bundle exec rails assets:precompile    pt server render  si

rails assets:precompile  pt server local 

setez Enviromentul: set RAILS_ENV=production      set RAILS_ENV=development