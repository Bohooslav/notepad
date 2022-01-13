const formatBlock = 'formatBlock'
const defaultParagraphSeparator = 'defaultParagraphSeparator' || 'div'


tag mark-down
	page = {}
	inputStream = "Hey there"
	outputStream = "<p>Hey there<p>"
	
	def mount
		inputStream = page.text
		outputStream = page.text
		imba.commit!

	def parsePageTitle
		page.title = ''
		let lines_count = 0
		for line in innerText.split('\n')
			line = line.trim()
			if line == ''
				continue

			page.title += line + '\n'
			lines_count += 1
			if lines_count > 2
				break

	def exec command, value = null
		document.execCommand(command, no, value)
		focus()

	def handlekeydown event
		# This enables major keybidings
		if event.ctrlKey == yes
			switch event.code
				when 'KeyI'
					event.preventDefault()
					exec('italic')
				when 'KeyB'
					event.preventDefault()
					exec('bold')
				when 'KeyU'
					event.preventDefault()
					exec('underline')

		# If tab is pressed prevent the event and insert a tab
		if event.which == 9
			event.preventDefault()

			let sel = document.getSelection()
			let range = sel.getRangeAt(0)

			let tabNode = document.createTextNode("\u0009")
			range.insertNode(tabNode)

			range.setStartAfter(tabNode)
			range.setEndAfter(tabNode)
			sel.removeAllRanges()
			sel.addRange(range)

		if event.key === 'Enter' && document.queryCommandValue(formatBlock) === 'blockquote'
			setTimeout(&, 0) do exec(formatBlock, "<{defaultParagraphSeparator}>")


	def handlepaste event
		event.preventDefault()
		let plainText = event.clipboardData.getData('text/plain')
		document.execCommand('inserttext', no, plainText)

		# Backup to the event.preventDefault()
		return no

	def compile e
		# Do here markdown parsing
		# TODO instead of innerHTML use output of the compiler
		outputStream = innerHTML

		# Save it to localStorage
		page.text = outputStream
		parsePageTitle!
		state.savePages!


	def render
		<self @keydown=handlekeydown @input=compile innerHTML=inputStream @paste=handlepaste contentEditable="true">


	css
		ws:pre-wrap

		*
			transition-property: none