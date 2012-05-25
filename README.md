delphi-xmldoc
=============

Generate html documentation from Delphi xml documentation

Used some portions of code and icons from NDOC (http://ndoc.sourceforge.net/)

Requires third-party XSLT2 processor.

I recommend AltovaXML Community Edition
http://www.altova.com/download/altovaxml/xml-processor-community.html

Before start - change variable xmlProcessor into start.js to correct path to AltivaXML executable.

## USAGE

    cscript.exe start.js <PROJECTS> <SOURCEXMLPATH> <DESTHTMLPATH>

* PROJECTS - comma separated list of projects
* SOURCEXMLPATH - path to xml generated by Delphi copyed without subdirs. 
                  ex: for /r "%WORKSPACE%\Sources" %%f in (*.xml) do @copy "%%f" "%WORKSPACE%\xmldoc\"
* DESTHTMLPATH - path where will be placed generated html's

## Example

    cscript.exe start.js Project1,Project2 .\xml .\html

