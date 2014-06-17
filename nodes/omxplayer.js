var exec = require('child_process').execFile;

module.exports = function(RED) {
  function OmxPlayer(n) {
    RED.nodes.createNode(this,n);

    var node = this;
    this.on("input", function(msg) {
      if (msg != null) {
        var cl = "/usr/bin/omxplayer " + msg.payload;
        node.log(cl);
        var child = exec(cl, function (error, stdout, stderr) {
          if (error) {
            error.stderr = stderr;
            node.send([null, {payload: error}]);
          }
          node.send([{payload: stdout}, null]);
        });
      }
    });
  }

  RED.nodes.registerType("omxplayer", OmxPlayer);
}
