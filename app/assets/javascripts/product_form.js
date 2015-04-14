(function(){
    function ProductFormViewModel(){
	var self = this;
	// manual,barcode,product_search	
	self.mode = ko.observable("manual");
	self.selectMode = function(){
	    var mode = $(event.target).attr("href").replace("#","");
	    self.mode(mode);
	    Cookies.set('mode',mode);
	};
	self.product = {
	    title: ko.observable(""),
	    description: ko.observable(""),
	};
	self.barcode_input = ko.observable("");
	self.barcode_search = function(){
	    // ajax search
	};	
	self.product_input = ko.observable("");
	self.product_search = function(){
	    // ajax search
	};
	// 検索して取得した商品を格納する配列
	self.search_results = ko.observableArray([""]);
	self.resetForm = function(){
	    self.product.title("");
	    self.product.description("");
	};
	self.setForm = function(product_object){
	    self.product.title(product_object.title);
	    self.product.description(product_object.description)
	}
    }    
    root_vm["product_form_vm"] = new ProductFormViewModel();
})();

$(function(){
    
    var cropper = $.imageCropper.new(".crop-container",{
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
	output: "#user_base64_image"
    });

    
    // 前回選択したモードのタブが選択されるようにする．
    if(Cookies.get('mode')){
	root_vm["product_form_vm"].mode(Cookies.get('mode'));
    }
});
