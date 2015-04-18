(function(){
    function ProductEditFormViewModel(){
	var self = this;
	self.image_exist = ko.observable(false);
	self.delete_image = function(){
	    // :idを取得したい
	    var id = location.href.split("/")[5];
	    $.ajax({
		url: "/admin/products/"+id+"/image",
		method: "DELETE",
		data: {},
		success: function(data){
		    if(data["status"] == "success"){
			self.image_exist(false);
		    }
		},
		error:function(){
		}
	    });
	}
    }
    root_vm["product_edit_form_vm"] = new ProductEditFormViewModel();
})();
$(function(){
    cropper = $.imageCropper.new(".crop-container",{
	canvas: {
	    width: "300px",
	    height: "230px",
	},
	crop: {
	    width: "165px",
	    height: "225px"
	}
    });
    cropper.attach({
	load: "#loadFile",
	rotateRight: "#rotateRight",
	rotateLeft: "#rotateLeft",
	zoom: "#zoom",
	output: "#product_base64_image"
    });

});
