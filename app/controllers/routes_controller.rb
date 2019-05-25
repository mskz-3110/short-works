class RoutesController < ApplicationController
  def view
    lines = `bundle exec rails routes`.split( "\n" )
    lines.shift
    @routes = []
    lines.each{|line|
      values = line.split( /\s+/ )
      route = {}
      route[ :path ] = values.pop.split( "#" )
      route[ :rule ] = values.pop
      route[ :method ] = values.pop
      @routes.push route
    }
  end
end
