var cropper;
(function(){
    function ProductFormViewModel(){
	var self = this;
	function Product(name,description,image_url,url){
	    this.name = name;
	    this.short_name = (this.name).substring(0,20);
	    this.description = description;
	    this.image_url = image_url;
	    this.url = url;
	}
	Product.prototype.select = function(){
	    var p = this;
	    self.product.name(p.name);
	    self.product.description(p.description);
	    self.product.image_url(p.image_url);
	    self.product.url(p.url);
	}

	// モードの種類
	// manual,barcode,product_search
	self.mode = ko.observable("manual");

	self.load = function(){
	    if(self.product.image_url()){
		cropper.load('/third/image?url=' + encodeURIComponent(self.product.image_url()));
	    }
	}
	// モードのタブが押された時呼び出される
	self.selectMode = function(){
	    // 押されたタブからモードを取得
	    var mode = $(event.target).attr("href").replace("#","");
	    self.mode(mode);
	    // クッキーに保存して，次回訪問時も前回選択したモードが選択されるようにする
	    Cookies.set('product_form_mode',mode);
	    // モード変更時は，フォームの中身を一時消去する
	};
	// フォーム要素のオブジェクト
	self.product = {
	    name: ko.observable(""),
	    description: ko.observable(""),
	    image_url: ko.observable(""),
	    url: ko.observable("")
	};
	self.loading = ko.observable(false);
	self.barcode_input = ko.observable("");
	self.barcode_search = function(){
	    // ajax search
	    self.loading(true);
	    self.search_results.removeAll();
	    $.ajax({
		type: "GET",
		url: "/third/product_search",
		data:{
		    type: "isbn",
		    value: self.barcode_input()
		},
		success:function(data){
		    self.loading(false);
		    for(var i = 0 ,length = data.length-1; i < length; i++){
			var p = data[i];
			var image = "";
			if(p.image){
			    if(p.image.Large){
				image = p.image.Large;
			    }else if(p.image.Medium){
				image = p.image.Medium;
			    }else if(p.image.Small){
				image = p.image.Small;
			    }
			}
			self.search_results.push(new Product(p.name,p.description,image));
		    }
		},
		error:function(data){
		    self.loading(false);
		}
	    });
	};
	self.product_input = ko.observable("");
	self.product_search = function(){
	    // ajax search
	    self.loading(true);
	    self.search_results.removeAll();
	    $.ajax({
		type: "GET",
		url: "/third/product_search",
		data:{
		    type: "query",
		    value: self.product_input()
		},
		success:function(data){
		    self.loading(false);
		    for(var i = 0 ,length = data.length-1; i < length; i++){
			var p = data[i];
			var image = "";
			if(p.image){
			    if(p.image.Large){
				image = p.image.Large;
			    }else if(p.image.Medium){
				image = p.image.Medium;
			    }else if(p.image.Small){
				image = p.image.Small;
			    }
			}
			self.search_results.push(new Product(p.name,p.description,image,p.url));
		    }
		},
		error:function(data){
		    self.loading(false);
		}
	    });
	};
	// Enterで検索
	self.search = function(d,e){
		// enterキーを拾う
		if (e.keyCode === 13) {
			switch (self.mode()) {
			case 'product_search':
				self.product_search();
				break;
			case 'barcode':
				self.barcode_search();
				break;
			}
			return false;
		}
		return true;
	};


	// 検索して取得した商品の情報を格納する配列
	self.search_results = ko.observableArray();
	self.setForm = function(product_object){
	    self.product.title(product_object.title);
	    self.product.description(product_object.description);
	}
    }
    root_vm["product_form_vm"] = new ProductFormViewModel();
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


    // 前回選択したモードのタブが選択されるようにする．
    if(Cookies.get('product_form_mode')){
	root_vm["product_form_vm"].mode(Cookies.get('product_form_mode'));
    }
});
