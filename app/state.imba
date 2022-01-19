import default_pages from './default_pages'

class State
	pages = []
	tabs = []
	current_page = 0
	last_visited_tab = ''

	get page
		if pages.length
			if current_page >= pages.length || current_page < 0
				current_page = pages.length - 1
				setCookie('current_page', current_page)
			return pages[current_page]

		return {id:'000', title:"Untitled", text:''}


	def constructor
		pages = JSON.parse(getCookie('pages')) || []
		unless pages.length
			pages = default_pages

		current_page = parseInt(getCookie('current_page')) || 0
		tabs = JSON.parse(getCookie('tabs')) || []

		unless tabs.length
			tabs = [page.id]

		unless getCookie('migrated')
			migrateToMarkdown!
			setCookie('migrated', 'true')

		console.log page


	def migrateToMarkdown
		for page in pages
			page.text = page.text.replaceAll('</div><div>', '</div>\n<div>')

			let div = <div>
			div.style.whiteSpace = 'pre'
			div.innerHTML = page.text
			page.text = div.innerText

		savePages!

	def savePages
		setCookie('pages', JSON.stringify(pages))

	def getCookie c_name
		return window.localStorage.getItem(c_name)

	def setCookie c_name, value
		window.localStorage.setItem(c_name, value)

	def copyObj obj\object
		return JSON.parse(JSON.stringify(obj))


	def randString
		Math.random().toString(36).slice(2)

	def uniqueID used_ids = []
		unless used_ids.length
			for page in pages
				used_ids.push(page.id)

		let id = randString! + randString!
		if id in used_ids
			return uniqueID used_ids
		return id

	def addNewPage
		let now = new Date(Date.now!)
		let text = "# Fresh page № {pages.length + 1}\nCreated at " + now.toLocaleString!
		current_page = pages.length
		pages.push {
			id: uniqueID!
			title: text
			text: text
		}
		setTab!
		setCookie('current_page', current_page)
		savePages!



	def goToPage index
		setLastVisited!
		if index == -1
			index = pages.length - 1
		elif index == pages.length
			index = 0
		current_page = index
		setTab!
		setCookie('current_page', index)

	def setLastVisited
		last_visited_tab = page.id

	def setTab
		unless page.id in tabs
			tabs.push page.id
		setCookie('tabs', JSON.stringify(tabs))

	# def loadData url
	# 	let res = await window.fetch url
	# 	return res.json




let state = new State

extend tag Element
	get state
		return state
