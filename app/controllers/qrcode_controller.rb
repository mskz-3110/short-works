class QrcodeController < ApplicationController
  def create
    value = ShortWorks::Params.get( params, "value", "" )
    action{
      qrcode = RQRCode::QRCode.new( value ).to_img.resize( 200, 200 )
      case @output_format
      when "json"
        render :json => { :qrcode => Base64.strict_encode64( qrcode.to_blob ) }
      else
        send_data( qrcode, :filename => "ShortWorks.png" )
      end
    }
  end
  
  def view
    qrcode_url = ShortWorks::Params.get( params, "qrcode_url", "" ){|value| download_url( validate_url( value ) )}
    action{
      ShortWorks::Tmp.mkdir{
        raise "Download error: #{qrcode_url}" if ! ShortWorks::Download.file( "A", qrcode_url )
        
        zbarimg = "zbarimg"
        Dir.glob( "#{Rails.root}/vendor/bin/zbarimg" ).each{|path|
          zbarimg = "LD_LIBRARY_PATH=#{Rails.root}/vendor/lib #{path}"
        }
        @value = `#{zbarimg} -q --raw A`.chomp
        case @output_format
        when "json"
          render :json => { :value => @value }
        else
          render "qrcode/view"
        end
      }
    }
  end
end
