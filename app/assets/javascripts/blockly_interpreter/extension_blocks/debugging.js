'use strict';

goog.provide('BlocklyInterpreter.ExtensionBlocks.debugging');
goog.require('Blockly.Blocks');

BlocklyInterpreter.ExtensionBlocks.debugging.HUE = 310;

Blockly.Blocks["debug_message"] = {
  init: function() {
    this.appendValueInput("MESSAGE")
      .appendField("log debugging message");
    this.setInputsInline(true);
    this.setPreviousStatement(true);
    this.setNextStatement(true);
    this.setColour(BlocklyInterpreter.ExtensionBlocks.debugging.HUE);
  }
};