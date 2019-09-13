class PdfController < ApplicationController
  def self.routes
    [
      { :method => "GET", :path => "/pdf/ui" },
      { :method => "GET", :path => "/pdf/ui/json" },
      { :method => "POST", :path => "/pdf/ui" },
      { :method => "POST", :path => "/pdf/view" },
      { :method => "POST", :path => "/pdf/gzsl" }
    ]
  end
  
  def view
    pdf_url = ShortWorks::Params.get( params, "pdf_url", "" ){|value| download_url( validate_url( value ) )}
    width = ShortWorks::Params.get( params, "width", @width ){|value| validate_number( value )}
    height = ShortWorks::Params.get( params, "height", @height ){|value| validate_number( value )}
    @output_format = ShortWorks::Params.get( params, "output_format", "" )
    @direction = ShortWorks::Params.get( params, "direction", "V" ){|value| validate_direction( value )}
    action{
      ShortWorks::Tmp.mkdir{
        raise "Download error: #{pdf_url}" if ! ShortWorks::Download.file( "A.pdf", pdf_url )
        raise "PDF error" if ! pdf_to_gzsl( "A.gzsl", "A.pdf", width, height )
        
        gzsl_view( "A.gzsl", @output_format )
      }
    }
  end
  
  def gzsl
    pdf_url = ShortWorks::Params.get( params, "pdf_url", "" ){|value| download_url( validate_url( value ) )}
    width = ShortWorks::Params.get( params, "width", @width ){|value| validate_number( value )}
    height = ShortWorks::Params.get( params, "height", @height ){|value| validate_number( value )}
    @output_format = ShortWorks::Params.get( params, "output_format", "" )
    action{
      ShortWorks::Tmp.mkdir{
        raise "Download error: #{pdf_url}" if ! ShortWorks::Download.file( "A.pdf", pdf_url )
        raise "PDF error" if ! pdf_to_gzsl( "A.gzsl", "A.pdf", width, height )
        
        bytes = file_to_bytes( "A.gzsl" )
        case @output_format
        when "json"
          render :json => { :gzsl => Base64.strict_encode64( bytes ) }
        else
          send_data( bytes, :filename => "ShortWorks.gzsl" )
        end
      }
    }
  end
end
