require 'zenvia'

Zenvia.configure do |config|
  config.account  = 'YOUR ZENVIA ACCOUNT'
  config.code     = 'YOUR ZENVIA CODE'
  config.from     = 'YOUR APPLICATION NAME'
  config.callback_option = 'CALLBACK OPTION'
end
