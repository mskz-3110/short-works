require "lib/modules/command"
require "lib/modules/download"
require "lib/modules/google_drive"
require "lib/modules/params"
require "lib/modules/speaker_deck"
require "lib/modules/tmp"

class ApplicationController < ActionController::Base
  def initialize
    @err_msg = nil
    super
  end
  
protected
  def download_url( url )
    url = ShortWorks::GoogleDrive.download_url( url )
    url = ShortWorks::SpeakerDeck.download_url( url )
    url
  end
  
  def gzsl_view( url, data, format )
    ShortWorks::Tmp.mkdir{
      begin
        raise "Download file error" if ! ShortWorks::Download.file( "A.gzsl", url, Base64.strict_decode64( data ) )
        
        @gzsl_hash = Gzsl.parse( "A.gzsl" )
        raise "Gzsl parse error" if @gzsl_hash.nil?
        
        @gzsl_hash[ :images ].each_with_index{|image, index|
          @gzsl_hash[ :images ][ index ] = Base64.strict_encode64( image )
        }
        
        case format
        when "json"
          render :json => @gzsl_hash
        end
      rescue => e
        @err_msg = e.message
        case format
        when "json"
          render :json => { :err_msg => @err_msg }
        end
      end
    }
    
    case format
    when "json"
    else
      render :template => "gzsl/view"
    end
  end
end
