{spawn, execSync} = require 'child_process'

module.exports =
  provideLinter: ->
    root = 'c:\\code\\glucose' # TODO
    glucose = (execSync 'stack path --local-install-root', { cwd: root, encoding: 'utf8' } ).trim() + '\\bin\\glucose.exe'
    console.log "glucose: " + glucose
    name: 'glucose'
    scope: 'file'
    lintsOnChange: true
    grammarScopes: ['source.glucose']
    lint: (editor) ->
      file = editor.getPath()
      content = editor.getText()
      console.log "Linting " + file + " (" + content.length + " characters)..."
      new Promise (resolve) ->
        process = spawn glucose, [],
          cwd: root
          stdio: ['pipe', 'ignore', 'pipe']
        process.stdin.end content, "utf8"
        response = ''
        process.stderr.setEncoding 'utf8'
        process.stderr.on 'data', (chunk) -> response += chunk
        process.stderr.on 'end', -> resolve (parseErrors file, response)

parseErrors = (file, response) ->
  if !response
    return []
  trimmed = response.trim()
  [line, pos, text...] = trimmed.split ':'
  if (isNaN line) || (isNaN pos)
    return []
  start = [line-1, pos-1]
  end = [line-1, +pos]
  text = text.join(':').trim()
  [
    severity: 'error'
    location:
      file: file
      position: [start, end]
    excerpt: text
  ]
