//refreshes the interface every 2 minutes

setInterval(function(){
  $.ajax({
        url: "refresh",
        type: 'GET',
        success: function(res){
         }
    });
}, 120000);


// TODO: REMOVE THIS BEFORE SUBMITTING
$("#test_ajax_refresh").click(function(){
  $.ajax({
        url: "refresh",
        type: 'GET',
        success: function(res){
         }
    });
});