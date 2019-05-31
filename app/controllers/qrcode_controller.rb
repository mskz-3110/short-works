class QrcodeController < ApplicationController
  def ui
    @form_format = ShortWorks::Params.get( params, "form_format", "html" )
  end
  
  def create
    value = ShortWorks::Params.get( params, "value", "" )
    name = ShortWorks::Params.get( params, "name", "" ){|value| File.basename( value )}
    name = "qrcode_#{`date \"+%Y%m%d_%H%M\"`.chomp}" if name.empty?
    action{
      qrcode_img = RQRCode::QRCode.new( value ).to_img.resize( 200, 200 )
      case @format
      when "json"
        render :json => { :qrcode => Base64.strict_encode64( qrcode_img.to_blob ) }
      else
        send_data( qrcode_img, :filename => "#{name}.png" )
      end
    }
  end
  
  def view
    url = ShortWorks::Params.get( params, "url", "" ){|value| download_url( value )}
    data = ShortWorks::Params.get( params, "data", "" )
    action{
      ShortWorks::Tmp.mkdir{
        raise "Download file error" if ! ShortWorks::Download.file( "A", url, Base64.strict_decode64( data ) )
        
        zbarimg = "zbarimg"
        Dir.glob( "#{Rails.root}/vendor/bin/zbarimg" ).each{|path|
          zbarimg = "LD_LIBRARY_PATH=#{Rails.root}/vendor/lib #{path}"
        }
        @value = `#{zbarimg} -q --raw A`.chomp
        case @format
        when "json"
          render :json => { :value => @value }
        end
      }
    }
  end
end
