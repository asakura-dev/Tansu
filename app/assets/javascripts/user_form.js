(function(){
    function UserFormViewModel(){
	var self = this;
	self.icon_exist = ko.observable(false);
	self.deleteIcon = function(){
	    console.log("ajax Patch");
	    $.ajax({
		url: "/users_icon/",
		method: "DELETE",
		data: {},
		success: function(data){
		    if(data["status"] == "success"){
			self.icon_exist(false);
		    }
		},
		error:function(){
		}
	    });
	}
    }
    root_vm["user_form_vm"] = new UserFormViewModel();
})();
$(function(){
    var cropper = $.imageCropper.new(".crop-container",{
	canvas: {
	    width: "500px",
	    height: "300px",
	},
	crop: {
	    width: "200px",
	    height: "200px"
	}
    });
    cropper.attach({
	load: "#loadFile",
	rotateRight: "#rotateRight",
	rotateLeft: "#rotateLeft",
	zoom: "#zoom",
	output: "#user_base64_image"
    });
});
