#!/usr/bin/env ruby -w
#
# Tex helpers
#

libdir = File.dirname(__FILE__)
$:.unshift libdir unless $:.include? libdir


require 'document-helper'

module DocBuild

module Tex
  include DocumentHelper
  ##
  # Convert markdown to latex.
  # italic, bold
  # sublists (using partials).
  # escape # % and LaTeX
  #
  def latex md
    if md.is_a? String
      md = LatexConvertor.new(md).to_tex
    elsif md.is_a? Enumerable
      render_sublist md
    else
      raise "Can't deal with a #{md.class}"
    end
  end
end

class LatexConvertor
  def initialize text
    @text = text
  end

  def to_tex
    @text.
      gsub(/\*\*([^*]+)\*\*/, '{\bf \1}').
      gsub(/_([^_]+)_/, '{\sl \1}').
      gsub(/LaTeX/, "\LaTeX").
      # This isn't bulletproof, but does for now.
      gsub(/(\S)%/, '\1\%').
      gsub(/\[([^\]]+)\]\([^)]+\)/, '{\tt \1}')
  end
end
end
