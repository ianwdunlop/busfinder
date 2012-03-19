//Busfinder - UK bus stop and route information
//Copyright (C) 2011  Ian Dunlop

//This program is free software: you can redistribute it and/or modify
//it under the terms of the GNU General Public License as published by
//the Free Software Foundation, either version 3 of the License, or
//(at your option) any later version.

//This program is distributed in the hope that it will be useful,
//but WITHOUT ANY WARRANTY; without even the implied warranty of
//MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//GNU General Public License for more details.

//You should have received a copy of the GNU General Public License
//along with this program.  If not, see <http://www.gnu.org/licenses/>.

var colours = ['red','blue','green','yellow','pink','navy','salmon','tan','plum','orange'];
var current_ne_lat;
var current_ne_lon;
var current_sw_lat;
var current_sw_lon;
var first_draw = true;
var draw_new_map = true;
var bus_stops = new Array();
var map;
var trackLocation = false;
var watchID;
var geoLoc;

//hash of route id to polylines on the map
var drawnRoutes = {};
var directionsService;

function drawMap(){
var latlng = new google.maps.LatLng(53.4, -2.15);
var myOptions = {
  zoom: 16,
  center: latlng,
  mapTypeId: google.maps.MapTypeId.ROADMAP
};
map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
var routeControlDiv = document.createElement('DIV');
var routeControl = new RouteControl(routeControlDiv, map);

routeControlDiv.index = 1;
map.controls[google.maps.ControlPosition.TOP_RIGHT].push(routeControlDiv);
directionsService = new google.maps.DirectionsService();

google.maps.event.addListener(map, 'idle', function() {
    var bounds = map.getBounds();
	var ne = bounds.getNorthEast();
	var sw = bounds.getSouthWest();
	//if (!first_draw && ne.lat() < current_ne_lat && ne.lng() < current_ne_lon && sw.lat()  > current_sw_lat && sw.lng() > current_sw_lon) {
	//	draw_new_map = false;
	//}
	var distance = distanceBetween(ne.lat(), sw.lat(), ne.lng(), sw.lng());
	if (draw_new_map && distance < 3){
	first_draw = false;
	current_ne_lat = ne.lat();
	current_ne_lon = ne.lng();
	current_sw_lat = sw.lat();
	current_sw_lon = sw.lng();
	$.getJSON('bus_stops/by_bounds',
			  {
			    northeast_lat: ne.lat(),
			    northeast_lon: ne.lng(),
				southwest_lat: sw.lat(),
				southwest_lon: sw.lng()
			  },
			 function(data) {
				$.each(data, function(id){
					var code = data[id].code;
					if ($.inArray(code, bus_stops) == -1) {
					bus_stops.push(code);
					var lat = data[id].latitude;
					var lon = data[id].longitude;
					var name = data[id].name;
					var locality = data[id].locality;
					var bearing = data[id].bearing;
					var busStopLatlng = new google.maps.LatLng(lat,lon);
					var title = name + ", " + locality;
					var marker = new google.maps.Marker({
					      position: busStopLatlng, 
					      map: map, 
					      title:title
					  });
					google.maps.event.addListener(marker, 'click', function() {
					  retrieveRouteDetails(data[id].id, marker);
					});
				//}
				};
				});
			}).error(function(XMLHttpRequest,textStatus, errorThrown) {	alert(textStatus);
				        alert(errorThrown);
				        alert(XMLHttpRequest.responseText);
			});
		}
  });
}

//Get the route details in json from the web service and plot it on the map
function getRouteDetails(route_id, route_name) {
	//only get the route if it does not already exist
	if (drawnRoutes[route_id] == null) {
	var stops = new Array();
	$.getJSON('bus_routes/' + route_id,			  
			 function(data) {
				drawnRoutes[route_id] = new Array();
				//var routeColour = Math.round(0xffffff * Math.random()).toString(16);
				var routeColour = colours[randomFromTo(0,9)];
				addCheckbox(route_id, route_name, routeColour);
				var i = 0;
				var endPos = data.bus_stops.length - 1;
				//Arrange the bus stops into pairs of lat lngs and get directions
				for (i= 1; i < endPos ; i++) {
					var startLat = data.bus_stops[i].latitude;
					var startLon = data.bus_stops[i].longitude;
					var endLat = data.bus_stops[i + 1].latitude;
					var endLon = data.bus_stops[i + 1].longitude;
					var origin = new google.maps.LatLng(startLat,startLon);
					var destination = new google.maps.LatLng(endLat,endLon);
					var request = {
						origin: origin,
						destination: destination,
						travelMode: google.maps.TravelMode.DRIVING
					};
					//Get the route that the bus takes by plotting directions between the bus stops
					directionsService.route(request, function(result, status) {
						if (status == google.maps.DirectionsStatus.OK) {
							for (step_id in result.routes[0].legs[0].steps) {
								var lat_lngs = result.routes[0].legs[0].steps[step_id].lat_lngs;
								var routePath = new google.maps.Polyline({
								    path: lat_lngs,
									strokeColor: routeColour
								});
								//Keep track of all the polylines on the map for this route
								drawnRoutes[route_id].push(routePath);
								routePath.setMap(map);
							}
					  	}
					});
				}
			});
		}
}
//generate random number between 'from' and 'to'
function randomFromTo(from, to){
       return Math.floor(Math.random() * (to - from + 1) + from);
}

//convert degrees to radians
function degreesToRadians(deg) {
var pi = Math.PI;
var radians = deg*(pi/180);
return radians;
}

//calculate distance between 2 points
function distanceBetween(lat1, lat2, lon1, lon2) {
	
	var R = 6371; // km
	var dLat = degreesToRadians(lat2-lat1);
	var dLon = degreesToRadians(lon2-lon1);
	var lat1 = degreesToRadians(lat1);
	var lat2 = degreesToRadians(lat2);

	var a = Math.sin(dLat/2) * Math.sin(dLat/2) +
	        Math.sin(dLon/2) * Math.sin(dLon/2) * Math.cos(lat1) * Math.cos(lat2); 
	var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)); 
	var d = R * c;
	return d;
}
//each route has a checkbox that can turn the route display on or off
function addCheckbox(route_id, route_name, colour) {
   var container = $('#routes');

   var html = '<div><input type="checkbox" checked=true onclick=hideOrShowRoute(' + route_id + ') id="cb_'+route_id+'" value="'+route_name+'" /> <label style="background-color: ' + colour + ';" for="cb_'+route_id+'">'+route_name+'</label></div>';
   container.append($(html));
}

//hide the route for a specific route id
function hideOrShowRoute(route_id) {
	for (i= 1; i < drawnRoutes[route_id].length ; i++) {
		if (drawnRoutes[route_id][i].getMap() != null) {
			drawnRoutes[route_id][i].setMap(null);
		} else {
			drawnRoutes[route_id][i].setMap(map);
		}
	}
}

//Custom control for showing the routes that are showing
function RouteControl(controlDiv, map) {

  // Set CSS styles for the DIV containing the control
  // Setting padding to 5 px will offset the control
  // from the edge of the map
  controlDiv.style.padding = '5px';

  // Set CSS for the control border
  var controlUI = document.createElement('DIV');
  controlUI.style.backgroundColor = 'white';
  controlUI.style.borderStyle = 'solid';
  controlUI.style.borderWidth = '2px';
  controlUI.style.cursor = 'pointer';
  controlUI.style.textAlign = 'center';
  controlUI.title = 'Toggle routes on or off';
  controlDiv.appendChild(controlUI);

  // Set CSS for the control interior
  var controlText = document.createElement('DIV');
  controlText.style.fontFamily = 'Arial,sans-serif';
  controlText.style.fontSize = '12px';
  controlText.style.paddingLeft = '4px';
  controlText.style.paddingRight = '4px';
  controlText.innerHTML = 'Routes';
  controlUI.appendChild(controlText);

  google.maps.event.addDomListener(controlUI, 'click', function() {
    $('#routes').toggle();
  });
}
function centreLocation() {
	if (navigator.geolocation) {
		if (geoLoc == null) {
			geoLoc = navigator.geolocation;
		}
		geoLoc.getCurrentPosition(showLocation, errorHandler);
		trackLocation = true;
	} else {
	  alert("Your browser does not support geo-location or you have not allowed it.")
	}
}
function followLocation() {
	if (trackLocation) {
		clearWatch(watchID);
		trackLocation = false;
	} else if (navigator.geolocation) {
		var options = {timeout:10000};
		if (geoLoc == null) {
			geoLoc = navigator.geolocation;
		}
		watchID = geoLoc.watchPosition(showLocation,errorHandler, options);
		trackLocation = true;
	} else {
	  alert("Your browser does not support geo-location or you have not allowed it.")
	}
}
function showLocation(position) {
  var latitude = position.coords.latitude;
  var longitude = position.coords.longitude;
  map.setCenter(new google.maps.LatLng(latitude,longitude))
}
function errorHandler(error){
	//doesn't matter
}
function clearWatch(){
   geoLoc.clearWatch(watchID);
}

function retrieveRouteDetails(bus_stop_id, marker) {
	$.getJSON('bus_stops/' + bus_stop_id,
	{},
	function(data) {
		var routes = "<ul>";
		for (route_id in data.bus_routes) {
			routes = routes + "<li><button style='border:none; background:transparent; cursor: pointer;'onclick='getRouteDetails(" + data.bus_routes[route_id].id + ','  + '\"' + data.bus_routes[route_id].description  + '\"' + ")'><br/>" + data.bus_routes[route_id].route_number + " " + data.bus_routes[route_id].description + "</button></li>";
		};
		routes = routes + "</ul>";
		var infowindow = new google.maps.InfoWindow({
		    content: "<h3>" + marker.title + "</h3><h2>Click on a route to display on the map</h2>" + routes
		});
		//google.maps.event.addListener(marker, 'click', function() {
		  infowindow.open(map,marker);
		//});
	}
    );
}