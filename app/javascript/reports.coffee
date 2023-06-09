@initMap = ->
  center = 
    lat: 0
    lng: 0

  map = new (google.maps.Map) $('#map')[0],
    zoom: 2
    center: center

  #infowindow = new (google.maps.InfoWindow)

  #$.getJSON '/snow_reports/map.json', (jsonData) ->
    #console.log(jsonData)
    #$.each jsonData, (key, data) ->
      #latLng = new (google.maps.LatLng)(data.lat, data.lng)
      #marker = new (google.maps.Marker)
        #position: latLng
        #map: map
        #title: data.title

