// Application js

var App = {
	Views: {},
	Routers: {},
	Collections: {},
	init: function(){
		// intialize here
		new App.Routers.Comics();
		Backbone.history.start();
	}
};