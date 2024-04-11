// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import '@hotwired/turbo-rails'
import 'controllers'
import jquery from 'jquery'
import 'popper'
import 'bootstrap'
import '@nathanvda/cocoon'

window.$ = jquery
window.jquery = jquery
window.jQuery = jquery
