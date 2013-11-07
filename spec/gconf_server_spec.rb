#!/usr/bin/env ruby

require 'gconf_server'
require 'rack/test'

describe 'Gconf_server' do
  include Rack::Test::Methods

  def app
    Gconf_server
  end

  it "Get / should say hello" do
    get '/'
    last_response.status.should == 200
    last_response.body.should == 'Hello Gconf!'
  end

  it "Post /hi/:name should say hi to name" do
    post '/hi',"name" => "Melissa"
    last_response.status.should == 200
    last_response.body.should == 'Hi Melissa'
  end

  it "Post /gconf should say return solution to name" do
    post '/gconf','value' => {"default" => {"idc" => "all"},"yf" => {"idc" => "yf"},"hz00" => {"idc" => "hz00"}}, 'tag' => 'hz01', 'text' => '<%=@idc%>\n<$=@idc$>\n'
    last_response.status.should == 200
    last_response.body.should == 'all\\nall\\n'
  end

end
