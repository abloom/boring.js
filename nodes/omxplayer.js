var exec = require('child_process').exec;

module.exports = function(RED) {
  function OmxPlayer(n) {
    RED.nodes.createNode(this,n);

    var node = this;
    this.on("input", function(msg) {
      if (!msg) { return; }

      if (node.context.child) {
        node.context.child.kill();
      }

      var cl = "/usr/bin/omxplayer " + msg.payload;
      node.log(cl);

      node.context.child = exec(cl, function (error, stdout, stderr) {
        if (error) {
          error.stderr = stderr;
          node.send([{payload: stdout}, {payload: error}]);
        }
        node.send([{payload: stdout}, null]);
      });
    });
  }

  RED.nodes.registerType("omxplayer", OmxPlayer);
}
