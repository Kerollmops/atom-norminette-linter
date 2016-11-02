{CompositeDisposable} = require "atom"
sprintf = require('sprintf-js').sprintf
path = require 'path'
fs = require 'fs'

module.exports = NorminetteLinter =
  config:
    executablePath:
      type: 'string'
      default: 'norminette'
      description: 'The executable path to the 42 norminette binary.'
    checkedExtensions:
      type: 'array'
      default: ['.c', '.h']
      items:
        type: 'string'
      description: 'Extensions that the linter will check.'
    rules_CheckInclude:
      type: 'boolean'
      title: 'CheckInclude'
      default: false
    rules_CheckTypePrefixName:
      type: 'boolean'
      title: 'CheckTypePrefixName'
      default: false
    rules_CheckOneInstructionPerLine:
      type: 'boolean'
      title: 'CheckOneInstructionPerLine'
      default: false
    rules_CheckTernaryOperator:
      type: 'boolean'
      title: 'CheckTernaryOperator'
      default: false
    rules_CheckPreprocessorIndentation:
      type: 'boolean'
      title: 'CheckPreprocessorIndentation'
      default: false
    rules_CheckIncludesBeforeFirstInstruction:
      type: 'boolean'
      title: 'CheckIncludesBeforeFirstInstruction'
      default: false
    rules_CheckBlock:
      type: 'boolean'
      title: 'CheckBlock'
      default: false
    rules_CheckForbiddenKeyword:
      type: 'boolean'
      title: 'CheckForbiddenKeyword'
      default: false
    rules_CheckKeywordSpacing:
      type: 'boolean'
      title: 'CheckKeywordSpacing'
      default: false
    rules_CheckAlignement:
      type: 'boolean'
      title: 'CheckAlignement'
      default: false
    rules_CheckMultipleSpaces:
      type: 'boolean'
      title: 'CheckMultipleSpaces'
      default: false
    rules_CheckNamedParameters:
      type: 'boolean'
      title: 'CheckNamedParameters'
      default: false
    rules_CheckReturnParentheses:
      type: 'boolean'
      title: 'CheckReturnParentheses'
      default: false
    rules_CheckIndentationMultiline:
      type: 'boolean'
      title: 'CheckIndentationMultiline'
      default: false
    rules_CheckCommentsFormat:
      type: 'boolean'
      title: 'CheckCommentsFormat'
      default: false
    rules_CheckIndentationInsideFunction:
      type: 'boolean'
      title: 'CheckIndentationInsideFunction'
      default: false
    rules_CheckOperatorSpacing:
      type: 'boolean'
      title: 'CheckOperatorSpacing'
      default: false
    rules_CheckForbiddenSourceHeader:
      type: 'boolean'
      title: 'CheckForbiddenSourceHeader'
      default: false
    rules_CheckMultipleEmptyLines:
      type: 'boolean'
      title: 'CheckMultipleEmptyLines'
      default: false
    rules_CheckDefine:
      type: 'boolean'
      title: 'CheckDefine'
      default: false
    rules_CheckUnaryOperator:
      type: 'boolean'
      title: 'CheckUnaryOperator'
      default: false
    rules_CheckBracketSpacing:
      type: 'boolean'
      title: 'CheckBracketSpacing'
      default: false
    rules_CheckFilename:
      type: 'boolean'
      title: 'CheckFilename'
      default: false
    rules_CheckParametersNumber:
      type: 'boolean'
      title: 'CheckParametersNumber'
      default: false
    rules_CheckControlStructure:
      type: 'boolean'
      title: 'CheckControlStructure'
      default: false
    rules_CheckMultipleAssignation:
      type: 'boolean'
      title: 'CheckMultipleAssignation'
      default: false
    rules_CheckFunctionSpacing:
      type: 'boolean'
      title: 'CheckFunctionSpacing'
      default: false
    rules_CheckFunctionNumber:
      type: 'boolean'
      title: 'CheckFunctionNumber'
      default: false
    rules_CheckNestedTernary:
      type: 'boolean'
      title: 'CheckNestedTernary'
      default: false
    rules_CheckBeginningOfLine:
      type: 'boolean'
      title: 'CheckBeginningOfLine'
      default: false
    rules_CheckDeclarationCount:
      type: 'boolean'
      title: 'CheckDeclarationCount'
      default: false
    rules_CheckNumberOfLine:
      type: 'boolean'
      title: 'CheckNumberOfLine'
      default: false
    rules_CheckCase:
      type: 'boolean'
      title: 'CheckCase'
      default: false
    rules_CheckDoubleInclusion:
      type: 'boolean'
      title: 'CheckDoubleInclusion'
      default: false
    rules_CheckTypeDeclarationSpacing:
      type: 'boolean'
      title: 'CheckTypeDeclarationSpacing'
      default: false
    rules_CheckCallSpacing:
      type: 'boolean'
      title: 'CheckCallSpacing'
      default: false
    rules_CheckDeclarationPlacement:
      type: 'boolean'
      title: 'CheckDeclarationPlacement'
      default: false
    rules_CheckSeparationChar:
      type: 'boolean'
      title: 'CheckSeparationChar'
      default: false
    rules_CheckTopCommentHeader:
      type: 'boolean'
      title: 'CheckTopCommentHeader'
      default: false
    rules_CheckElseIf:
      type: 'boolean'
      title: 'CheckElseIf'
      default: false
    rules_CheckNoArgFunction:
      type: 'boolean'
      title: 'CheckNoArgFunction'
      default: false
    rules_CheckGlobalTypePrefixName:
      type: 'boolean'
      title: 'CheckGlobalTypePrefixName'
      default: false
    rules_CheckEmptyLine:
      type: 'boolean'
      title: 'CheckEmptyLine'
      default: false
    rules_CheckVla:
      type: 'boolean'
      title: 'CheckVla'
      default: false
    rules_CheckCppComment:
      type: 'boolean'
      title: 'CheckCppComment'
      default: false
    rules_CheckSpaceBetweenFunctions:
      type: 'boolean'
      title: 'CheckSpaceBetweenFunctions'
      default: false
    rules_CheckArgumentSpacing:
      type: 'boolean'
      title: 'CheckArgumentSpacing'
      default: false
    rules_CheckEndOfLine:
      type: 'boolean'
      title: 'CheckEndOfLine'
      default: false
    rules_CheckColumnLength:
      type: 'boolean'
      title: 'CheckColumnLength'
      default: false
    rules_CheckNumberOfVariables:
      type: 'boolean'
      title: 'CheckNumberOfVariables'
      default: false
    rules_CheckComma:
      type: 'boolean'
      title: 'CheckComma'
      default: false
    rules_CheckParentSpacing:
      type: 'boolean'
      title: 'CheckParentSpacing'
      default: false
    rules_CheckCommentsPlacement:
      type: 'boolean'
      title: 'CheckCommentsPlacement'
      default: false
    rules_CheckDeclarationInstanciation:
      type: 'boolean'
      title: 'CheckDeclarationInstanciation'
      default: false
    rules_CheckIndentationOutsideFunction:
      type: 'boolean'
      title: 'CheckIndentationOutsideFunction'
      default: false

  login: null

  activate: (state) ->
    @login = process.env.USER ? null
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.config.observe 'norminette-linter.executablePath',
      (executablePath) => @executablePath = executablePath
    @subscriptions.add atom.config.observe 'norminette-linter.checkedExtensions'
    , (checkedExtensions) => @checkedExtensions = checkedExtensions

  deactivate: ->
    @subscriptions.dispose()

  headerCreator: (textBuffer) ->
    createdPat = /Created: \d{4}\/\d{2}\/\d{2} \d{2}:\d{2}:\d{2} by (.{1,8})/
    if matches = textBuffer.match createdPat
      return matches[1]

  willBeChecked: (filename) ->
    current = path.extname(filename)
    for ext in @checkedExtensions
      return true if ext == current
    return false

  getValidRange: (line, col, textEditor) ->
    line = parseInt(line) - 1
    col = parseInt(col) - 1
    if line
      if !col # if no column specified
        start = [line, 0]
        end = [line, textEditor.getBuffer().lineLengthForRow(line)]
      else
        start = [line, col]
        end = [line, col + 1]
    else
      start = [0, 0]
      end = start
    [start, end]

  getEachError: (line, filePath, textEditor) ->
    regex = /// ^
    (?:Error|Warning)\s*\(?
    (?:\s*line\s*([0-9]+))?   # [1] get line
    \s*,?
    (?:\s*col\s*([0-9]+))?    # [2] get column
    \s*\)?
    :\s*(.+)                  # [3] get message
    $ ///gm
    match = regex.exec(line)
    if !match
      return null
    message = {
      type: 'Norm',
      text: match[3],
      range: @getValidRange(match[1], match[2], textEditor),
      filePath: filePath
    }

  getErrors: (output, filePath, textEditor) ->
    new Promise (resolve, reject) =>
      messages = []
      for line in output.split /(\r\n)|\r|\n/
        message = @getEachError(line, filePath, textEditor)
        messages.push(message) if message
      resolve(messages)

  provideLinter: ->
    helpers = require 'atom-linter'
    provider =
      name: 'norminette'
      grammarScopes: ['source.c', 'source.cpp']
      scope: 'file'
      lintOnFly: false
      lint: (textEditor) =>
        creatorLogin = @headerCreator(textEditor.getBuffer().getText())
        rules = Object.keys(atom.config.settings['norminette-linter']).filter((s) -> s.startsWith('rules_')).map((s) -> s.replace('rules_', ''))
        if rules.length > 0
          parameters = ['-R', rules.join(), textEditor.getPath()]
        else
          parameters = [textEditor.getPath()]
        if @willBeChecked(textEditor.getPath()) == false
          return
        helpers.exec(@executablePath, parameters).then (output) =>
          @getErrors(output, textEditor.getPath(), textEditor)
