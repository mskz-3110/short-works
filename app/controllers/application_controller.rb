require "lib/modules/command"
require "lib/modules/download"
require "lib/modules/google_drive"
require "lib/modules/params"
require "lib/modules/speaker_deck"
require "lib/modules/tmp"

class ApplicationController < ActionController::Base
  def initialize
    @err_msg = nil
    @width = "720"
    @height = "405"
    super
  end
  
  def ui
    commit = ShortWorks::Params.get( params, "commit", "" )
    if ! commit.empty?
      send commit
    else
      @output_format = ShortWorks::Params.get( params, "output_format", "" )
    end
  end
  
protected
  def validate( regex, value )
    regex =~ value ? value : ""
  end
  
  def validate_number( value )
    validate( /^[0-9]+$/, value )
  end
  
  def validate_url( value )
    validate( /^(http|https|file):\/\/[\w\-\.\/\?%=&]+$/, value )
  end
  
  def validate_direction( value )
    validate( /^[HV]$/, value )
  end
  
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
        @err_msg = [ @err_msg ].concat( e.backtrace ).join( "\n" )
      end
      
      case @format
      when "json"
        render :json => { :err_msg => @err_msg }
      else
        render :template => "application/error"
      end
    end
  end
  
  def gzsl_view( path, format )
    action{
      @gzsl = Gzsl.parse( path )
      raise "Gzsl error" if @gzsl.nil?
      
      @gzsl[ :images ].each_with_index{|image, index|
        @gzsl[ :images ][ index ] = Base64.strict_encode64( image )
      }
      
      case format
      when "json"
        render :json => @gzsl
      else
        render :template => "gzsl/view"
      end
    }
  end
  
  def file_to_bytes( path )
    File.open( path, "rb" ).read
  end
  
  def pdf_to_gzsl( gzsl_path, pdf_path, width, height )
    return false if ! ShortWorks::Command.pdf_to_png( pdf_path, "%03d.png" )
    return false if ! ShortWorks::Command.img_resize( "*.png", width, height )
    Gzsl.generate( gzsl_path, Dir.glob( "*.png" ).sort )
  end
end
