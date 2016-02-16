module BlocklyInterpreter::ExtensionBlocks
  extend ActiveSupport::Autoload
  extend BlocklyInterpreter::BlockLibrary

  autoload :DateHashBlock
  autoload :DateTodayBlock
  autoload :DebugMessageBlock
  autoload :ListsAppendBlock
  autoload :ListsConcatBlock
  autoload :ListsIncludeOperatorBlock
  autoload :ObjectPresentBlock
  autoload :SwitchBlock
  autoload :TextInflectBlock

  self.block_classes = [
    DateTodayBlock,
    DebugMessageBlock,
    ListsAppendBlock,
    ListsConcatBlock,
    ListsIncludeOperatorBlock,
    ObjectPresentBlock,
    SwitchBlock,
    TextInflectBlock
  ]
end
