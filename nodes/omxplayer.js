module.exports = function(RED) {
  var omx = RED.settings.functionGlobalContext.omx;

  function OmxPlayer(n) {
    RED.nodes.createNode(this, n);

    var node = this;
    this.on("input", function(msg) {
      if (!msg) { return; }

      if (omx.isLoaded()) { omx.stop(); }

      omx.play(msg.payload);
    });
  }

  RED.nodes.registerType("omxplayer", OmxPlayer);
}
