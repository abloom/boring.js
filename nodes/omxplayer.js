var exec = require('child_process').exec;

module.exports = function(RED) {
  var child;

  function OmxPlayer(n) {
    RED.nodes.createNode(this, n);

    var node = this;
    this.on("input", function(msg) {
      if (!msg) { return; }

      if (child) { child.stdin.write("q"); }

      var cmd = "/usr/bin/omxplayer " + msg.payload;
      node.log(cmd);

      child = exec(cmd, function (error, stdout, stderr) {
        child = undefined;

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
