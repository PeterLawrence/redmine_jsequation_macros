Javascript Equation Macros for Redmine
=================

Installation
------------

Put this repo in `REDMINE_ROOT/vendor/plugins`

To use all the features of this macro you'll need to patch
lib/redmine/wiki_formatting.rb
 replace "MACROS_RE =" with the following..
 MACROS_RE = /
                      (!)?                        # escaping
                      (
                      \{\{                        # opening tag
                      ([\w]+)                     # macro name
                      (\((.*?)\))?             # optional arguments
                      \}\}                        # closing tag
                      )
                    /xm unless const_defined?(:MACROS_RE)
                    
Usage
-----

    {{jsmath(\sum_i c_i)}} or {{mathjax(\sum_i c_i)}}
