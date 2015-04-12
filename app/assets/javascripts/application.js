// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require image-cropper
//= require knockout

// Knockout.jsの拡張
ko.bindingHandlers.stopBubble = {
  init: function(element) {
    ko.utils.registerEventHandler(element, "click", function(event) {
         event.cancelBubble = true;
         if (event.stopPropagation) {
            event.stopPropagation(); 
         }
    });
  }
};

// root_vmにknockout.jsのView Modelを追加していく
// 一番最後に読み込まれるko_bind.jsで追加されたView ModelをViewに紐つける
var root_vm = {};

// .alert-noticeクラスのアラートメッセージは時間経過で消す
$(function(){
    $(".alert-notice").hide().delay(250).slideDown().delay(2500).slideUp(function() {
	$(elem).remove();
    });
});
