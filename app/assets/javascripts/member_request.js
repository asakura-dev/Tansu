(function(){
    function MemberRequestViewModel(){
	var self = this;
	//参加承認リクエストオブジェクトのコンストラクタ関数
	function MemberRequest(id,name,image){
	    this.id = id;
	    this.name = name;
	    if(image == "user_default.png"){
		this.image = "/assets/user_default.png";
	    }else{
		this.image = image;
	    }
	}
	//参加承認リクエストをupdateする
	MemberRequest.prototype.update = function(authority){
	    var member_request = this;
	    $.ajax({
		type: "PATCH",
		url: "/admin/member/request",
		data:{
		    "user":{
			"user_id": this.id,
			"authority": authority
		    }
		},
		success: function(data){
		    var request = data.request;
		    self.requests.remove(function(item){
			return item.id == request.user_id;
		    });
		    self.rejected_requests.remove(function(item){
			return item.id == request.user_id;
		    });
		    if(request.authority == "reject"){
			self.rejected_requests.push(member_request);
		    }
		},
		error: function(data){
		    console.log("error");
		    console.log(data);
		}
	    });
	};
	MemberRequest.prototype.approve = function(){
	    this.update("member");
	};
	MemberRequest.prototype.reject = function(){
	    this.update("reject");
	};
	self.pushRequest = function(target,id,name,image){
	    self[target].push(new MemberRequest(id, name,image));
	};
	self.hideRequest = function(elem){ 
	    if (elem.nodeType === 1) {
		$(elem).slideUp(function() {
		    $(elem).remove();
		});
	    }
	};
	self.showRequest = function(elem) {
	    console.log("show");
	    if (elem.nodeType === 1) {
		$(elem).hide().slideDown();
	    }
	};
	self.requests = ko.observableArray();
	self.rejected_requests = ko.observableArray();
    }
    root_vm["member_request_vm"] = new MemberRequestViewModel();
})();
