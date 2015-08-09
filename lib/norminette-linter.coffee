{CompositeDisposable} = require "atom"
path = require 'path'

module.exports = NorminetteLinter =
  config:
    executablePath:
      type: 'string'
      default: 'norminette'
      description: 'The executable path to the 42 norminette.'
    checkedExtensions:
      type: 'array'
      default: ['.c', '.h']
      items:
        type: 'string'
      description: 'Extensions that the linter will check'

  activate: (state) ->
    if !atom.packages.getLoadedPackages("linter")
      atom.notifications.addError(
        "Linter package not found.",
        { detail: "Please install the `linter` package in your Settings view." }
      )
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.config.observe 'norminette-linter.executablePath',
      (executablePath) => @executablePath = executablePath
    @subscriptions.add atom.config.observe 'norminette-linter.checkedExtensions'
      , (checkedExtensions) => @checkedExtensions = checkedExtensions

  deactivate: ->
    @subscriptions.dispose()

  willBeChecked: (filename) ->
    current = path.extname(filename)
    for ext in @checkedExtensions
      return true if ext == current
    return false

  provideLinter: ->
    helpers = require 'atom-linter'
    regex = \
    "^Error\\s*\\(?" +
    "(?:\\s*line\\s*(?<line>[0-9]+))?" +  # get line
    "\\s*,?" +
    "(?:\\s*col\\s*(?<col>[0-9]+))?" +    # get column
    "\\s*\\)?" +
    ":\\s*(?<message>.+)$"                # get message
    provider =
      grammarScopes: ["source.c", "source.cpp"]
      scope: 'file'
      lintOnFly: false
      lint: (textEditor) =>
        parameters = [textEditor.getPath()]
        # # /Users/crenault/Desktop/norminette
        if @willBeChecked(textEditor.getPath()) == false
          return
        helpers.exec(@executablePath, parameters).then (out) ->
          helpers.parse(out, regex, filePath: textEditor.getPath()).map (err) ->
            err.type = 'Error'
            err
