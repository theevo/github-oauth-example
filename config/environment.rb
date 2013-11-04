#environment
require 'bundler'

Bundler.require

require_relative './login.rb'
require_relative '../app/controllers/main.rb'

MY_ORGANIZATION = ENV['CAMELBACK_MY_ORGANIZATION']
MY_ORG_CAPITALIZE = MY_ORGANIZATION.split('-').map { |s| s.capitalize }.join(' ')