class GzslController < ApplicationController
  def ui
    @form_format = ShortWorks::Params.get( params, "form_format", "html" )
  end
  
  def view
    url = ShortWorks::Params.get( params, "url", "" ){|value| download_url( value )}
    data = ShortWorks::Params.get( params, "data", "" )
    gzsl_view( url, data )
  end
end
