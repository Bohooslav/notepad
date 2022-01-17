import { HighlightStyle, tags } from '@codemirror/highlight'

export const syntaxHighlighting = HighlightStyle.define([
	{
		tag: tags.heading1,
		fontSize: '2em'
		fontWeight: 'bold'
		color:'var(--header)'
		lineHeight:'2'
	}
	{
		tag: tags.heading2
		fontSize: '1.6em'
		fontWeight: 'bold'
		color:'var(--header)'
	}
	{
		tag: tags.heading3
		fontSize: '1.4em'
		fontWeight: 'bold'
		color:'var(--header)'
	}
	{
		tag: tags.heading4
		fontSize: '1.2em'
		fontWeight: 'bold'
		color:'var(--header)'
	}
	{
		tag: tags.heading5
		fontSize: '1.1em'
		fontWeight: 'bold'
		color:'var(--header)'
	}
	{
		tag: tags.heading6
		fontWeight: 'bold'
		color:'var(--header)'
	}
	{
		tag: [tags.processingInstruction, tags.inserted]
		opacity:0.5
	}
	{
		tag:tags.string
		color:'var(--string)'
	}
	{
		tag:tags.strong
		fontWeight:'bold'
		color:'var(--strong)'
	}
	{
		tag:tags.emphasis
		color:'var(--italic)'
		fontStyle:'italic'
	}
	{
		tag:tags.quote
		color:'var(--quote)'
	}
	{
		tag:tags.link
		textDecoration: "underline"
	}
	{
		tag:tags.url
		color:'var(--url)'
	}
	# {
	# 	tag:tags.content,
	# 	color:'var(--content)'
	# }
	{
		tag:tags.strikethrough,
		textDecoration: "line-through"
	}



	# CODE
	{
		tag: [tags.atom, tags.bool, tags.special(tags.variableName)]
		color: 'whiskey'
	}
	{
		tag: tags.keyword
		color: 'violet'
	}
	{
		tag: [tags.name, tags.deleted, tags.character, tags.propertyName, tags.macroName]
		color: 'coral'
	}
	{
		tag: [tags.function(tags.variableName), tags.labelName]
		color: 'malibu'
	}
	{
		tag: [tags.color, tags.constant(tags.name), tags.standard(tags.name)]
		color: 'whiskey'
	}
	{
		tag: [tags.definition(tags.name), tags.separator]
		color: 'ivory'
	}
	{
		tag: [tags.typeName, tags.className, tags.number, tags.changed, tags.annotation, tags.modifier, tags.self, tags.namespace]
		color: 'chalky'
	}
	{
		tag: [tags.operator, tags.operatorKeyword, tags.escape, tags.regexp, tags.special(tags.string)]
		color: 'cyan'
	}
	{
		tag: [tags.meta, tags.comment]
		color: 'stone'
	}
])