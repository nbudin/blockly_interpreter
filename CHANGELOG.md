## Version 0.3.0 - October 18, 2017

* Rename 'blockly_interpreter/test_helper' to 'blockly_interpreter/blockly_interpreter_test_helper' to avoid potential naming conflicts with apps that have a test_helper and put blockly_interpreter in the load path (thanks, @stuartmg!)

## Version 0.2.1 - August 31, 2017

* Rails 5 compatibility fix (thanks, @mdeutsch!)

## Version 0.2.0 - August 16, 2016

* Initial public release.
* Add `to_xml` and `to_xml_document` methods to `BlocklyInterpreter::Program`, and `to_xml_element` to `BlocklyInterpreter::Block`.

## Version 0.1.1 - June 20, 2016

* Expose the helper classes from test_helper to the outside world (although not by default) so that code depending on this gem can use them

## Version 0.1.0 - June 8, 2016

* Initial internal release.
