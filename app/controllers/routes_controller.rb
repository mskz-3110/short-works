class RoutesController < ApplicationController
  def view
    @routes = []
    [
      PdfController,
      GzslController,
      QrcodeController,
      MarkdownController
    ].each{|controller|
      controller.routes.each{|route|
        @routes.push route
      }
    }
  end
end
