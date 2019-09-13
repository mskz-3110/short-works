class GzslController < ApplicationController
  def view
    gzsl_url = ShortWorks::Params.get( params, "gzsl_url", "" ){|value| download_url( validate_url( value ) )}
    @output_format = ShortWorks::Params.get( params, "output_format", "" )
    @direction = ShortWorks::Params.get( params, "direction", "V" ){|value| validate_direction( value )}
    action{
      ShortWorks::Tmp.mkdir{
        raise "Download error: #{gzsl_url}" if ! ShortWorks::Download.file( "A.gzsl", gzsl_url )
        
        gzsl_view( "A.gzsl", @output_format )
      }
    }
  end
end
