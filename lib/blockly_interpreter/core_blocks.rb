module BlocklyInterpreter::CoreBlocks
  extend ActiveSupport::Autoload
  extend BlocklyInterpreter::BlockLibrary

  autoload :ArithmeticOperatorBlock
  autoload :BooleanBlock
  autoload :ComparisonOperatorBlock
  autoload :ForBlock
  autoload :ForEachBlock
  autoload :GetVariableBlock
  autoload :IfBlock
  autoload :ListsCreateEmptyBlock
  autoload :ListsCreateWithBlock
  autoload :ListsGetIndexBlock
  autoload :LogicalOperatorBlock
  autoload :NumberBlock
  autoload :ProcedureBlock
  autoload :ProceduresCallNoReturnBlock
  autoload :ProceduresCallReturnBlock
  autoload :ProceduresDefNoReturnBlock
  autoload :ProceduresDefReturnBlock
  autoload :ProceduresIfReturnBlock
  autoload :RepeatTimesBlock
  autoload :SetVariableBlock
  autoload :TextBlock
  autoload :TextChangeCaseBlock
  autoload :TextJoinBlock

  self.block_classes = [
    ArithmeticOperatorBlock,
    BooleanBlock,
    ComparisonOperatorBlock,
    ForBlock,
    ForEachBlock,
    GetVariableBlock,
    IfBlock,
    ListsCreateEmptyBlock,
    ListsCreateWithBlock,
    ListsGetIndexBlock,
    LogicalOperatorBlock,
    NumberBlock,
    ProceduresCallNoReturnBlock,
    ProceduresCallReturnBlock,
    ProceduresDefNoReturnBlock,
    ProceduresDefReturnBlock,
    ProceduresIfReturnBlock,
    RepeatTimesBlock,
    SetVariableBlock,
    TextBlock,
    TextChangeCaseBlock,
    TextJoinBlock
  ]
end
