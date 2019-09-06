class GzslController < ApplicationController
  def ui
    @form_format = ShortWorks::Params.get( params, "form_format", "html" )
  end
  
  def view
    url = ShortWorks::Params.get( params, "url", "" ){|value| download_url( value )}
    data = ShortWorks::Params.get( params, "data", "" )
    commit = ShortWorks::Params.get( params, "commit", "" )
    @slide_class = ( "Horizontal View" == commit ) ? "horizontal-slide" : ""
    gzsl_view( url, data )
  end
end
