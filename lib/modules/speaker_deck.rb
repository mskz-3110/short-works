require "open-uri"

module ShortWorks
  module SpeakerDeck
    def self.download_url( url )
      return url if /speakerdeck/ !~ url
      
      document = Nokogiri::HTML.parse( open( url ).readlines.join )
      document.xpath( '//a' ).each{|element|
        href = element.attribute( "href" )
        case File.extname( href )
        when ".pdf"
          url = href.value
        end
      }
      url
    end
  end
end
