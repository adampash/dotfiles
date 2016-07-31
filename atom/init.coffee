# Your init script
#
# Atom will evaluate this file each time a new window is opened. It is run
# after packages are loaded/activated and after the previous editor state
# has been restored.
#
# An example hack to log to the console when each text editor is saved.
#
# atom.workspace.observeTextEditors (editor) ->
#   editor.onDidSave ->
#     console.log "Saved! #{editor.getPath()}"

atom.commands.add 'atom-text-editor', 'custom:last-tab', ->
  editor = atom.workspace.getActiveTextEditor()
  editorView = atom.views.getView(editor)
  atom.commands.dispatch editorView, "pane:show-next-recently-used-item"
  atom.commands.dispatch editorView, "pane:move-active-item-to-top-of-stack"
  # ', ,': 'pane:show-next-recently-used-item'
  # ', ,'
  # ctrl-tab ^ctrl	pane:move-active-item-to-top-of-stack
atom.commands.add 'atom-text-editor', 'custom:autoindent-all', ->
  editor = atom.workspace.getActiveTextEditor()
  editorView = atom.views.getView(editor)

  position = editor.getCursorScreenPosition()

  atom.commands.dispatch editorView, "core:select-all"
  atom.commands.dispatch editorView, "editor:auto-indent"
  atom.commands.dispatch editorView, "editor:clear-selection"

  editor.setCursorScreenPosition(position)

atom.commands.add 'atom-text-editor', 'custom:run-all', ->
  editor = atom.workspace.getActiveTextEditor()
  editorView = atom.views.getView(editor)

  position = editor.getCursorScreenPosition()

  atom.commands.dispatch editorView, "core:select-all"
  atom.commands.dispatch editorView, "hydrogen:run"
  editor.setCursorScreenPosition(position)
  atom.commands.dispatch editorView, "hydrogen:run"
  atom.commands.dispatch editorView, "editor:clear-selection"

atom.commands.add 'atom-text-editor', 'custom:show-doc', ->
  editor = atom.workspace.getActiveTextEditor()
  editorView = atom.views.getView(editor)
  position = editor.getCursorScreenPosition()


  if isClojure(editor)
    atom.commands.dispatch editorView, "editor:select-word"
    atom.commands.dispatch editorView,
      "proto-repl:print-var-documentation"
    editor.setCursorScreenPosition(position)
  else if isElixir(editor)
    atom.commands.dispatch editorView, "atom-elixir:show-elixir-docs"
  else
    atom.commands.dispatch editorView, "api-docs:search-under-cursor"

atom.commands.add 'atom-text-editor', 'custom:execute-repl', ->
  editor = atom.workspace.getActiveTextEditor()
  editorView = atom.views.getView(editor)
  position = editor.getCursorScreenPosition()


  if isClojure(editor)
    atom.commands.dispatch editorView, "proto-repl:execute-block"
  else
    atom.commands.dispatch editorView, "hydrogen:run"

isClojure = (editor) =>
  path = editor.getPath()
  clojRe = /\.cljs?$/
  path.match(clojRe)

isElixir = (editor) =>
  path = editor.getPath()
  elixiRe = /\.exs?$/
  path.match(elixiRe)
