(function(){
    function ProductFormViewModel(){
	var self = this;
	// モードの種類
	// manual,barcode,product_search
	self.mode = ko.observable("manual");

	// モードのタブが押された時呼び出される
	self.selectMode = function(){
	    // 押されたタブからモードを取得
	    var mode = $(event.target).attr("href").replace("#","");
	    self.mode(mode);
	    // クッキーに保存して，次回訪問時も前回選択したモードが選択されるようにする
	    Cookies.set('mode',mode);
	    // モード変更時は，フォームの中身を一時消去する
	    self.resetForm();
	};
	// フォーム要素のオブジェクト
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
	// 検索して取得した商品の情報をを格納する配列
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
	output: "#product_base64_image"
    });

    
    // 前回選択したモードのタブが選択されるようにする．
    if(Cookies.get('mode')){
	root_vm["product_form_vm"].mode(Cookies.get('mode'));
    }
});
