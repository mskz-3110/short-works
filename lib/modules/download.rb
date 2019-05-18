module ShortWorks
  module Download
    def self.file( path, url, data )
      if ! url.empty?
        return Command.wget( url, path )
      elsif ! data.empty?
        File.open( path, "wb" ){|f|
          f.write data
        }
      end
      File.exists?( path )
    end
  end
end
