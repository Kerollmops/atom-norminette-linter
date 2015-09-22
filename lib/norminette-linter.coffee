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
      grammarScopes: ["source.c", "source.cpp"]
      scope: 'file'
      lintOnFly: false
      lint: (textEditor) =>
        creatorLogin = @headerCreator(textEditor.getBuffer().getText())
        parameters = [textEditor.getPath()]
        if @willBeChecked(textEditor.getPath()) == false
          return
        helpers.exec(@executablePath, parameters).then (output) =>
          @getErrors(output, textEditor.getPath(), textEditor)
