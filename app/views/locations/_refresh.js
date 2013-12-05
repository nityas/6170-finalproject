//refreshes the interface every 2 minutes

setInterval(function(){
  $.ajax({
        url: "refresh",
        type: 'GET',
        success: function(res){
         }
    });
}, 120000);