module ShortWorks
  module Command
    def self.execute( command )
      case Rails.env
      when "development"
        puts "[#{Dir.pwd}] #{command}"
      end
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
    
    def self.img_resize( path, width, height )
      execute( "mogrify -resize #{width}x#{height} #{path}" )
    end
    
    def self.markdown_to_pdf( pdf_path, markdown_path, css_path, options = {} )
      __DIR__=File.dirname( __FILE__ )
      css_path = "#{__DIR__}/markdown-pdf.css" if ! File.exists?( css_path )
      options[ :width ] = "720" if ! options.key?( :width )
      options[ :height ] = "405" if ! options.key?( :height )
      execute( "node #{__DIR__}/markdown-pdf.js #{pdf_path} #{markdown_path} #{css_path} #{options[ :width ]}px #{options[ :height ]}px" )
    end
  end
end
