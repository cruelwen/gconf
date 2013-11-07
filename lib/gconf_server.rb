#!/usr/bin/env ruby

home = File.join(File.dirname(__FILE__),'..')
ENV['BUNDLE_GEMFILE'] ||= "#{home}/Gemfile"
require 'sinatra/base'
require 'json'
require File.join(home,'lib','gconf')

class Gconf_server < Sinatra::Base

  def initialize
    home = File.join(File.dirname(__FILE__),'..')
    @gc = Gconf.new(File.join(home,'conf/idc_tree.yml'))
    super
  end

  post '/gconf' do
    request.body.rewind
    if request.media_type == 'application/json'
      body = JSON.parse request.body.read 
      value = body["value"]
      tag = body["tag"]
      text = body["text"]
    else
      value = request["value"]
      tag = request["tag"]
      text = request["text"]
    end
    @gc.raw_value = value
    @gc.gen_full_value
    @gc.eval_string(text,tag)
  end

  get '/' do
    "Hello Gconf!"
  end

  post '/hi' do
    "Hi #{params[:name]}"
  end

  run! if app_file == $0

end

