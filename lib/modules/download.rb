module ShortWorks
  module Download
    def self.file( path, url )
      if /^file:\/\// =~ url
        if "development" == Rails.env
          url.gsub!( /^file:\/\//, "" )
          return Command.execute( "cp #{url} #{path}" )
        else
          return false
        end
      end
      
      return Command.wget( url, path )
    end
  end
end
