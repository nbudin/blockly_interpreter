'use strict';

goog.provide('BlocklyInterpreter.ExtensionBlocks.lists');
goog.require('Blockly.Blocks');

Blockly.Blocks["lists_include"] = {
  init: function() {
    this.appendValueInput("A")
      .setCheck("Array");
    this.appendDummyInput()
      .appendField(new Blockly.FieldDropdown([["includes", "INCLUDE"], ["does not include", "NINCLUDE"]]), "OP");
    this.appendValueInput("B");
    this.setInputsInline(true);
    this.setOutput(true, "Boolean");
    this.setColour(Blockly.Blocks.lists.HUE);
    this.setTooltip('Checks a list to see if a particular value is part of it or not');
  }
};

Blockly.Blocks['lists_append'] = {
  init: function() {
    this.appendValueInput("VALUE")
      .setAlign(Blockly.ALIGN_RIGHT)
      .appendField("append value");
    this.appendValueInput("LIST")
      .setCheck("Array")
      .setAlign(Blockly.ALIGN_RIGHT)
      .appendField("to list");
    this.setPreviousStatement(true);
    this.setNextStatement(true);
    this.setColour(Blockly.Blocks.lists.HUE);
  }
};

Blockly.Blocks['lists_concat'] = {
  init: function() {
    this.appendValueInput("LIST1")
      .setCheck("Array")
      .appendField("list by combining lists");
    this.appendValueInput("LIST2")
      .setCheck("Array");
    this.setOutput(true);
    this.setColour(Blockly.Blocks.lists.HUE);
  }
};