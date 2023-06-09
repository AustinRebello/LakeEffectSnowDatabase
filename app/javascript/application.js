// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

//= require jquery_ujs
//= require turbolinks
//= require_self
//= require_tree .


//window.alert(document.getElementById("map"))
//$(document).on('turbolinks:load', function(){
    //window.alert("HEY")
    //if ($('#map').length > 0){
    
        //var google_map = $('meta[name=google_maps]').attr("content");
        //$.getScript(`https://maps.googleapis.com/maps/api/js?key=${google_map}&callback=initMap`);
    //}
//})

if(document.getElementById("map")!=null){
    var google_map = $('meta[name=google_maps]').attr("content");
    $.getScript(`https://maps.googleapis.com/maps/api/js?key=${google_map}&callback=initMap`);
}
