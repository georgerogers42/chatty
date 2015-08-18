require(["jquery", "underscore"], function($, _) {
  "use strict";
  var update = function(d) {
    $(function() {
      $("#msgs").text(_.map(d.reverse(), function(l) {
        return l.join(": ");
      }).join("\n"));
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
      var $user = $self.find("[name=user]");
      evt.preventDefault();
      $.ajax({
        url: "/send",
        method: "POST",
        data: {msg: $msg.val(), user: $user.val()}
      }).success(function() {
        $msg.val("");
        $.ajax("/recv").success(update);
      });
    });
  });
});