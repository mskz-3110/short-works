# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $( ".slide" ).slick({
    dots: true,
    infinite: true,
    centerMode: true,
    variableWidth: true
  })
  
  $( "#local_file" ).on( "change", ->
    file_reader = new FileReader()
    file_reader.onload = ->
      $( "#data" ).val( @result.split( "," )[ 1 ] )
    file_reader.readAsDataURL( $( "#local_file" ).prop( "files" )[ 0 ] )
  )
