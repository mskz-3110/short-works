class GzslController < ApplicationController
  def ui
    @view_format = ShortWorks::Params.get( params, "view_format", "html" )
  end
  
  def view
    url = ShortWorks::Params.get( params, "url", "" ){|value| download_url( value )}
    data = ShortWorks::Params.get( params, "data", "" )
    format = ShortWorks::Params.get( params, "format", "html" )
    
    gzsl_view( url, data, format )
  end
end
