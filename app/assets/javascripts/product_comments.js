(function(){
    function ProductCommentsViewModel(){
	var self = this;
	self.authority = gon.authority;
	self.user_id = gon.user_id;
	self.comments = ko.observableArray(gon.comments);
	self.url = function(image){
	    if(image == "/user_default.png"){
		image = "/assets/user_default.png"
	    }
	    return image;
	};
	//self.comments = ["",""];
	self.textarea = ko.observable("");
	self.error_message = ko.observable("");
	self.success_message = ko.observable("");
	self.reset_message = function(){
	    self.error_message("");
	    self.success_message("");
	};
	self.create = function(){
	    var content = self.textarea();
	    $.ajax({
		method: "POST",
		url: "/comments",
		data: {"comment":{
		    content: content,
		    product_id: gon.product_id
		}},
		success: function(data){
		    location.reload(true);
		},
		error: function(data){
		    console.log(data);
		}
	    });
	};
	self.remove = function(place){
	    $.ajax({
		method: "DELETE",
		url: "/comments/"+place.id,
		success: function(data){
		    location.reload(true);
		},
		error: function(data){
		    console.log(data);
		}
	    });
	};
	// リクエストを隠すアニメーション
	self.hideEffect = function(elem){
	    if (elem.nodeType === 1) {
		$(elem).animate({opacity: 0}, 500).slideUp(function() {
		    $(elem).remove();
		});
	    }
	};
	// リクエストを表示するアニメーション
	self.showEffect = function(elem) {
	    if (elem.nodeType === 1) {
		$(elem).hide().slideDown();
	    }
	};
    }
    root_vm["product_comments_vm"] = new ProductCommentsViewModel();
})();
