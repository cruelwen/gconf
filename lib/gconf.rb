require 'erubis'
require 'yaml'

class Gconf

  attr_accessor :idc_tree, :raw_value, :full_value

  def initialize(idc_tree_yml)
    @idc_tree = read_yml(idc_tree_yml)
  end

  def read_raw_value(raw_value_yml)
    @raw_value = read_yml(raw_value_yml)
    gen_full_value
  end
  
  def gen_full_value
    @full_value = {}
    @full_value["default"] = @raw_value["default"]
    @full_value["default"].each do |item, value|
      @idc_tree.each do |node,father| 
        @full_value[node] = {} if !@full_value[node]
        @full_value[node][item] = get_value(node,item)
      end
    end
  end

  def eval_file(file, tag = "default")
    input = File.read(file)
    eval_string(input,tag)
  end
  
  def eval_string(string, tag = "default")
    eruby = Erubis::Eruby.new(string,:pattern=>'<[\$%] [\$%]>')
    eruby.evaluate(@full_value[tag])
  end

  private

  def get_value(node,item)
    if ( @raw_value[node] && @raw_value[node][item] )
      return @raw_value[node][item]
    else
      return get_value(@idc_tree[node],item)
    end
  end

  def read_yml(yaml)
    begin
      info = YAML.load_file(yaml)
    rescue => e
      puts "Could not read YAML file #{yaml}: #{e}"
      exit 1
    end
    return info
  end

end
