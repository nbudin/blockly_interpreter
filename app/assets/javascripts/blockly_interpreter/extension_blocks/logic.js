'use strict';

goog.provide('BlocklyInterpreter.ExtensionBlocks.logic');
goog.require('Blockly.Blocks');

Blockly.Blocks["object_present"] = {
  init: function() {
    this.appendValueInput("VALUE");
    this.appendDummyInput()
      .appendField("is present");
    this.setInputsInline(true);
    this.setOutput(true);
    this.setColour(Blockly.Blocks.logic.HUE);
  }
};

Blockly.Blocks['controls_switch'] = {
  /**
   * Block for if/elseif/else condition.
   * @this Blockly.Block
   */
  init: function() {
    this.setColour(Blockly.Blocks.logic.HUE);
    this.appendValueInput('SWITCH_VAL')
      .setAlign(Blockly.ALIGN_RIGHT)
      .appendField("when");
    this.setInputsInline(false);
    this.setPreviousStatement(true);
    this.setNextStatement(true);
    this.setMutator(new Blockly.Mutator(['controls_switch_case',
                                         'controls_switch_else']));
    // Assign 'this' to a variable for use in the tooltip closure below.
    var thisBlock = this;
    this.caseCount_ = 0;
    this.elseCount_ = 0;
    this.captureCount_ = 0;
  },
  /**
   * Create XML to represent the number of else-if and else inputs.
   * @return {Element} XML storage element.
   * @this Blockly.Block
   */
  mutationToDom: function() {
    if (!this.caseCount_ && !this.elseCount_) {
      return null;
    }
    var container = document.createElement('mutation');
    if (this.caseCount_) {
      container.setAttribute('case', this.caseCount_);
    }
    if (this.elseCount_) {
      container.setAttribute('else', 1);
    }
    if (this.captureCount_) {
      container.setAttribute('capture', 1);
    }
    return container;
  },
  /**
   * Parse XML to restore the else-if and else inputs.
   * @param {!Element} xmlElement XML storage element.
   * @this Blockly.Block
   */
  domToMutation: function(xmlElement) {
    this.caseCount_ = parseInt(xmlElement.getAttribute('case'), 10) || 0;
    this.elseCount_ = parseInt(xmlElement.getAttribute('else'), 10) || 0;
    this.captureCount_ = parseInt(xmlElement.getAttribute('capture'), 10) || 0;
    if (this.captureCount_) {
      this.appendDummyInput("CAPTURE_DUMMY")
        .setAlign(Blockly.ALIGN_RIGHT)
        .appendField("which we call")
        .appendField(new Blockly.FieldVariable("captured_value"), "CAPTURE_VAR");
    }
    for (var i = 0; i < this.caseCount_; i++) {
      this.appendValueInput('CASE' + i)
        .setAlign(Blockly.ALIGN_RIGHT)
        .appendField("is equal to");
      this.appendStatementInput('DO' + i)
        .appendField("then");
    }
    if (this.elseCount_) {
      this.appendStatementInput('ELSE')
          .appendField("else");
    }
  },
  /**
   * Populate the mutator's dialog with this block's components.
   * @param {!Blockly.Workspace} workspace Mutator's workspace.
   * @return {!Blockly.Block} Root block in mutator.
   * @this Blockly.Block
   */
  decompose: function(workspace) {
    var containerBlock = Blockly.Block.obtain(workspace, 'controls_switch_switch');
    if (this.captureCount_) {
      containerBlock.setFieldValue('TRUE', 'CAPTURE');
    }
    containerBlock.initSvg();
    var connection = containerBlock.getInput('STACK').connection;
    for (var i = 0; i < this.caseCount_; i++) {
      var caseBlock = Blockly.Block.obtain(workspace, 'controls_switch_case');
      caseBlock.initSvg();
      connection.connect(caseBlock.previousConnection);
      connection = caseBlock.nextConnection;
    }
    if (this.elseCount_) {
      var elseBlock = Blockly.Block.obtain(workspace, 'controls_switch_else');
      elseBlock.initSvg();
      connection.connect(elseBlock.previousConnection);
    }
    return containerBlock;
  },
  /**
   * Reconfigure this block based on the mutator dialog's components.
   * @param {!Blockly.Block} containerBlock Root block in mutator.
   * @this Blockly.Block
   */
  compose: function(containerBlock) {
    // Disconnect the capture block and remove the input.
    if (this.captureCount_) {
      this.removeInput("CAPTURE_DUMMY");
    }
    this.captureCount_ = 0;
    // Disconnect the else input blocks and remove the inputs.
    if (this.elseCount_) {
      this.removeInput('ELSE');
    }
    this.elseCount_ = 0;
    // Disconnect all the elseif input blocks and remove the inputs.
    for (var i = 0; i < this.caseCount_; i++) {
      this.removeInput('CASE' + i);
      this.removeInput('DO' + i);
    }
    this.caseCount_ = 0;
    // Rebuild the block's optional inputs.
    if (containerBlock.getFieldValue('CAPTURE') == "TRUE") {
      this.appendDummyInput("CAPTURE_DUMMY")
        .setAlign(Blockly.ALIGN_RIGHT)
        .appendField("which we call")
        .appendField(new Blockly.FieldVariable(containerBlock.captureVar_ || "captured_value"), "CAPTURE_VAR");
        this.captureCount_++;
    }
    var clauseBlock = containerBlock.getInputTargetBlock('STACK');
    while (clauseBlock) {
      switch (clauseBlock.type) {
        case 'controls_switch_case':
          var caseInput = this.appendValueInput('CASE' + this.caseCount_)
            .setAlign(Blockly.ALIGN_RIGHT)
            .appendField("is equal to");
          var doInput = this.appendStatementInput('DO' + this.caseCount_);
          doInput.appendField("then");
          // Reconnect any child blocks.
          if (clauseBlock.valueConnection_) {
            caseInput.connection.connect(clauseBlock.valueConnection_);
          }
          if (clauseBlock.statementConnection_) {
            doInput.connection.connect(clauseBlock.statementConnection_);
          }
          this.caseCount_++;
          break;
        case 'controls_switch_else':
          var elseInput = this.appendStatementInput('ELSE');
          elseInput.appendField("else");
          // Reconnect any child blocks.
          if (clauseBlock.statementConnection_) {
            elseInput.connection.connect(clauseBlock.statementConnection_);
          }
          this.elseCount_++;
          break;
        default:
          throw 'Unknown block type.';
      }
      clauseBlock = clauseBlock.nextConnection &&
          clauseBlock.nextConnection.targetBlock();
    }
  },
  /**
   * Store pointers to any connected child blocks.
   * @param {!Blockly.Block} containerBlock Root block in mutator.
   * @this Blockly.Block
   */
  saveConnections: function(containerBlock) {
    containerBlock.captureVar_ = this.getFieldValue('CAPTURE_VAR');

    var clauseBlock = containerBlock.getInputTargetBlock('STACK');
    var i = 0;
    while (clauseBlock) {
      switch (clauseBlock.type) {
        case 'controls_switch_case':
          var inputCase = this.getInput('CASE' + i);
          var inputDo = this.getInput('DO' + i);
          clauseBlock.valueConnection_ =
              inputCase && inputCase.connection.targetConnection;
          clauseBlock.statementConnection_ =
              inputDo && inputDo.connection.targetConnection;
          i++;
          break;
        case 'controls_switch_else':
          var inputDo = this.getInput('ELSE');
          clauseBlock.statementConnection_ =
              inputDo && inputDo.connection.targetConnection;
          break;
        default:
          throw 'Unknown block type.';
      }
      clauseBlock = clauseBlock.nextConnection &&
          clauseBlock.nextConnection.targetBlock();
    }
  },

  /**
   * Notification that a variable is renaming.
   * If the name matches one of this block's variables, rename it.
   * @param {string} oldName Previous name of variable.
   * @param {string} newName Renamed variable.
   * @this Blockly.Block
   */
  renameVar: function(oldName, newName) {
    var captureVarName = this.getFieldValue('CAPTURE_VAR');

    if (captureVarName && Blockly.Names.equals(oldName, captureVarName)) {
      this.setFieldValue(newName, 'CAPTURE_VAR');
    }
  },

  getVars: function() {
    return [this.getFieldValue('CAPTURE_VAR')];
  }
};

Blockly.Blocks['controls_switch_switch'] = {
  /**
   * Mutator block for if container.
   * @this Blockly.Block
   */
  init: function() {
    this.setColour(Blockly.Blocks.logic.HUE);
    this.appendDummyInput()
      .appendField("when value");
    this.appendDummyInput()
      .appendField(new Blockly.FieldCheckbox(false), "CAPTURE")
      .appendField("capture value");
    this.appendStatementInput('STACK');
    this.contextMenu = false;
  }
};

Blockly.Blocks['controls_switch_case'] = {
  /**
   * Mutator bolck for else-if condition.
   * @this Blockly.Block
   */
  init: function() {
    this.setColour(Blockly.Blocks.logic.HUE);
    this.appendDummyInput()
        .appendField("is equal to");
    this.setPreviousStatement(true);
    this.setNextStatement(true);
    this.contextMenu = false;
  }
};

Blockly.Blocks['controls_switch_else'] = {
  /**
   * Mutator block for else condition.
   * @this Blockly.Block
   */
  init: function() {
    this.setColour(Blockly.Blocks.logic.HUE);
    this.appendDummyInput()
        .appendField("else");
    this.setPreviousStatement(true);
    this.contextMenu = false;
  }
};