class RoutesController < ApplicationController
  def view
    @lines = `bundle exec rails routes`.split( "\n" )
    @lines.shift
  end
end
