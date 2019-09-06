# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  slick = $( ".horizontal-slide" ).slick({
    infinite: false,
    centerMode: true,
    variableWidth: true
  })
  
  $( ".horizontal-slide" ).on( "click", ( event ) ->
    x = event.pageX
    rect = @getBoundingClientRect()
    if x < ( rect.width / 2 )
      slick.slick( "slickPrev" )
    else
      slick.slick( "slickNext" )
  )
  
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
  
  $( ".slide" ).css( "visibility", "visible" )
