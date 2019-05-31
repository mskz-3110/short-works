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
  
  def action( &block )
    @format = ShortWorks::Params.get( params, "format", "html" )
    begin
      block.call
    rescue => e
      @err_msg = e.message
      case Rails.env
      when "development"
        @err_msg = "#{@err_msg}\n#{e.backtrace.join( '\n' )}"
      end
      
      case @format
      when "json"
        render :json => { :err_msg => @err_msg }
      else
        render :template => "application/error"
      end
    end
  end
  
  def gzsl_view( url, data )
    action{
      ShortWorks::Tmp.mkdir{
        raise "Download file error" if ! ShortWorks::Download.file( "A.gzsl", url, Base64.strict_decode64( data ) )
        
        @gzsl_hash = Gzsl.parse( "A.gzsl" )
        raise "Gzsl parse error" if @gzsl_hash.nil?
        
        @gzsl_hash[ :images ].each_with_index{|image, index|
          @gzsl_hash[ :images ][ index ] = Base64.strict_encode64( image )
        }
        
        case @format
        when "json"
          render :json => @gzsl_hash
        end
      }
      
      case @format
      when "json"
      else
        render :template => "gzsl/view"
      end
    }
  end
end
