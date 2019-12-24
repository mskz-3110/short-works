var MarkdownPdf = require( "markdown-pdf" );

var pdf_path = process.argv[ 2 ];
var markdown_path = process.argv[ 3 ];
var css_path = process.argv[ 4 ];
var width = process.argv[ 5 ];
var height = process.argv[ 6 ];

MarkdownPdf({
  "cssPath"          : css_path,
  "paperOrientation" : "landscape",
  "paperBorder"      : "0px",
  "paperWidth"       : width,
  "paperHeight"      : height,
  "remarkable" : {
    "html" : true
  }
}).from( markdown_path ).to( pdf_path );
