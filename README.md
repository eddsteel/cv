
This is my résumé, and tools to facilitate publishing it in various forms.

The actual information is held in a YAML file - `content.yaml`. This is used
in ERB templates to create documents of various formats with the same text
content, and similar visual style (through `rake`).

PDF from tex templates capability is specifically supported, but otherwise
there should be no restriction about what kind of ERB templates you build
from. Templates go in `src` with the same file name as their output. If you
want helper methods, put them in a module named after the extension, in a file
named after the extension. For example, TeX helpers, for `.tex` templates are
in `Tex` in `tex.rb`. These are dynamically loaded into the context of the
template.

Nothing outside of the `src` directory is specific to me or résumés.  I'll
probably use it for other documents as required, you're welcome to do the
same. It supports partials, and builds friendly soft objects from YAML maps
and lists. Build a content object with `Content.parse name_of_yaml_file` and
all the YAML properties will be available as accessor methods. Array
properties act as Arrays.

You can see the HTML version of the document
[here](http://edd.heroku.com/resume), and in PDF
[here](http://edd.heroku.com/resume.pdf).

# Structure

The project has the following structure:

* `lib`: Ruby code for creating backing objects from YAML for ERB templates.
* `support`: CSS files, LaTeX style files, etc.
* `src`: templates, partial templates, content YAML files.
* `out`: intermediate build files. (TODO)

# Rake targets

Rake should be used to generate output files. Calling, for example `rake
cv.html`, will find `src/cv.html`, and fill it out with content. `rake cv.pdf`
will build the `.tex` file from its template first.

# Prerequisites

The `aws-s3` gem is required in order to push PDF files to S3 buckets. If you
want to use these targets, you will need to set `AMAZON_ACCESS_KEY_ID`,
`AMAZON_SECRET_ACCESS_KEY`, `AMAZON_S3_BUCKET` environment variables. If you
don't, these and the gem are unnecessary.
