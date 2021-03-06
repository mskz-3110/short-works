class MarkdownController < ApplicationController
  def self.routes
    [
      { :method => "GET", :path => "/markdown/ui" },
      { :method => "GET", :path => "/markdown/ui/json" },
      { :method => "POST", :path => "/markdown/ui" },
      { :method => "POST", :path => "/markdown/view" },
      { :method => "POST", :path => "/markdown/pdf" }
    ]
  end
  
  def initialize
    super
    
    @markdown_pdf_css_url = File.expand_path( "lib/modules/markdown-pdf.css", Rails.root )
    @markdown_pdf_css_url = "file://#{@markdown_pdf_css_url}"
  end
  
  def view
    markdown_url = ShortWorks::Params.get( params, "markdown_url", "" ){|value| download_url( validate_url( value ) )}
    css_url = ShortWorks::Params.get( params, "css_url", @markdown_pdf_css_url ){|value| download_url( validate_url( value ) )}
    width = ShortWorks::Params.get( params, "width", @width ){|value| validate_number( value )}
    height = ShortWorks::Params.get( params, "height", @height ){|value| validate_number( value )}
    @output_format = ShortWorks::Params.get( params, "output_format", "" )
    @direction = ShortWorks::Params.get( params, "direction", "V" ){|value| validate_direction( value )}
    action{
      ShortWorks::Tmp.mkdir{
        raise "Download markdown error: #{markdown_url}" if ! ShortWorks::Download.file( "A.md", markdown_url )
        raise "Download css error: #{css_url}" if ! ShortWorks::Download.file( "A.css", css_url )
        raise "Markdown error" if ! ShortWorks::Command.markdown_to_pdf( "A.pdf", "A.md", "A.css", { :width => width, :height => height } )
        raise "PDF error" if ! pdf_to_gzsl( "A.gzsl", "A.pdf", width, height )
        
        gzsl_view( "A.gzsl", @output_format )
      }
    }
  end
  
  def pdf
    markdown_url = ShortWorks::Params.get( params, "markdown_url", "" ){|value| download_url( validate_url( value ) )}
    css_url = ShortWorks::Params.get( params, "css_url", @markdown_pdf_css_url ){|value| download_url( validate_url( value ) )}
    width = ShortWorks::Params.get( params, "width", @width ){|value| validate_number( value )}
    height = ShortWorks::Params.get( params, "height", @height ){|value| validate_number( value )}
    @output_format = ShortWorks::Params.get( params, "output_format", "" )
    action{
      ShortWorks::Tmp.mkdir{
        raise "Download markdown error: #{markdown_url}" if ! ShortWorks::Download.file( "A.md", markdown_url )
        raise "Download css error: #{css_url}" if ! ShortWorks::Download.file( "A.css", css_url )
        raise "Markdown error" if ! ShortWorks::Command.markdown_to_pdf( "A.pdf", "A.md", "A.css", { :width => width, :height => height } )
        
        bytes = file_to_bytes( "A.pdf" )
        case @output_format
        when "json"
          render :json => { :pdf => Base64.strict_encode64( bytes ) }
        else
          send_data( bytes, :filename => "ShortWorks.pdf" )
        end
      }
    }
  end
end
