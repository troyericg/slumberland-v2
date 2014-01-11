// Index View

App.Views.Index = Backbone.View.extend({
	tagName: "ul",
	initialize:function(models, options){
		this.buildSlider();
		this.render(this.collection);
		this.bind("reset", this.render(this.collection));
	},
	render:function(entries){
		root = this;
		var $stage = $("div#gallery-view");
		this.clear();

		entries.each(function(model){
			JSTemplate = JST.comic({ comic: model.toJSON() });
			root.$el.append(JSTemplate);
		});
		
		$stage.html(this.$el);
		this.collection.trigger("update");
	},
	buildSlider:function(){
		root = this;

		jQuery.noConflict();
		
		$("#slider-range").slider({
			range: true,
			min: 1905,
			max: 1914,
			values: [1905, 1914],
			slide: function(event, ui) {
				console.log(ui.values[0] +  " - " + ui.values[1]);
				//$("#amount").val("$" + ui.values[0] + " - $" + ui.values[1]);
			},
			change: function(event, ui) {
				console.log(ui.values[0] +  " - " + ui.values[1]);
				//Slumberland.rangeFilter('year',ui.values[0], ui.values[1]);
			}
		});

		$("li.year-tick").on("click", function(){
			root.setYear(this);
			root.filter(this);
		});
	},
	clear: function(){
		this.$el.empty();
	},
	filter:function(year){
		var year = $(year).text();
		this.render(this.collection.filterList("year", year));
	},
	setYear:function(year){
		var setYear = $(year).data('year');
		$("#slider-range").slider("values", 0, setYear);
		$("#slider-range").slider("values", 1, setYear);
	}
});