function dd(value){
	console.log(value);
}

(function ($) {
  "use strict";
  
  // class: Cropper
  // ユーザは，Cropperクラスのインスタンスを生成し，
  // インスタンスのメソッドを用いて，画像の回転や拡大率などを操作する
  //// constructor
  var Cropper = function($container){
    var self = this;
    // キャンバス群を内包するコンテナ要素
    this.$container = $container;
    // 画像を描画するキャンバス要素
    this.$canvas = $container.children(".ic_canvas");
    // 切り抜き範囲を指し示すための半透明フレームを描画するキャンバス要素
    this.$cover_canvas = $container.children(".ic_cover_canvas");
    // 切り抜いた画像を描画するキャンバス要素
    this.$crop_canvas = $container.children(".ic_crop_canvas");
    // それぞれのコンテキスト
    this.ctx = this.getExtendedCanvasContext(this.$canvas);
    this.cover_ctx = this.getExtendedCanvasContext(this.$cover_canvas);
    this.crop_ctx = this.getExtendedCanvasContext(this.$crop_canvas);
    this.$output = undefined;
    (function(){
      self.cover_ctx.fillStyle = "rgba(250,250,250,0.8)";
      self.cover_ctx.fillRect(0,0,self.cover_ctx.width,self.cover_ctx.height);
      self.cover_ctx.strokeStyle = "#555555";
      var x = (self.cover_ctx.width - self.crop_ctx.width) / 2;
      var y = (self.cover_ctx.height - self.crop_ctx.height) / 2;
      self.cover_ctx.clearRect(x,y,self.crop_ctx.width, self.crop_ctx.height);
      self.cover_ctx.strokeRect(x,y,self.crop_ctx.width, self.crop_ctx.height);
    })();
    

    // imageはImageクラスのインスタンス
    // 以下のプロパティを追加する
    // image.base_width
    // image.base_height
    // image.draw_width
    // image.draw_heihgt
    // image.draw_x
    // image.draw_y
    this.image = null;
    this.angle = 0;
    $(".ic_cover_canvas").on("mousedown",function(e){
        this.touched = true;
        this.pageX = e.pageX;
        this.pageY = e.pageY;
    });
    $(".ic_cover_canvas").on("mouseup",function(e){
        self.updateCroppedImage();
        self.setCroppedImageToElem();
        this.touched = false;
    });
    $(".ic_cover_canvas").on("mousemove",function(e){
        if(this.touched == true){
          var x = e.pageX - this.pageX;
          var y = e.pageY - this.pageY;
          this.pageX = e.pageX;
          this.pageY = e.pageY;
          if(self.isImageExist()){
            self.image.draw_x += x;
            self.image.draw_y += y;
            self.ctx.drawImageWithAngle(self.image,self.image.draw_x,self.image.draw_y,self.image.draw_width,self.image.draw_height,self.angle);
            self.updateCroppedImage();
          }
        }
    });
  };
  //// methods of Cropper
  $.extend(Cropper.prototype,{
    // 引数に与えられたキャンバス要素のコンテキストを返す
    // コンテキストは少し拡張する
    getExtendedCanvasContext: function($canvas){
	  var ctx = $canvas.get(0).getContext('2d');
      // 幅，高さをコンテキスト自体に持たせる(アクセスしやすいため)
      ctx.width = $canvas.width();
      ctx.height = $canvas.height();
      // method : 描画をリセットする
      ctx.clear = function(){
        this.clearRect(0,0,this.width,this.height);
      }
      // method : 拡張drawImageメソッド
      // 画像を角度を指定して描画する
      // xおよびyは，それぞれ，キャンバスの左上から回転後の画像の左上までの距離
      // widthおよびheightは，それぞれ回転後の画像の横幅と高さ
      ctx.drawImageWithAngle = function(image,x,y,width,height,angle){
        // キャンバス初期化
        ctx.clear();
        // スタックに追加
        ctx.save();
        // 基準点を中心にする
        ctx.translate(this.width/2,this.height/2);
        // 基準点を反時計周りにradだけ回転
        var rad = angle * (Math.PI / 180);
        ctx.rotate(rad);
        // 基準点を元のキャンバスの左上が回転後にある位置にする
        // 例：反時計周りに90度回転させると，左上の座標は左下当たりに移動する
        switch(angle){
            case 0:
              ctx.translate(-1 * (this.width / 2), -1 * (this.height / 2));
              ctx.drawImage(image,x,y,width,height);
              break;
            case 90:
              ctx.translate(-1 * (this.height / 2), this.width / 2);
              ctx.drawImage(image,y,-(x + width),height, width);
              break;
            case 180:
              ctx.translate(this.width / 2, this.height /2 );
              ctx.drawImage(image, -(x + width), -(y + height),width, height);
            break;
            case 270:
              ctx.translate(this.height /2 , -1 * this.width /2 );
              ctx.drawImage(image,-(y + height), x, height, width);
            break;
        }
        ctx.restore();
      }
        return ctx;
    },
    rotateRight: function(){
      if(this.isImageExist()){
        if(this.angle == 270){
          this.angle = 0;
        }else{
          this.angle += 90;
        }
        var size = this.getFitSize(this.angle);
        this.setSize(size);
        var pos = this.getCenterPosition(size["width"],size["height"]);
        this.setPos(pos);
        this.resetZoomInput();
        this.ctx.drawImageWithAngle(this.image,pos["x"],pos["y"],size["width"],size["height"],this.angle);
        this.updateCroppedImage();
        this.setCroppedImageToElem();
      }
    },
    rotateLeft: function(){
      if(this.isImageExist()){
        if(this.angle == 0){
          this.angle = 270;
        }else{
          this.angle -= 90;
        }
        var size = this.getFitSize(this.angle);
        this.setSize(size);
        var pos = this.getCenterPosition(size["width"],size["height"]);
        this.setPos(pos);
        this.resetZoomInput();
        this.ctx.drawImageWithAngle(this.image,pos["x"],pos["y"],size["width"],size["height"],this.angle);
        this.updateCroppedImage();
        this.setCroppedImageToElem();
      }
    },
    zoom: function(zoom_ratio){
      if(this.isImageExist()){
        zoom_ratio = 1 + zoom_ratio;
        var new_width = this.image.base_width * zoom_ratio;
        var new_height = this.image.base_height * zoom_ratio;
        this.image.draw_x += (this.image.draw_width - new_width) / 2;
        this.image.draw_y += (this.image.draw_height - new_height) / 2;
        this.image.draw_width = new_width;
        this.image.draw_height = new_height;
        this.ctx.drawImageWithAngle(this.image,this.image.draw_x,this.image.draw_y,new_width,new_height,this.angle);
        this.updateCroppedImage();
      }
    },
    resetZoomInput: function(){
      if(!this.$zoom){ console.log('input[type="range"]がない'); return; }
      this.$zoom.val((this.$zoom.attr("min")+this.$zoom.attr("max")) / 2);
    },
    isImageExist: function(){
      if(this.image){
        return true;
      }else{
        return false;
      }
    },
    
    // canvasの比と比較して，canvasに収まる最大の画像サイズを取得
    // widthとheightは回転後の画像の横幅と高さ
    getFitSize: function(angle){
      var width,height;
      var canvas_ratio = this.ctx.width / this.ctx.height;
      var image_ratio = this.image.width / this.image.height;
      if (angle == 90 || angle == 270){
        image_ratio = 1 / image_ratio;
      }
      if(image_ratio > canvas_ratio){
        width = this.ctx.width;
        height = width / image_ratio;
      }else{
        height = this.ctx.height;
        width = height * image_ratio;
      }
      return {width: width, height: height};
    },
    setSize: function(size){
      this.image.draw_width = size["width"];
      this.image.draw_height = size["height"];
      this.image.draw_height = size["height"];
      this.image.base_width = size["width"] / 2;
      this.image.base_height = size["height"] / 2;
    },
    getCenterPosition: function(width,height){
      var x,y;
      x = (this.ctx.width - width) / 2;
      y = (this.ctx.height - height) / 2;
      return {x : x, y : y};
    },
    setPos: function(pos){
      this.image.draw_x = pos["x"];
      this.image.draw_y = pos["y"];
    },
    updateCroppedImage: function(){
      var cropper = this;
      var x = cropper.image.draw_x - (cropper.ctx.width - cropper.crop_ctx.width) / 2;
      var y = cropper.image.draw_y - (cropper.ctx.height - cropper.crop_ctx.height) / 2;
      cropper.crop_ctx.drawImageWithAngle(cropper.image,x,y,cropper.image.draw_width,cropper.image.draw_height,cropper.angle);
    },
    setCroppedImageToElem:function(){
      var cropper = this;
      if(cropper.$output){
        if(cropper.$output.prop("tagName") == 'A'){
          cropper.$output.attr("href",cropper.$crop_canvas.get(0).toDataURL("image/png"));
        }else{
          cropper.$output.val(cropper.$crop_canvas.get(0).toDataURL("image/png"));
        }
      }
    },
    // 特定の要素に，特定の動作(イベント)を紐つける
    // 引数2つの場合
    // target_element : 紐つける要素
    // role : 紐つけるイベント
    // 引数1つの場合 
    // target_elementとroleが対になった連想配列
    // roleの種類
    // - load : input[type="file"]の要素と紐付けて画像を読み込めるようにする
    // - rotateRight : 要素と紐付けて，右回転するようにする
    // - rotateLeft  : 要素と紐付けて，左回転するようにする
    attach: function(role, target_element){
      var cropper = this;
      
      // 連想配列が渡された時
      // Example : cropper.attach({load: ".hoge", rotateRight: "#huga"})
      if (arguments.length == 1 && typeof role == "object"){
        var roles = role;
        for(role in roles){
          this.attach(role, roles[role]);
        }
        return;
      } 
      
      if(arguments.length != 2){
        console.log("Error on $.imageCropper.attach() : Wrong number of arguments.");
        return;
      }
      if(!$(target_element)){
        console.log("Error on $("+target_element+"): It isn't exist.");
      }
      switch (role){
        case "load":
          $(target_element).on("change",function(){
            var file = this.files[0];
            if (!file) return;
            if (!file.type.match(/^image\/(png|jpg|jpeg|gif)$/)) return;
            var image = new Image();
            var reader = new FileReader();
            reader.onload = function(evt){
              image.onload = function (){
                cropper.image = image;
                var size = cropper.getFitSize(cropper.angle);
                cropper.setSize(size);
                var pos = cropper.getCenterPosition(size["width"],size["height"]);
                cropper.setPos(pos);
                cropper.ctx.drawImageWithAngle(image,pos["x"],pos["y"],size["width"],size["height"],cropper.angle);
                cropper.updateCroppedImage();
                cropper.setCroppedImageToElem();
              };
              // evt.target.resultにはbase64エンコーディングされた画像が入っている
              image.src = evt.target.result;
            }
            reader.readAsDataURL(file);
          });
          break;
        case "rotateRight":
          $(target_element).on("click",function(){
            cropper.rotateRight();
          });
          break;
        case "rotateLeft":
          $(target_element).on("click",function(){
            cropper.rotateLeft();
          });
          break;
        case "zoom":
          (function(){
            cropper.$zoom = $(target_element);
            var min = $(target_element).attr("min");
            if(min == undefined){
              min = 0;
              $(target_element).attr("min", min);
            }
            var max = $(target_element).attr("max");
            if(max == undefined){
              max = 50;
              $(target_element).attr("max", max);
            }
            var middle = (min + max) / 2;
            $(target_element).on("input change",function(){
              var value = $(this).val();
              var zoom_ratio = (value / middle);
              cropper.zoom(zoom_ratio);
            });
            $(target_element).change(function(){
              cropper.setCroppedImageToElem();
            });
          })();
          case "output":
            cropper.$output = $(target_element);
            break;
      }
    }
  });
  
  // class: ImageCropper
  // jQueryプラグイン用のクラス
  // $.imageCropperでインスタンスにアクセスできるようにする
  //// constructor
  var ImageCropper = function () {
    //propaties
    // these will be changed by option argumetns of init
  };
  //// methods of ImageCropper
  $.extend(ImageCropper.prototype, {
    // 引数に渡した要素内にCanvas要素とかを追加して
    // 画像操作用のインスタンスを返す
    new: function (target_element, options) {
      // default configuration values
      var config = {
        canvas: {
          width: "500px",
          height: "300px"
        },
        crop: {
          width: "300px",
          height: "280px"
        }
      };
      // apply option values
      if (options) {
        config.canvas = options.canvas || config.canvas;
        config.crop = options.crop || config.crop;
      }
      if (!$(target_element)) {
        return;
      } 
      var $container = $(target_element).eq(0);
      $container.append('<canvas class="ic_canvas"'+
                      'width="'+config.canvas.width+'"height="'+config.canvas.height+'">'+
                      '</canvas>'+
                      '<canvas class="ic_cover_canvas"'+
                      'width="'+config.canvas.width+'"height="'+config.canvas.height+'">'+
                      '</canvas>'+
                      '<canvas class="ic_crop_canvas"'+
                      'width="'+config.crop.width+'" height="'+config.crop.height+'">'+
                      '</canvas>');
      $container.css({
        width: config.canvas.width,
        height: config.canvas.height
      });
      return new Cropper($container);
    }
  });
  //// $.imageCropperを追加
  $.extend({
    imageCropper: new ImageCropper()
  });
})(jQuery);