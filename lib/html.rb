#!/usr/bin/env ruby -w
#
# Tex helpers
#

require 'document-helper'

require 'rubygems'
require 'rdiscount'

module Html
  include DocumentHelper
  ##
  # Convert markdown to HTML.
  #
  def html md
    if md.is_a? String
      RDiscount.new(md).to_html
    elsif md.is_a? Enumerable
      render_sublist md
    else
      raise "Can't deal with a #{md.class}"
    end
  end
end
