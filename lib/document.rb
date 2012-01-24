#!/usr/bin/env ruby -w
#
# document.rb
#
# Produces a document from a template and content data file.
#

libdir = File.dirname(__FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)


require 'content'
require 'erb'

class Document
  attr_reader :template, :extension

  def initialize template_file, content
    @content = content
    @extension = template_file[/[^.]*$/]
    @template= template_file

    load_helpers
  end

  def self.from_file template_file, file='src/content.yaml'
    self.new template_file, Content.parse(file)
  end

  def self.from_object template_file, object
    self.new template_file, object
  end

  def each &block
    @content.each &block
  end

  def method_missing name, *args
    @content.send name, *args
  end

  def result
    renderer = ERB.new File.read(@template), nil, '>'
    renderer.result binding
  end

  ##
  # Load helper module and its methods, if it exists.
  # Otherwise, load generic helpers (partial support).
  #
  private
  def load_helpers
    libdir = File.dirname __FILE__
    filename = File.join(libdir,"#{@extension}.rb")
    if File.exist? filename
      require @extension
      extend(ObjectSpace.const_get(@extension.capitalize))
    else
      extend DocumentHelper
    end
  end
end
