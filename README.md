# Gconf 配置派生工具

## Usage 用途

Genetate different config file from template for different environment.

使用同一个模板，为不同的环境产生不同的配置文件。

## Using as a command line tool 用作命令行工具

	Usage: gconf conf_template [OPTIONS]
		-t, --teee FILENAME              Tag Tree File
		-v, --value FILENAME             Value File
		-g, --tag [TAG]                  TAG
		-h, --help                       Help

To use gonf, we need these 3 files:

使用gconf，我们需要定义3个文件：

**template_file.erb**

In standard ERB formate

template文件使用标准的ERB模板格式

	# template_file.erb
	<%= @tag_value %>

**tag_tree.yml**

`default` must be the root of the tree.

`default`节点必须是根节点

Describe the tree using `child:father` style

使用`子节点:父节点`方式定义树

	# tag_tree.yml
	# default --- a --- b
	#             |
	#             ----- c
	b:a
	c:a
	a:default	

**value.yml**

All the value should be defined in `default`

`default`节点必须定义好所有的变量

If we want a value of `tag` which is not defined in `tag`, gconf will try its `father` according to `tag_tree`, unitl get value or meet `default` 

如果要获得的变量并未在该节点被定义，则尝试父节点，递归直到`default`节点


	# value.yml
	default: 
	  tag_value: 1
	b:
	  tag_value: 2

Then, try gconf

结果举例：

	# Normal use
	# 普通使用（返回值2）
	gconf ./template_file.erb -t tag_tree.yml -v value.yml -g b # result is 2
	
	# If value of tag is NOT defined ,try father tag, until default
	# tag未定义value，递归找到default中的定义（返回值1）
	gconf ./template_file.erb -t tag_tree.yml -v value.yml -g c # result is 1 
	
	# Using default value without -g
	# 不用-g参数，直接使用default中的value（返回值1）
	gconf ./template_file.erb -t tag_tree.yml -v value.yml      # result is 1
	
## Using as a server 用作服务器

Gconf server load tag_tree when startup.

Gconf服务器会在启动时加载tag_tree

POST

	post '/gconf','value' => {"default" => {"tag_value" => "1"},"b" => {"tag_value" => "2"}}, 'tag' => 'c', 'text' => '<%= @tag_value %>\n'