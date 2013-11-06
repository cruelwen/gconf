require 'gconf'

describe Gconf do
  def genfile(filename,context)
    fd = File.new(filename,"w")
    fd.puts context
    fd.flush
    fd.close
  end
  
  it "should get result" do
    idc_tree = {
      "yf00" => "yf",
      "hz00" => "hz",
      "hz01" => "hz",
      "hz" => "all",
      "yf" => "bjct",
      "bjct" => "bj",
      "bj" => "all",
      "all" => "default",
    }
    genfile("/tmp/idc_tree",YAML.dump(idc_tree))

    raw_value = {
      "default" => {"idc" => "all"},
      "yf" => {"idc" => "yf"},
      "hz00" => {"idc" => "hz00"},
    }
    genfile("/tmp/raw_value",YAML.dump(raw_value))

    genfile("/tmp/conf_template","<$=@idc$>")

    ret = `./bin/gconf_console /tmp/conf_template -t /tmp/idc_tree -v /tmp/raw_value -g hz01`
    ret.should == "all\n"
    ret = `./bin/gconf_console /tmp/conf_template -t /tmp/idc_tree -v /tmp/raw_value`
    ret.should == "all\n"
    ret = `./bin/gconf_console /tmp/conf_template -t /tmp/idc_tree -v /tmp/raw_value -g hz00`
    ret.should == "hz00\n"
    ret = `./bin/gconf_console /tmp/conf_template -t /tmp/idc_tree -v /tmp/raw_value -g yf00`
    ret.should == "yf\n"
  end
end

