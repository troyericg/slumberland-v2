App.Routers.Comics = Backbone.Router.extend({
	routes: {
		// routes 
		"" : "index",
		"gallery/:id" : "show",
		'*actions': 'defaultAction' // set up default
	},
	index:function(){
		var comics = new App.Collections.Comics();
		comics.fetch({
			success: function(){
				new App.Views.Index({ collection: comics });
				//new App.Views.Slider({ collection: comics });
				new App.Views.Menu({ collection: comics });
			},
			error:function(){
				console.log("error retrieving comics");
			}
		});
	},
	show:function(){
		var comic = new App.Views.Comic({ model: Comic });
	},
	defaultAction:function(actions){
		console.log("no route");
	}
});