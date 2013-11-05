require 'gconf'

describe Gconf do
  before :each do
    @idc_tree = {
      "yf00" => "yf",
      "hz00" => "hz",
      "hz01" => "hz",
      "hz" => "all",
      "yf" => "bjct",
      "bjct" => "bj",
      "bj" => "all",
      "all" => "default",
    }
    tmpfile = "/tmp/idc_tree"
    idc_tree_settings = File.new(tmpfile, "w")
    idc_tree_settings.puts YAML.dump(@idc_tree)
    idc_tree_settings.flush
    @gc = Gconf.new(tmpfile)
  end

  it "should read tree" do
    @gc.idc_tree.should == @idc_tree
  end

  it "should generate number" do
    @test_conf = <<HD_CONF
<%=num%>
HD_CONF
    num = 0
    sol = ERB.new(@test_conf)
    sol.result(binding).should == "0\n"
  end

  it "should generate list" do
    @test_conf = <<HD_CONF
<%list.each {|l| %><%=l%> <%}%>
HD_CONF
    list = [0,1,2]
    sol = ERB.new(@test_conf)
    sol.result(binding).should == "0 1 2 \n"
  end

  it "should gen full value" do
    @gc.raw_value = {
      "default" => {"idc" => "all"},
      "yf" => {"idc" => "yf"},
      "hz00" => {"idc" => "hz00"},
    }
    @gc.gen_full_value
    @gc.full_value["yf00"]["idc"].should == "yf"
    @gc.full_value["hz00"]["idc"].should == "hz00"
    @gc.full_value["hz01"]["idc"].should == "all"
  end

  it "should evaluate string" do
    @gc.raw_value = {
      "default" => {"idc" => "all"},
      "yf" => {"idc" => "yf"},
      "hz00" => {"idc" => "hz00"},
    }
    tmpfile = "/tmp/eval_file"
    str = <<HD_EVALFILE
<$=@idc$>
<%=@idc%>
HD_EVALFILE
    @gc.gen_full_value
    @gc.eval_string(str,"yf00").should == "yf\nyf\n"
    @gc.eval_string(str).should == "all\nall\n"
  end

  it "should evaluate file" do
    @gc.raw_value = {
      "default" => {"idc" => "all"},
      "yf" => {"idc" => "yf"},
      "hz00" => {"idc" => "hz00"},
    }
    tmpfile = "/tmp/eval_file"
    file = File.new(tmpfile, "w")
    file.puts <<HD_EVALFILE
<$=@idc$>
<%=@idc%>
HD_EVALFILE
    file.flush
    @gc.gen_full_value
    @gc.eval_file(tmpfile,"yf00").should == "yf\nyf\n"
    @gc.eval_file(tmpfile).should == "all\nall\n"
  end
end
