(function(){
    function DropDownViewModel(){
	var self = this;
	self.actived = ko.observable(false);
	self.toggle = function(){
	    self.actived(!self.actived());
	};
    }
    root_vm["dropdown"] = new DropDownViewModel();
})();
