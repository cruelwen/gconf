require 'erb'

a=1
b="haha"
erb = ERB.new(File.read("ex.erb"))
puts erb.result

