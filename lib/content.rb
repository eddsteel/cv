##
# content.rb
#
# Read's the template data from yaml into
# a soft object, for insertion into templates
#

require 'yaml'

class SoftObjectFactory
  def self.build value
    if SoftObject.accepts? value
      SoftObject.new value
    elsif SoftObjectList.accepts? value
      SoftObjectList.new value
    else
      value
    end
  end
end

class SoftObject
  def initialize data
    @data = data
  end

  def self.accepts? value
    value.respond_to? :"key?"
  end

  alias mm method_missing
  def method_missing name, *args
    k = name.to_s
    if @data.key? k
      SoftObjectFactory.build @data[k]
    else
      mm name, *args
    end
  end
end

class SoftObjectList
  def initialize data
    @data = data
  end

  def self.accepts? value
    value.is_a? Array
  end

  alias mm method_missing
  def method_missing name, *args
    SoftObjectFactory.build(@data.send name, *args)
  end
end

class Content < SoftObject
  def self.parse file
    new YAML.load(File.read file)
  end
end
