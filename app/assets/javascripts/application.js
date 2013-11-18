// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//


//= require jquery
//= require jquery_ujs
//= require underscore
//= require gmaps/google
//= require bootstrap
//= require_tree .

function create_my_search(query){
    console.log("aaaaaaaaaaaaaaaaaab");
    $.ajax({
        url: "http://whereis.mit.edu/search",
        type: 'GET',
        data: {type: 'query', q: query, output: 'json'},
        dataType: 'jsonp',
        success: function(res){
          handle_search_result(res[0]);
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