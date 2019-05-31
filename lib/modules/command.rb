module ShortWorks
  module Command
    def self.execute( command )
      Kernel.system( command )
    end
    
    def self.wget( url, output, options = {} )
      options[ "--timeout" ] = 30 if ! options.key?( "--timeout" )
      options[ "--quota" ] = 10 * 1024 * 1024 if ! options.key?( "--quota" )
      options[ "-O" ] = output
      command = "wget -q #{options.map{|k, v| [ k, v ].join( ' ' )}.join( ' ' )} \"#{url}\""
      execute( command )
    end
    
    def self.pdf_to_png( pdf_path, png_path )
      execute( "gs -q -sDEVICE=pngalpha -dBATCH -dNOPAUSE -dUseCropBox -sOutputFile=#{png_path} #{pdf_path}" )
    end
    
    def self.img_resize( size, path )
      execute( "mogrify -resize #{size} #{path}" )
    end
  end
end
