function hide_voting_interface(class_name){
	var update_column = $(".vote_destroy."+class_name).parent();
	update_column.html("thanks!");
	update_column.css("font-style", "italic");
	update_column.css("color", "green");
}