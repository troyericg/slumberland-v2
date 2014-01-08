// SINGLE COMIC VIEW

App.Views.Comic = Backbone.View.extend({
	tagName: 'li',
	initialize:function(){
		this.render();
	},
	template: _.template('<h2><%= comic.title %> | <%= comic.date_display %></h2>'),
	render:function(){
		var that = this;
		var comic_item = this.model;
	}
});