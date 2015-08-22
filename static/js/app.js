require(["jquery", "underscore"], function($, _) {
  "use strict";
  var messages = [];
  var room = function() {
    return "/" + $("#msgs-room").val();
  };
  var rescroll = function() {
    var $msgs = $("#msgs-scroll");
    $msgs.scrollTop($msgs.children().height());
  };
  var update = function(d) {
    messages = messages.concat(d.reverse());
    $(function() {
      $("#msgs").text(_.map(messages, function(l) {
        return l.join(": ");
      }).join("\n"));
    });
  };
  $(function() {
    (function upoll(u) {
      $.ajax(u).success(function(d) {
        update(d);
        rescroll();
        upoll(u);
      });
    }(room() + "/await"));
    $.ajax(room() + "/recv").success(function(d) {
      update(d);
      rescroll();
    });
    $("form#send").on("submit", function(evt) {
      evt.preventDefault();
      var self = this;
      var $self = $(self);
      var $msg = $self.find("[name=msg]");
      var $user = $self.find("[name=user]");
      $.ajax({
        url: room() + "/send",
        method: "POST",
        data: {msg: $msg.val(), user: $user.val()}
      }).success(function() {
        $msg.val("");
        rescroll();
      });
    });
  });
});
