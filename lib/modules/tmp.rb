module ShortWorks
  module Tmp
    def self.mkdir( &block )
      Dir.mktmpdir{|tmp_dir|
        Dir.chdir( tmp_dir, &block )
      }
    end
  end
end
