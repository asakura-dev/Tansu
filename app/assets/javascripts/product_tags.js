(function(){
    function ProductTagsViewModel(){
	var self = this;
	self.tags = ko.observableArray(gon.tags);
	self.input = ko.observable();
	self.error_message = ko.observable("");
	self.reset_message = function(){
	    self.error_message("");
	};
	self.remove = function(tag){
	    $.ajax({
		method: "DELETE",
		url: gon.tags_path,
		data: {"tag" : tag},
		success: function(data){
		    if(data["status"] == "success"){
			self.tags.remove(tag);
		    }else{
			if(data["message"]){
			    self.error_message(data["message"]);
			}
		    }
		},
		error: function(data){
		}
	    });
	}
	self.addTag = function(){
	    console.log("clicked");
	    var new_tag = self.input();
	    if(self.tags.indexOf(new_tag) != -1){
		self.error_message("その要素はすでに追加されています");
	    }else{
		$.ajax({
		    method: "POST",
		    url: gon.tags_path,
		    data: {"new_tag" : new_tag},
		    success: function(data){
			if(data["status"] == "success"){
			    self.tags.push(new_tag);
			    self.input("");
			}else{
			    if(data["message"]){
				self.error_message(data["message"]);
			    }
			}
		    },
		    error: function(){
			self.error_message("通信エラーが発生しました");
		    }		
		});
	    }
	};
	self.editing = ko.observable(false)
	self.btn_text = ko.computed(function(){
	    if(self.editing() == true){
		return "編集を完了する";
	    }else{
		return "タグを編集";
	    }
	});
	self.toggle = function(){
	    self.editing(!self.editing());
	};
    }
    root_vm["product_tags_vm"] = new ProductTagsViewModel();
})();
