$(document).ready( function () {

  $.ajaxSetup({
    headers: {
      'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
    }
  });

  /*
    Handles when user hits "submit" to make a location
    Currently displayed externally as "make a location" but internally as a location search,
    so that post-MVP changes can be made more easily.
  */
  $("#search").click(function(){
    var query = $("#queryField").val();
    create_search(query);
  });

  /*
    Sends user's location query to whereis.mit.edu via ajax request
    Gets back the most likely MIT location based on this query, along with its associated information.
  */
  function create_search(query){
    $.ajax({
        url: "http://whereis.mit.edu/search",
        type: 'GET',
        data: {type: 'query', q: query, output: 'json'},
        dataType: 'jsonp',
        success: function(res){
          handle_search_result(res[0]);
          //
        }
    });
  }

  /*
   Takes in MIT location information (as "result") and uses those as parameters to create a location.
  */
  function handle_search_result(result){
    console.log(result);
    if (result == undefined){
      handle_null_result();
    }else{
      var latitude = result.lat_wgs84;
      var longitude = result.long_wgs84;
      var image = result.bldgimg;
      var name = result["name"];
      var mitlocation_id = result["id"];
      var bldgnum = result["bldgnum"]

    $.ajax({
      type: "GET",
      url: "/locations/exists",
      dataType: "JSON",
      data: { 'mitlocation_id': mitlocation_id },
      success: function(data) {
        console.log(data);
        var centerpoint = new google.maps.LatLng(latitude,longitude);
        handler.getMap().setCenter(centerpoint)
        if (data) {
           //TODO open window automatically
        } else {
            show_location(latitude, longitude, mitlocation_id, name, bldgnum);
        }
      }
    });
    }
  }

  
  function show_location(lat, lng, mitlocation_id, location_name,bldgnum){
    var infoWindowContent = [
    "<h2><b> Building "+String(bldgnum)+ " - " +String(location_name) + "</b></h2>",
    "<h2>Post A New Byte </h2>",
    "<form id='map-form'>",
    "<div>Location Details: <input id='location-details' type='text' /></div>",
    "<div>Food Description: <input id='food-description' type='text' /></div>",
    '<input type="button" value="Post Byte" onClick="saveData(\'' + lat + '\',\'' + lng +
     '\', \'' + mitlocation_id + '\', \'' + location_name + '\',\'' + bldgnum + '\')" />',
    "</form>"].join("");   

    var tempmarker= {"lat":lat,
      "lng":lng,
      "picture":{
       "url":"/pin.png",
       "width":"50",
       "height":"68"
      },
      "infowindow":infoWindowContent
    };

    handler.addMarker(tempmarker);
    //TODO  open window automatically
  };


  /*
    Sends user's search query to whereis.mit.edu and gets back information for this potential location.
  */
  function handle_null_result(){
    alert("Sorry, no MIT location found for your query");
  }
});


/*
    Creates this location if it didn't already exist.
  */
  function create_location(lat, lng, mitlocation_id, location_name,bldgnum){
    $.ajax({
      url: "/locations",
      type: 'POST',
      data: {location: {latitude: lat, longitude: lng, title: location_name,  customid: mitlocation_id, building_number: bldgnum}},
      success: function(res){
        console.log("location created: " + location_name)
        location.reload();
      }
    })
  }


    function saveData(lat, lng, mitlocation_id, location_name,bldgnum){
      var location_details = escape(document.getElementById("location-details").value);
      var food = escape(document.getElementById("food-description").value);
     // var mitlocationID2 = escape(document.getElementById("mitlocation-id").value);
      console.log(location_details)
      console.log(food)
      console.log(lat)
      console.log(lng)
      console.log(location_name)
      console.log(mitlocation_id)
      console.log(bldgnum)
      //TODO add offering after location creation
      create_location(lat, lng, mitlocation_id, location_name, bldgnum);


      //console.log(latlng)
    };
