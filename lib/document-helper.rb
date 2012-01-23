#!/usr/bin/env ruby -w
#
# document-helper.rb
#
# Helper methods for all document types.
#

module DocumentHelper
  def render partial, content
    Document.from_object(partial, content).result
  end

  def render_sublist content
    render partial(template, 'sublist', extension), content
  end

  def partial template_name, partial_name, ext
    File.join(File.dirname(template_name),
              "#{partial_name}.partial.#{ext}")
  end
end
 
