// Comics Collection

App.Collections.Comics = Backbone.Collection.extend({
	model: Comic,
	url: "/gallery",
	filterList:function(factor,item){
		return _(this.filter(function(data){
			if(factor === "year"){
				return data.get("date_published").split("-")[0] == item;
			} else if (factor === "character") {
				return $.inArray(item, data.get("characters")) != -1;
			}
		}));
	}
});