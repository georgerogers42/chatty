require(["jquery", "underscore"], function($, _) {
  "use strict";
  var rescroll = function() {
    $("#msgs-scroll").each(function() {
      var self = this;
      var $self = $(self);
      $self.scrollTop($self.children().height());
    });
  };
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
      rescroll();
      upoll(u);
    });
  }("/await"));
  $.ajax("/recv").success(function(d) {
    update(d);
    rescroll();
  });
  $(function() {
    $("form#send").on("submit", function(evt) {
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
        rescroll();
        $.ajax("/recv").success(update);
      });
    });
  });
});
