module ShortWorks
  module GoogleDrive
    def self.download_url( url )
      url.gsub( "https://drive.google.com/open?", "https://drive.google.com/uc?export=download&" )
    end
  end
end
