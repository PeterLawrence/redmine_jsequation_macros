#
# Javascript equation macro for redmine.
#
# P.J.Lawrence October 2010
#
# To use all the features of this macro you'll need to patch
# lib/redmine/wiki_formatting.rb
# replace "MACROS_RE =" with the following..
# MACROS_RE = /
#                      (!)?                        # escaping
#                      (
#                      \{\{                        # opening tag
#                      ([\w]+)                     # macro name
#                      (\((.*?)\))?             # optional arguments
#                      \}\}                        # closing tag
#                      )
#                    /xm unless const_defined?(:MACROS_RE)
#
#
require 'redmine'
RAILS_DEFAULT_LOGGER.info 'redmine jsequation macros'

Redmine::Plugin.register :redmine_jsequation_macros do
    name 'Redmine jsequation macros'
    author 'P.J. Lawrence'
    description 'Javascript maths equations macros. Usage {{jsmath(\sum_i c_i)}} or {{mathjax(\sum_i c_i)}}'
    version '0.1'
end

# This macro will diplay an equation using jsmath javascript.
#
# Usage : 
#
# {{jsmath(FLD_i = \sum_k {{(C_{i,k} \times \Delta_k)} \over D_i})}}
#
Redmine::WikiFormatting::Macros.register do
  desc "jsmath" 
  macro :jsmath do |obj, args|
    args, options = extract_macro_options(args, :parent)
    
    if args.size >= 1
      if !defined? @IncludedJSMathScript
        # then include java script to display equations
        IncludedJSMathScript=1
        mytext = javascript_include_tag('jsMath-3.6e/easy/load.js', :plugin => 'redmine_jsequation_macros')
        mytext += javascript_include_tag('jsMath-3.6e/plugins/noImageFonts.js', :plugin => 'redmine_jsequation_macros')
        mytext += "<SCRIPT> jsMath.Process(document); </SCRIPT>"
      else
        mytext = ""
      end
      mytext += "<DIV CLASS=\"math\">\n"
      iLoop=0
      args.each { |arg_v| 
         mytext += CGI.unescapeHTML(arg_v) 
         if iLoop<(args.size-1)
            mytext +=","
         end
         iLoop+=1
      }
      #mytext += CGI.unescapeHTML(args[0])
      mytext += "\n</DIV>\n"
      
      return mytext
    else
      raise 'No or bad arguments.'
    end
  end
end

# This macro will diplay an equation using MathJAX javascript.
#
# Usage : 
#
# {{mathjax(FLD_i = \sum_k {{(C_{i,k} \times \Delta_k)} \over D_i})}} 
#
# May need to call this function when preview option is executed
# MathJax.Hub.Queue(["Typeset",MathJax.Hub]); 
# 
Redmine::WikiFormatting::Macros.register do
  desc "Mathjax" 
  macro :Mathjax do |obj, args|
    args, options = extract_macro_options(args, :parent)
    
    if args.size >= 1
        if !defined? @IncludedMathJaxScript
           # then include java script to display equations
           @IncludedMathJaxScript=1
           mytext= "<script type=\"text/javascript\">
        //<![CDATA[
function startmaths() {
  var script = document.createElement(\"script\");
  script.type = \"text/javascript\";
  script.src = \"#{Redmine::Utils.relative_url_root}/plugin_assets/redmine_jsequation_macros/javascripts/MathJax/MathJax.js\";   // use the location of your MathJax

  var config = 'MathJax.Hub.Config({' +
                 'extensions: [\"tex2jax.js\"],' +
                 'jax: [\"input/TeX\",\"output/HTML-CSS\"]' +
               '});' +
               'MathJax.Hub.Startup.onload();';

  if (window.opera) {script.innerHTML = config}
               else {script.text = config}

  document.getElementsByTagName(\"head\")[0].appendChild(script);
};
startmaths();
//]]>
</script>"
      else
        mytext=""
        #mytext="<script type=\"text/javascript\">
        #//<![CDATA[
        #MathJax.Hub.Queue([\"Typeset\",MathJax.Hub]);
        #//]]>
        #</script>"
      end
      
      mytext += "<script type=\"math/tex; mode=display\">\n"
      iLoop=0
      args.each { |arg_v| 
         mytext += CGI.unescapeHTML(arg_v) 
         if iLoop<(args.size-1)
            mytext +=","
         end
         iLoop+=1
      }
      #mytext += CGI.unescapeHTML(args[0])
      mytext += "\n</script>"
      
      return mytext
    else
      raise 'No or bad arguments.'
    end
  end
end

