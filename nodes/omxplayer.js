var exec = require('child_process').exec;

module.exports = function(RED) {
  function OmxPlayer(n) {
      RED.nodes.createNode(this,n);

      var node = this;
      this.on("input", function(msg) {
          if (msg != null) {
              var cl = node.cmd+" "+msg.payload+" "+node.append;
              node.log(cl);
              var child = exec(cl, function (error, stdout, stderr) {
                  msg.payload = stdout;
                  var msg2 = {payload:stderr};
                  if (error !== null) {
                      var msg3 = {payload:error};
                  }
                  node.send([msg,msg2,msg3]);
              });
          }
      });
  }

  RED.nodes.registerType("omxplayer", OmxPlayer);
}
