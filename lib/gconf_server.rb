#!/usr/bin/env ruby

home = File.join(File.dirname(__FILE__),'..')
ENV['BUNDLE_GEMFILE'] ||= "#{home}/Gemfile"
require 'sinatra/base'
require 'json'
require File.join(home,'lib','gconf')

class Gconf_server < Sinatra::Base
  post '/gconf' do
    request.body.rewind
    body = JSON.parse request.body.read
    value = body["value"]
    tag = body["tag"]
    text = body["text"]
    puts value
    puts tag
    puts text
    @gc = Gconf.new(File.join(home,'conf/idc_tree.yml'))
    @gc.raw_value = value
    @gc.gen_full_value
    @gc.eval_string(text,tag)
  end

  get '/' do
    "Hello Gconf!"
  end

  run! if app_file == $0
end

