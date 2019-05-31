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
    file_name = $( "#local_file" ).val().split( /[\/\\]/ ).pop()
    $( "#local_file_status" ).html( "Loading: "+ file_name )
    file_reader = new FileReader()
    file_reader.onload = ->
      $( "#data" ).val( @result.split( "," )[ 1 ] )
      $( "#local_file_status" ).html( "Loaded: "+ file_name )
      $( "#local_file" ).val( "" )
    file_reader.readAsDataURL( $( "#local_file" ).prop( "files" )[ 0 ] )
  )