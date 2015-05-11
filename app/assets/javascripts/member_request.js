(function(){
    // メンバーの追加と承認 のビューモデル
    function MemberRequestViewModel(){
	var self = this;
	// 参加承認リクエストオブジェクト
	// - コンストラクタ関数
	function MemberRequest(id,name,image){
	    this.id = id;
	    this.name = name;
		this.image = image;
	}
	// リクエストの情報をサーバに送信して更新する
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
		    if (request.authority != "reject"){
			// リストから消す
			// どちらのリストに入っているか分からないので
			// 両方で一致するものを探して消す
			self.requests.remove(function(item){
			    return item.id == request.user_id;
			});
			self.rejected_requests.remove(function(item){
			    return item.id == request.user_id;
			});
		    }
		},
		error: function(data){
		    // エラーなら何もしない
		}
	    });
	};
	// リクエストを承認する
	MemberRequest.prototype.approve = function(){
	    this.update("member");
	};
	// リクエストを拒否する
	MemberRequest.prototype.reject = function(){
	    this.update("reject");
	};

	// リクエストをリストに追加する
	// (Viewのインラインスクリプトから呼ばれる)
	// target: 追加先リストの種類(requests or rejected_requests)
	// id,name,image: 参加しているユーザの情報
	self.pushRequest = function(target,id,name,image){
	    self[target].push(new MemberRequest(id, name,image));
	};

	// リクエストを隠すアニメーション
	self.hideRequest = function(elem){
	    if (elem.nodeType === 1) {
		$(elem).animate({opacity: 0}, 500).slideUp(function() {
		    $(elem).remove();
		});
	    }
	};
	// リクエストを表示するアニメーション
	self.showRequest = function(elem) {
	    if (elem.nodeType === 1) {
		$(elem).hide().slideDown();
	    }
	};
	// 参加申請のリクエストのリスト
	self.requests = ko.observableArray();
	// 拒否済みのリクエストのリスト
	self.rejected_requests = ko.observableArray();
    }
    root_vm["member_request_vm"] = new MemberRequestViewModel();
})();
