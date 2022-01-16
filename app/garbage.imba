
# const formatBlock = 'formatBlock'
# const defaultParagraphSeparator = 'defaultParagraphSeparator' || 'div'

	# def exec command, value = null
	# 	document.execCommand(command, no, value)
	# 	focus()

	# def handlekeydown event
	# 	# This enables major keybidings
	# 	if event.ctrlKey == yes
	# 		switch event.code
	# 			when 'KeyI'
	# 				event.preventDefault()
	# 				exec('italic')
	# 			when 'KeyB'
	# 				event.preventDefault()
	# 				exec('bold')
	# 			when 'KeyU'
	# 				event.preventDefault()
	# 				exec('underline')

	# 	# If tab is pressed prevent the event and insert a tab
	# 	if event.which == 9
	# 		event.preventDefault()

	# 		let sel = document.getSelection()
	# 		let range = sel.getRangeAt(0)

	# 		let tabNode = document.createTextNode("\u0009")
	# 		range.insertNode(tabNode)

	# 		range.setStartAfter(tabNode)
	# 		range.setEndAfter(tabNode)
	# 		sel.removeAllRanges()
	# 		sel.addRange(range)

	# 	if event.key === 'Enter' && document.queryCommandValue(formatBlock) === 'blockquote'
	# 		setTimeout(&, 0) do exec(formatBlock, "<{defaultParagraphSeparator}>")


		# <self @keydown=handlekeydown @input=compile innerHTML=inputStream @paste=handlepaste contentEditable="true">

	# def handlepaste event
	# 	event.preventDefault()
	# 	let plainText = event.clipboardData.getData('text/plain')
	# 	document.execCommand('inserttext', no, plainText)

	# 	# Backup to the event.preventDefault()
	# 	return no