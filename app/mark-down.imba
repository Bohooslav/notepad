import { EditorState } from '@codemirror/state'
import { EditorView, keymap, placeholder } from '@codemirror/view'
import { defaultKeymap, indentWithTab } from '@codemirror/commands'
import { history, historyKeymap } from '@codemirror/history'
import { indentOnInput } from '@codemirror/language'
import { bracketMatching } from '@codemirror/matchbrackets'
import { defaultHighlightStyle } from '@codemirror/highlight'
import { markdown, markdownLanguage, markdownKeymap } from '@codemirror/lang-markdown'
import { languages } from '@codemirror/language-data'
import { closeBrackets, closeBracketsKeymap } from '@codemirror/closebrackets'
import { StreamLanguage } from "@codemirror/stream-parser"

import { syntaxHighlighting } from './highlighting'


tag mark-down
	page\object
	editorView\EditorView

	def setup
		useCodeMirror!
		imba.commit!

	def useCodeMirror
		const bollsPadTheme = EditorView.theme({
			'&': {
				backgroundColor: 'transparent !important'
				fontFamily:'var(--ff)'
				font:'var(--ff)'
				height: 'auto'
				color:'var(--c)'
			}
			".cm-content": {
				caretColor: 'var(--c)'
				height:'auto'
				minHeight:"calc(100vh - 128px)"
				paddingBottom:'25vh'
			}
			".cm-scroller": {
				fontFamily:'var(--ff)'
				height:'auto'
			}
			"&.cm-editor.cm-focused": {
				outline:'none'
			}
			"&.cm-focused .cm-matchingBracket, &.cm-focused .cm-nonmatchingBracket": {
				backgroundColor: "var(--acc-bgc-hover)",
				outline: "1px solid var(--acc-bgc)"
			},
		}, {dark:true})

		const startState = EditorState.create({
			doc: page.text
			extensions: [
				keymap.of([...defaultKeymap, ...historyKeymap, ...closeBracketsKeymap, ...markdownKeymap, indentWithTab]),
				history(),
				closeBrackets(),
				indentOnInput(),
				bracketMatching(),
				defaultHighlightStyle.fallback,
				markdown({
					base: markdownLanguage,
					codeLanguages: languages,
					addKeymap: true,
				}),
				markdownLanguage.data.of({closeBrackets: {brackets: ["(", "[", '{', "'", '"', '`', '*', '_']}}),
				placeholder('Mark dowm something juicy 🍋')
				bollsPadTheme,
				syntaxHighlighting,
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
		min-height:calc(100vh - 128px) w:100% p:8px calc(50vw - 12px - $homx)
