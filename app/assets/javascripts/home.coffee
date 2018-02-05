# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@borderFlash = () ->
    # console.log(document.getElementById('frontPageFlags'))
    document.getElementById('clickflagprompt').style.visibility = 'visible'
    document.getElementById('frontPageFlags').style.animation = 'blink 2s ease-in infinite'
