import { HighlightStyle, tags } from '@codemirror/highlight'

export const syntaxHighlighting = HighlightStyle.define([
	{
		tag: tags.heading1,
		fontSize: '2em',
		fontWeight: 'bold',
		color:'var(--header)'
		lineHeight:'2'
	},
	{
		tag: tags.heading2,
		fontSize: '1.6em',
		fontWeight: 'bold',
		color:'var(--header)'
	},
	{
		tag: tags.heading3,
		fontSize: '1.4em',
		fontWeight: 'bold',
		color:'var(--header)'
	},
	{
		tag: tags.heading4,
		fontSize: '1.2em',
		fontWeight: 'bold',
		color:'var(--header)'
	},
	{
		tag: tags.heading5,
		fontSize: '1.1em',
		fontWeight: 'bold',
		color:'var(--header)'
	},
	{
		tag: tags.heading6,
		fontWeight: 'bold'
		color:'var(--header)'
	},
	{
		tag: [tags.processingInstruction, tags.inserted],
		color: 'var(--instruction)'
		# opacity:0.5
	},
	{
		tag:tags.strong,
		fontWeight:'bold',
		color:'var(--strong)'
	},
	{
		tag:tags.emphasis,
		color:'var(--italic)'
	},
	{
		tag:tags.quote,
		color:'var(--quote)'
	},
	{
		tag:tags.link,
		color:'var(--link)'
	},
	{
		tag:tags.content,
		color:'var(--content)'
	}
])