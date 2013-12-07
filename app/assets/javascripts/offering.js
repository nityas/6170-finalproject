

function acknowledge_vote_submission(selector){
	var update_column = $("#"+selector).parent();
	update_column.html("thanks!");
	update_column.css("font-style", "italic");
	update_column.css("color", "green");
}

function alert_user(str){
	alert(str);
}