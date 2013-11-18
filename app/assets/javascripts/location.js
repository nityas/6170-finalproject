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
          location.reload()

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
      create_location(latitude, longitude, mitlocation_id, name, bldgnum);
    }

  }

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
      }
    })
  }

  /*
    Sends user's search query to whereis.mit.edu and gets back information for this potential location.
  */
  function handle_null_result(){
    alert("Sorry, no MIT location found for your query");
  }

});