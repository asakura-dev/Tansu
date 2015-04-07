(function(){
    function MembersViewModel(){
	var self = this;
	function Member(id,name,authority){
	    var member = this;
	    this.id = id;
	    this.name = name;
	    this.authority = authority;
	    this.authorities = [
		{name: "オーナー", value: "owner"},
		{name: "マネージャー", value: "manager"},
		{name: "一般ユーザー", value: "member"}
	    ];
	    this.selectedValue = ko.observable(this.authority);
	    // セレクタが変更された時に実行される
	    this.optionChanged = ko.computed(function(){
		/* 現在の権限と，セレクタボックスで選択された権限
		   が違う時，サーバに更新を送信する．
		 */
		if(member.authority != member.selectedValue()){
		    if(member.selectedValue() == "owner"){
			if(window.confirm('オーナー権限は一人しか持てません\nオーナー権限を移譲すると自分はマネージャー権限になり，権限の管理ページへはアクセス出来なくなります．\n本当にオーナー権限を移譲しますか？')){
			    member.update(member.selectedValue());
			}
			else{
			    member.selectedValue(member.authority);
			}
		    }else{
			member.update(member.selectedValue());
		    }
		}
	    });
	}
	Member.prototype.update = function(authority){
	    var self = this;
	    $.ajax({
		type: "PATCH",
		url: "/admin/member/authority",
		data:{
		    "user":{
			"user_id": self.id,
			"authority": authority
		    }
		},
		success:function(data){
		    var user = data.user;
		    self.authority = user.authority;
		    self.selectedValue(user.authority);
		},
		error:function(data){
		    // 選択を元に戻す
		    self.selectedValue(self.authority);
		}
	    });
	};
	self.pushMember = function(id,name,authority){
	    self.members.push(new Member(id,name,authority));
	};
	
	self.members = ko.observableArray();
    }
    root_vm["members_vm"] = new MembersViewModel();
})();
