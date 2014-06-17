var exec = require('child_process').exec;

module.exports = function(RED) {
  function OmxPlayer(n) {
    RED.nodes.createNode(this,n);

    var node = this;
    this.on("input", function(msg) {
      if (msg != null) {
        var cl = "/usr/bin/omxplayer "+msg.payload;
        node.log(cl);
        var child = exec(cl, function (error, stdout, stderr) {
            node.send({payload: stdout});
        });
      }
    });
  }

  RED.nodes.registerType("omxplayer", OmxPlayer);
}
