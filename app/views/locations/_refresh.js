//refreshes the interface every 2 minutes

setInterval(function(){
  // do not refresh if focus is currently on an input element
  if (document.activeElement.tagName == "INPUT"){return;}

  //refresh
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