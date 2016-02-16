'use strict';

goog.provide('BlocklyInterpreter.ExtensionBlocks.dates');
goog.require('Blockly.Blocks');

BlocklyInterpreter.ExtensionBlocks.dates.HUE = 280;

Blockly.Blocks['date_today'] = {
  init: function() {
    this.appendDummyInput()
      .setAlign(Blockly.ALIGN_RIGHT)
      .appendField('today');
    this.setOutput(true, "Date");
    this.setColour(BlocklyInterpreter.ExtensionBlocks.dates.HUE);
  }
};