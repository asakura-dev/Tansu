(function(){
    function ProductFormTagsViewModel(){
	var self = this;
	self.tags = ko.observableArray();
	self.input = ko.observable();
	self.error_message = ko.observable();
	self.reset_message = function(){
	    self.error_message("");
	};
	self.addTag = function(){
	    var new_tag = self.input();
	    if(self.tags.indexOf(new_tag) != -1){
		self.error_message("そのタグは既に追加されています");
	    }else if(new_tag.length > 20){
		self.error_message("タグは20文字以内にしてください")
	    }else if(self.tags().length > 19){
		self.error_message("タグは20個までしか登録できません");
	    }else{
		self.tags.push(new_tag);
		self.input("");
	    }
	}
	self.remove = function(tag){
	    self.tags.remove(tag);
	}
    }
    root_vm["product_form_tags_vm"] = new ProductFormTagsViewModel();
})();
