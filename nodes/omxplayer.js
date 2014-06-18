var exec = require('child_process').exec;

module.exports = function(RED) {
  var child;

  function OmxPlayer(n) {
    RED.nodes.createNode(this,n);

    var node = this;
    this.on("input", function(msg) {
      if (!msg) { return; }

      if (child) { child.kill('SIGINT'); }

      var cl = "/usr/bin/omxplayer " + msg.payload;
      node.log(cl);

      child = exec(cl, function (error, stdout, stderr) {
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
