class PdfController < ApplicationController
  def ui
    @view_format = ShortWorks::Params.get( params, "view_format", "html" )
    @size = ShortWorks::Params.get( params, "size", "" ){|value| pdf_size( value )}
  end
  
  def view
    url = ShortWorks::Params.get( params, "url", "" ){|value| download_url( value )}
    data = ShortWorks::Params.get( params, "data", "" )
    format = ShortWorks::Params.get( params, "format", "html" )
    size = ShortWorks::Params.get( params, "size", "" ){|value| pdf_size( value )}
    ShortWorks::Tmp.mkdir{
      begin
        raise "Download file error" if ! ShortWorks::Download.file( "A.pdf", url, Base64.strict_decode64( data ) )
        
        gzsl_bytes = pdf_to_gzsl_bytes( "A.pdf", "A.gzsl", size )
        raise "PDF to GZSL error" if gzsl_bytes.nil?
        
        gzsl_view( "", Base64.strict_encode64( gzsl_bytes ), format )
      rescue => e
        @err_msg = e.message
        case format
        when "json"
          render :json => { :err_msg => @err_msg }
        end
      end
    }
  end
  
  def gzsl
    name = ShortWorks::Params.get( params, "name", "" ){|value| File.basename( value )}
    name = "gzsl_#{`date \"+%Y%m%d_%H%M\"`.chomp}" if name.empty?
    url = ShortWorks::Params.get( params, "url", "" ){|value| download_url( value )}
    data = ShortWorks::Params.get( params, "data", "" )
    format = ShortWorks::Params.get( params, "format", "html" )
    size = ShortWorks::Params.get( params, "size", "" ){|value| pdf_size( value )}
    ShortWorks::Tmp.mkdir{
      begin
        raise "Download file error" if ! ShortWorks::Download.file( "A.pdf", url, Base64.strict_decode64( data ) )
        
        gzsl_bytes = pdf_to_gzsl_bytes( "A.pdf", "A.gzsl", size )
        raise "PDF to GZSL error" if gzsl_bytes.nil?
        
        case format
        when "json"
          render :json => { :gzsl => Base64.strict_encode64( gzsl_bytes ) }
        else
          send_data( gzsl_bytes, :filename => "#{name}.gzsl" )
        end
      rescue => e
        @err_msg = e.message
        case format
        when "json"
          render :json => { :err_msg => @err_msg }
        end
      end
    }
  end
  
private
  def pdf_size( value )
    ( /^([0-9]+)x([0-9]+)!?$/ =~ value ) ? value : "720x405"
  end
  
  def pdf_to_gzsl_bytes( pdf_path, gzsl_path, size )
    return nil if ! ShortWorks::Command.pdf_to_png( pdf_path, "%03d.png" )
    return nil if ! ShortWorks::Command.img_resize( size, "*.png" ) if ! size.empty?
    Gzsl.generate( gzsl_path, Dir.glob( "*.png" ).sort ) ? File.open( gzsl_path, "rb" ).read : nil
  end
end
