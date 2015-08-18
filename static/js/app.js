require(["jquery", "underscore"], function($, _) {
  "use strict";
  var update = function(d) {
    $(function() {
      $("#msgs").text(d.join("\n"));
    });
  };
  (function upoll(u) {
    $.ajax(u).success(function(d) {
      update(d);
      upoll(u);
    });
  }("/await"));
  $.ajax("/recv").success(update);
  $(function() {
    $("#send").on("submit", function(evt) {
      var self = this;
      var $self = $(self);
      var $msg = $self.find("[name=msg]");
      evt.preventDefault();
      $.ajax({
        url: "/send",
        method: "POST",
        data: {"msg": $msg.val()}
      }).success(function() {
        $msg.val("");
        $.ajax("/recv").success(update);
      });
    });
  });
});
