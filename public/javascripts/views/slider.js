// Slider 

App.Views.Slider = Backbone.View.extend({
	events:{
		"click li.year-tick": "filter"
	},
	initialize:function(){
		this.$el = $("div#slider-controls");
		this.render();
	},
	render:function(){
		this.buildSlider();
	},
	buildSlider:function(){

		jQuery.noConflict();
		
		$("#slider-range").slider({
			range: true,
			min: 1905,
			max: 1914,
			values: [1905, 1914],
			slide: function(event, ui) {
				//$("#amount").val("$" + ui.values[0] + " - $" + ui.values[1]);
			},
			change: function(event, ui) {
				//Slumberland.rangeFilter('year',ui.values[0], ui.values[1]);
			}
		});
	},
	filter:function(e){
		var year = $(e.target).text();
		console.log(this.collection.filterList("year", year));
	}
});