(function(){
    /// メンバーの権限管理 のビューモデル
    function MembersViewModel(){
	var self = this;
	// メンバー オブジェクト
	function Member(id,name,authority,image){
	    var member = this;
	    this.id = id;
	    this.name = name;
	    this.authority = authority;
		this.image = image;
	    this.authorities = [
		{name: "オーナー", value: "owner"},
		{name: "マネージャー", value: "manager"},
		{name: "一般ユーザー", value: "member"},
		{name: "メンバーから除外", value: "reject"}
	    ];
	    // セレクタで選択されている権限
	    // ビューで選択が変更されると，この値が変わる
	    // owner or manager or member
	    this.selectedValue = ko.observable(this.authority);

	    // セレクタが変更された時に実行される
	    this.optionChanged = ko.computed(function(){
		/* 現在の権限と，セレクタボックスで選択された権限
		   が違う時，サーバに更新を送信する．
		 */
		if(member.authority != member.selectedValue()){
		    // オーナーを選択された時は確認ダイアログを出す
		    if(member.selectedValue() == "owner"){
			var alert_text = 'オーナー権限は一人しか持てません\n'+
			    'オーナー権限を移譲すると自分はマネージャー権限になり，'+
			    '権限の管理ページへはアクセス出来なくなります．\n'+
			    '本当にオーナー権限を移譲しますか？';
			if(window.confirm(alert_text)){
			    member.update(member.selectedValue());
			}else{
			    // セレクタの選択を元に戻す
			    member.selectedValue(member.authority);
			}
		    }else{
			member.update(member.selectedValue());
		    }
		}
	    });
	}
	// 新しい権限の情報をサーバに送信して更新する
	Member.prototype.update = function(authority){
	    var member = this;
	    $.ajax({
		type: "PATCH",
		url: "/admin/member/authority",
		data:{
		    "user":{
			"user_id": member.id,
			"authority": authority
		    }
		},
		success:function(data){
		    var user = data.user;
		    if (user.authority == "reject"){
			self.members.remove(function(item){
			    return item.id == user.user_id;
			});
		    }else{
			member.authority = user.authority;
			member.selectedValue(user.authority);
		    }
		},
		error:function(data){
		    // 選択を元の権限に戻す
		    member.selectedValue(self.authority);
		}
	    });
	};
	// メンバーをリストに追加する
	// (Viewのインラインスクリプトから呼ばれる)
	// id,name,authoriy,image: メンバーの情報
	self.pushMember = function(id,name,authority,image){
	    self.members.push(new Member(id,name,authority,image));
	};

	self.members = ko.observableArray();
    }
    root_vm["members_vm"] = new MembersViewModel();
})();
