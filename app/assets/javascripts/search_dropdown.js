(function(){
    function SearchDropDownViewModel(){
	var self = this;
	// ドロップダウンメニューがアクティブかどうか
	// アクティブの時，ドロップダウンメニューが表示される
	self.actived = ko.observable(false);
	// アクティブかどうかを反転させる
	self.toggle = function(){
	    self.actived(!self.actived());
	};
	// ドロップダウンメニュー
	$(document).on("click",function(){
	    if(self.actived() == true){
		self.actived(false);
	    }
	});
    }
    root_vm["search_dropdown_vm"] = new SearchDropDownViewModel();
})();
