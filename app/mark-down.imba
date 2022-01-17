import { EditorState } from '@codemirror/state'
import { EditorView, keymap } from '@codemirror/view'
import { defaultKeymap } from '@codemirror/commands'
import { history, historyKeymap } from '@codemirror/history'
import { indentOnInput } from '@codemirror/language'
import { bracketMatching } from '@codemirror/matchbrackets'
import { defaultHighlightStyle } from '@codemirror/highlight'
import { markdown, markdownLanguage } from '@codemirror/lang-markdown'
import { languages } from '@codemirror/language-data'
# import { oneDark } from '@codemirror/theme-one-dark'


import { syntaxHighlighting } from './highlighting'



tag mark-down
	ff\string
	page\object
	editorView\EditorView

	def setup
		useCodeMirror!
		log editorView
		imba.commit!

	def useCodeMirror
		const bollsPadTheme = EditorView.theme({
			'&': {
				backgroundColor: 'transparent !important'
				fontFamily:ff
				font:ff
				height: 'auto'
				color:'var(--c)'
			}
			".cm-content": {
				caretColor: 'var(--c)'
				minHeight: "100%"
				height:'auto'
			}
			".cm-scroller": {
				fontFamily:ff
				height:'auto'
				paddingBottom:'25vh'
			}
		}, {dark:true})

		const startState = EditorState.create({
			doc: page.text,
			extensions: [
				keymap.of([...defaultKeymap, ...historyKeymap]),
				history(),
				indentOnInput(),
				bracketMatching(),
				defaultHighlightStyle.fallback,
				markdown({
					base: markdownLanguage,
					codeLanguages: languages,
					addKeymap: true
				}),
				bollsPadTheme,
				syntaxHighlighting,
				# oneDark,
				EditorView.lineWrapping,
				EditorView.updateListener.of(do(update)
					if update.changes
						handleChange && handleChange(update.state)
				)
			]
		})

		editorView = new EditorView({
			state: startState,
			parent: self
		})


	def parsePageTitle
		page.title = ''
		let lines_count = 0
		for line in page.text.split('\n')
			line = line.trim()
			if line == ''
				continue

			page.title += line + '\n'
			lines_count += 1
			if lines_count > 2
				break


	def handleChange e
		# console.log e
		page.text = e.doc.toString!

		# # Save it to localStorage
		parsePageTitle!
		state.savePages!



	def render
		<self>

	css
		d:inline-block
		ws:pre-wrap
		height:calc(100vh - 128px) w:100% p:8px calc(50vw - 12px - $homx)
