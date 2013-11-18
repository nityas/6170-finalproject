$(document).ready( function () {
  $("#search").click(function(){
    var query = $("#queryField").val();
    create_search(query);
    
  });

  function create_search(query){
    $.ajax({
        url: "http://whereis.mit.edu/search",
        type: 'GET',
        data: {type: 'query', q: query, output: 'json'},
        dataType: 'jsonp',
        success: function(res){
          handle_search_result(res[0]);
         // $('#map').html('<%= j(render partial: 'map') %>');

        }
    });
  }

  function handle_search_result(result){
    console.log(result);
    if (result == undefined){
      handle_null_result();
    }else{

      var latitude = result.lat_wgs84;
      var longitude = result.long_wgs84;
      var image = result.bldgimg;
      var address = result.address;
      var name = result["name"];
      var mitlocation_id = result["id"];
      create_location(latitude, longitude, mitlocation_id, name, address);
    }

  }

  /*
    Creates this location if it didn't already exist.
  */
  function create_location(lat, lng, mitlocation_id, location_name, addr){
    $.ajax({
      url: "/locations",
      type: 'POST',
      data: {location: {latitude: lat, longitude: lng, address: addr, title: location_name, description: "sample description", customid: mitlocation_id}},
      success: function(res){
        console.log("location created: " + location_name)
      }
    })
  }

  /*
    Sends user's search query to whereis.mit.edu and gets back information for this potential location.
  */
  function handle_null_result(){
    alert("no MIT location found for your query");
  }

});