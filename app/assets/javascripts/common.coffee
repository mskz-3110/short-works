# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  slick = $( ".H-slide" ).slick({
    infinite: false,
    centerMode: true,
    variableWidth: true
  })
  
  $( ".H-slide" ).on( "click", ( event ) ->
    x = event.pageX
    rect = @getBoundingClientRect()
    if x < ( rect.width / 2 )
      slick.slick( "slickPrev" )
    else
      slick.slick( "slickNext" )
  )
  
  $( ".slide" ).css( "visibility", "visible" )
