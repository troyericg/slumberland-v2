// Menu View

App.Views.Menu = Backbone.View.extend({
	initialize:function(){
		this.render(this.collection);
		this.collection.on("update",this.updateNum,this);
	},
	render:function(entries){
		var $stage = $("ul.characters-mini"),
			collectedJSON = entries.toJSON(),
			charList = [],
			JSTemplate;

		// collecting characters
		_.each(collectedJSON, function(comic){
			_.each(comic.characters, function(character){
				charList.push(character);
			});
		});

		JSTemplate = JST.menuList({ comics: _.uniq(charList) })
		
		$stage.html(JSTemplate);
		this.updateNum();
	},
	updateNum:function(){
		var $numSpan = $("p.num-entries span");
		$numSpan.text( $("ul li.entry").length );
	}
});