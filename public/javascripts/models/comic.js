
// COMIC.JS

var Comic = Backbone.Model.extend({
	defaults: {
		"title": "",
		"author": "",
		"date_display": "",
		"date_published": "",
		"summary": "",
		"characters": "",
		"contents": "",
		"notes": "",
		"transcript": "",
		"transcript_text": "",
		"img": "",
		"img_thumb": "",
		"img_link": "",
		"comic_id": ""
	}
	// url: function(){
	// 	var base = '/gallery';
	// 	if (this.isNew()) return base;
	// 	return base + (base.charAt(base.length - 1) == '/' ? '' : '/') + this.id;
	// }
});