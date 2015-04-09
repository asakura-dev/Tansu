(function(){
    function DropDownViewModel(){
	var self = this;
	self.actived = ko.observable(false);
	self.toggle = function(){
	    self.actived(!self.actived());
	};
	$(document).on("click",function(){
	    if(self.actived() == true){
		self.actived(false);
	    }
	});
    }
    root_vm["dropdown"] = new DropDownViewModel();
})();
