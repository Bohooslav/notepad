import { HighlightStyle, tags } from '@codemirror/highlight'

export const syntaxHighlighting = HighlightStyle.define([
	{
		tag: tags.heading1,
		fontSize: '2em'
		fontWeight: 'bold'
		color:'var(--sky)'
		lineHeight:'1.2'
		padding:'8px 0'
	}
	{
		tag: tags.heading2
		fontSize: '1.6em'
		fontWeight: 'bold'
		color:'var(--sky)'
	}
	{
		tag: tags.heading3
		fontSize: '1.4em'
		fontWeight: 'bold'
		color:'var(--sky)'
	}
	{
		tag: tags.heading4
		fontSize: '1.2em'
		fontWeight: 'bold'
		color:'var(--sky)'
	}
	{
		tag: tags.heading5
		fontSize: '1.1em'
		fontWeight: 'bold'
		color:'var(--sky)'
	}
	{
		tag: tags.heading6
		fontWeight: 'bold'
		color:'var(--sky)'
	}
	{
		tag: [tags.processingInstruction, tags.inserted]
		opacity:0.5
	}
	{
		tag:tags.monospace
		backgroundColor:'var(--codebg)'
		color:'var(--code)'
		borderRadius:'4px'
		fontFamily:"'JetBrains Mono', monospace"
	}
	{
		tag:tags.link
		textDecoration: "underline"
		color: 'var(--indigo)'
	}
	{
		tag:tags.url
		color:'var(--blue)'
	}
	{
		tag:[tags.string, tags.special(tags.string)]
		color:'var(--lime)'
	}
	{
		tag:tags.strong
		fontWeight:'bold'
		color:'var(--rose)'
	}
	{
		tag:tags.emphasis
		color:'var(--yellow)'
		fontStyle:'italic'
	}
	{
		tag:tags.quote
		color:'var(--indigo)'
		fontStyle:'italic'
	}
	{
		tag:tags.strikethrough,
		textDecoration: "line-through"
	}



	# CODE
	{
		tag: [tags.atom, tags.bool, tags.special(tags.variableName)]
		color: 'var(--blue)'
	}
	{
		tag: [tags.keyword, tags.operator, tags.operatorKeyword]
		color: 'var(--violet)'
	}
	{
		tag: [tags.name, tags.deleted, tags.character]
		color: 'var(--orange)'
	}
	{
		tag: [tags.propertyName, tags.macroName]
		color: 'var(--rose)'
	}
	{
		tag: [tags.function(tags.variableName), tags.labelName]
		color: 'var(--sky)'
	}
	{
		tag: [tags.color, tags.constant(tags.name), tags.standard(tags.name)]
		color: 'var(--amber)'
	}
	{
		tag: [tags.definition(tags.name), tags.separator]
		color: 'var(--yellow)'
	}
	{
		tag: [tags.typeName, tags.className, tags.number, tags.changed, tags.annotation, tags.modifier, tags.self, tags.namespace]
		color: 'var(--blue)'
	}
	{
		tag: [tags.escape, tags.regexp, tags.special(tags.string)]
		color: 'var(--cyan)'
	}
	{
		tag: [tags.meta, tags.comment]
		color: 'var(--cool)'
	}
])