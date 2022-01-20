import './state'
import './global-css'
import './mark-down'
import './menu-popup'
import {svg_paths} from './svg_paths'

let html = document.documentElement

let agent = window.navigator.userAgent;
let isWebkit = (agent.indexOf("AppleWebKit") > 0);
let isIOS = (agent.indexOf("iPhone") > 0 || agent.indexOf("iPod") > 0)
let isAndroid = (agent.indexOf("Android")  > 0)
let isNewBlackBerry = (agent.indexOf("AppleWebKit") > 0 && agent.indexOf("BlackBerry") > 0)
let isWebOS = (agent.indexOf("webOS") > 0);
let isWindowsMobile = (agent.indexOf("IEMobile") > 0)
let isSmallScreen = (screen.width < 767 || (isAndroid && screen.width < 1000))
let isUnknownMobile = (isWebkit && isSmallScreen)
let isMobile = (isIOS || isAndroid || isNewBlackBerry || isWebOS || isWindowsMobile || isUnknownMobile)
let MOBILE_PLATFORM = no

if isMobile && isSmallScreen && document.cookie.indexOf( "mobileFullSiteClicked=") < 0
	MOBILE_PLATFORM = yes


let menu_left = -300
let settings_menu_left = -300
let show_accents = no
let modal_window = ''
let extab = yes
let shortalt = no

let settings = {
	theme: 'dark'
	accent: 'blue'
	tabs: no
	shortcuts_hint:yes
	font:
		size: 16
		family: "'JetBrains Mono', monospace"
		name: "JetBrains Mono"
		line-height: 1.6
		max-width: 60

	get light
		if this.theme == 'dark' or this.theme == 'black'
			return 'dark'
		return 'light'
}

let store = {
	show_page_menu: no
	show_fonts: no
	show_themes: no
	nav_search: ''
	search_input: ''
	merge_replace: 'false'
	import_data:[]
}

const fonts = [
	{
		name: "Sans Serif",
		code: "sans, sans-serif"
	},
	{
		name: "JetBrains Mono",
		code: "'JetBrains Mono', monospace"
	},
	{
		name: "David Libre",
		code: "'David Libre', serif"
	},
	{
		name: "Bellefair",
		code: "'Bellefair', serif"
	},
	{
		name: "Tinos",
		code: "'Tinos', serif"
	},
	{
		name: "Roboto Slab",
		code: "'Roboto Slab', sans-serif"
	}
]

const accents = [
	{
		name:"blue"
		light:'hsl(219,100%,77%)'
		dark:'hsl(200,100%,32%)'
	}
	{
		name:"green"
		light:'hsl(80,100%,76%)'
		dark:'hsl(80,100%,32%)'
	}
	{
		name:"purple"
		light:'hsl(291,100%,76%)'
		dark:'hsl(291,100%,32%)'
	}
	{
		name:"gold"
		light:'hsl(43,100%,76%)'
		dark:'hsl(43,100%,32%)'
	}
	{
		name:"red"
		light:'hsl(0,100%,76%)'
		dark:'hsl(0,100%,32%)'
	}
]


def hidePanels
	shortalt = no


window.onblur = hidePanels
document.body.onmouseleave = hidePanels
document.onmouseleave = hidePanels
window.onmouseout = hidePanels



tag app
	search_results = []


	def setup
		# Detect change of dark/light mode
		window.matchMedia('(prefers-color-scheme: dark)')
		.addEventListener('change', do |event|
			if event.matches
				changeTheme('dark')
			else
				changeTheme('light')
		)

		if state.getCookie('theme')
			settings.theme = state.getCookie('theme')
			settings.accent = state.getCookie('accent') || settings.accent
		changeTheme(settings.theme)

		settings.tabs = (state.getCookie('show_tabs') == 'true')
		settings.shortcuts_hint = !(state.getCookie('shortcuts_hint') == 'false')
		settings.font.size = parseInt(state.getCookie('font')) || settings.font.size
		settings.font.family = state.getCookie('font-family') || settings.font.family
		settings.font.name = state.getCookie('font-name') || settings.font.name
		settings.font.line-height = parseFloat(state.getCookie('line-height')) || settings.font.line-height
		settings.font.max-width = parseInt(state.getCookie('max-width')) || settings.font.max-width
	

		document.onkeyup = do(e)
			if e.which == 18
				shortalt = no
				imba.commit!


	def clearSpace
		menu_left = -300
		settings_menu_left = -300
		modal_window = ''
		shortalt = no
		imba.commit!

	def toggleMenu
		if menu_left
			if !settings_menu_left && MOBILE_PLATFORM
				clearSpace()
				return
			menu_left = 0
			settings_menu_left = -300
		else
			menu_left = -300

	def toggleSettingsMenu
		if settings_menu_left
			if !menu_left && MOBILE_PLATFORM
				clearSpace()
				return
			settings_menu_left = 0
			menu_left = -300
		else
			settings_menu_left = -300


	def boxShadow grade
		settings.light == 'light' ? "box-shadow: 0 0 {(grade + 300) / 5}px rgba(0, 0, 0, 0.067);" : ''

	def mousemove e
		if not MOBILE_PLATFORM
			if 300 < e.x < window.innerWidth - 300
				menu_left = -300
				settings_menu_left = -300


	def slidestart touch
		slidetouch = touch.changedTouches[0]

		if slidetouch.clientX < 16 or slidetouch.clientX > window.innerWidth - 16
			inzone = yes

	def slideend touch
		touch = touch.changedTouches[0]

		touch.dy = slidetouch.clientY - touch.clientY
		touch.dx = slidetouch.clientX - touch.clientX

		if menu_left > -300
			if inzone
				touch.dx < -64 ? menu_left = 0 : menu_left = -300
			else
				touch.dx > 64 ? menu_left = -300 : menu_left = 0
		elif settings_menu_left > -300
			if inzone
				touch.dx > 64 ? settings_menu_left = 0 : settings_menu_left = -300
			else
				touch.dx < -64 ? settings_menu_left = -300 : settings_menu_left = 0

		slidetouch = null
		inzone = no

	def closingdrawer e
		e.dx = e.changedTouches[0].clientX - slidetouch.clientX

		if menu_left > -300 && e.dx < 0
			menu_left = e.dx
		if settings_menu_left > -300 && e.dx > 0
			settings_menu_left = - e.dx
		onzone = yes

	def openingdrawer e
		if inzone
			e.dx = e.changedTouches[0].clientX - slidetouch.clientX

			if menu_left < 0 && e.dx > 0
				menu_left = e.dx - 300
			if settings_menu_left < 0 && e.dx < 0
				settings_menu_left = - e.dx - 300

	def closedrawersend touch
		touch.dx = touch.changedTouches[0].clientX - slidetouch.clientX

		if menu_left > -300
			touch.dx < -64 ? menu_left = -300 : menu_left = 0
		elif settings_menu_left > -300
			touch.dx > 64 ? settings_menu_left = -300 : settings_menu_left = 0
		onzone = no



	def goToPage index
		state.goToPage index
		clearSpace!

	def setPage id
		state.setLastVisited!
		state.current_page = state.pages.indexOf(state.pages.find(do(el) return el.id == id))
		state.setCookie('current_page', state.current_page)
		state.setTab!
		clearSpace!
	
	def closeTab id
		if state.tabs.length == 1
			console.log('You better not to close the last tab you son of a homo sapiens!')
			return
		let page_index = state.pages.indexOf(state.pages.find(do(el) return el.id == id))
		let tab_index = state.tabs.indexOf(id)
		state.tabs.splice(tab_index, 1)
		state.setCookie('tabs', JSON.stringify(state.tabs))

		if page_index == state.current_page
			if last_visited_tab in state.tabs
				state.current_page = state.pages.indexOf(state.pages.find(do(el) return el.id == last_visited_tab))
			else
				unless state.tabs[tab_index]
					log state.tabs[tab_index], tab_index, 'hehe'
					if tab_index > 0
						tab_index--
					else
						tab_index++

				log state.tabs[tab_index]
				state.current_page = state.pages.indexOf(state.pages.find(do(el) return el.id == state.tabs[tab_index]))


		if state.current_page >= state.pages.length
			state.current_page -= 1

		state.setCookie('current_page', state.current_page)
		clearSpace!



	def removePage
		let sure = window.confirm("Are you sure you want to remove this page forever?")
		if state.pages[state.current_page] && sure
			state.pages.splice(state.current_page, 1)
			if state.current_page == state.pages.length
				state.current_page -= 1
				state.setCookie('current_page', state.current_page)
		state.savePages!




	def changeTheme theme
		html.dataset.pukaka = 'yes'
		settings.theme = theme

		html.dataset.accent = settings.accent + settings.light
		html.dataset.theme = settings.theme

		state.setCookie('theme', theme)

		setTimeout(&, 75) do
			imba.commit!.then do html.dataset.pukaka = 'no'


	def changeAccent accent
		settings.accent = accent
		html.dataset.accent = settings.accent + settings.light
		state.setCookie('accent', accent)
		show_accents = no


	def decreaseFontSize
		if settings.font.size > 16
			settings.font.size -= 2
			state.setCookie('font', settings.font.size)

	def increaseFontSize
		if settings.font.size < 64 && window.innerWidth > 480
			settings.font.size = settings.font.size + 2
		elif settings.font.size < 40
			settings.font.size = settings.font.size + 2
		state.setCookie('font', settings.font.size)

	def setFontFamily font
		settings.font.family = font.code
		settings.font.name = font.name
		state.setCookie('font-family', font.code)
		state.setCookie('font-name', font.name)

	def changeLineHeight increase
		if increase && settings.font.line-height < 2.6
			settings.font.line-height += 0.2
		elif settings.font.line-height > 1.2
			settings.font.line-height -= 0.2
		state.setCookie('line-height', settings.font.line-height)

	def changeMaxWidth increase
		if increase && settings.font.max-width < 120 && (settings.font.max-width - 15) * settings.font.size < window.innerWidth
			settings.font.max-width += 15
		elif settings.font.max-width > 15
			settings.font.max-width -= 15
		state.setCookie('max-width', settings.font.max-width)

	def scoreSearch item, search_query
		item = item.toLowerCase!
		search_query = search_query.toLowerCase!
		let score = 0
		let p = 0 # Position within the `item`
		# Look through each character of the search string, stopping at the end(s)...

		for i in [0 ... search_query.length]
			# Figure out if the current letter is found in the rest of the `item`.
			const index = item.indexOf(search_query[i], p)
			# If not, stop here.
			if index < 0
				break
			#  If it is, add to the score...
			score++
			#  ... and skip the position within `item` forward.
			p = index

		return score


	def searchNotes
		const query = store.search_input.trim!.toLowerCase!
		unless query.length
			search_results =  state.pages
			return

		search_results = []


		for page in state.pages # in aa given translations book
			# Approximate search through title
			let score = scoreSearch(page.title, query)

			# Add bounty through full note search
			if query in page.text.toLowerCase!
				score += 64

			if score > query.length * 0.75
				search_results.push({
					id: page.id
					title: page.title
					score: score
				})

		search_results = search_results.sort(do |a, b| b.score - a.score)

	def showMainSearch
		clearSpace!
		searchNotes!
		modal_window = 'search'
		setTimeout(&, 100) do $mainsearch.focus!

	
	def showImportExport
		clearSpace!
		modal_window = 'imexport'

	def exportData
		JSON.stringify(state.pages)

	def downloadUrl
		let myBlob = new Blob([exportData!], {type: "text/plain"})
		return window.URL.createObjectURL(myBlob)

	def readSingleFile e
		let file = e.target.files[0]
		if !file
			return

		let reader = new FileReader()
		reader.onload = do(e)
			let contents = e.target.result
			try
				let content = JSON.parse(contents)
				if typeof content == 'object'
					# Now check if the data is correct
					for item in content
						if !item.id || !item.title || !item.text
							throw 'bad file'
					# log 'good', content
					store.import_data = content

			catch e
				log e
				window.alert('Bad file!')
			# log contents
		reader.readAsText(file)
	
	def importNotes
		for item in store.import_data
			let exist = state.pages.find(do(el) return el.id == item.id)
			if exist
				if store.merge_replace
					let index = state.pages.indexOf(exist)
					state.pages[index] = state.copyObj(item)
					if state.current_page == index
						let editor = document.getElementsByTagName('MARK-DOWN')[0]
						editor.innerHTML = item.text
			else
				state.pages.push state.copyObj(item)

		state.savePages!
		clearSpace!
		window.alert('Import was successfull!')

	def tabTitle title
		if title
			let lines = title.split('\n')
			title = lines.shift!
			if title.startsWith('#')
				return title.substring(1)
		else
			title = "Untitled"

		return title	


	def getPageById id
		for page in state.pages
			if page.id == id
				return page
			
	def toggleTabs
		settings.tabs = !settings.tabs
		state.setCookie('show_tabs', settings.tabs)
	
	def toggleShortcutsHint
		settings.shortcuts_hint = !settings.shortcuts_hint
		state.setCookie('shortcuts_hint', settings.shortcuts_hint)


	def closeCurrentTab
		if settings.tabs
			closeTab state.page.id

	def render
		<self @mousemove=mousemove [$homx:{settings.font.max-width / 2}em]>

			<nav[pos:fixed t:0 l:0 r:0 zi:1 h:48px d:flex ai:center px:12px g:4px bgc:$bgc]>
				<button @click=goToPage(state.current_page - 1) .disabled=(state.current_page < 1)>
					<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20">
						<title> 'Prev (Alt + Left Arrow)'
						<path d="M7.05 9.293L6.343 10 12 15.657l1.414-1.414L9.172 10l4.242-4.243L12 4.343z">
				<button @click=toggleMenu>
					<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
						<title> 'Menu'
						<path d="M0 0h24v24H0z" fill="none" />
						<path d="M3 18h18v-2H3v2zm0-5h18v-2H3v2zm0-7v2h18V6H3z" />
				<button @click=goToPage(state.current_page + 1) .disabled=(state.current_page + 1 >= state.pages.length)>
					<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20">
						<title> 'Next (Alt + Right Arrow)'
						<path d="M12.95 10.707l.707-.707L8 4.343 6.586 5.757 10.828 10l-4.242 4.243L8 15.657l4.95-4.95z">

				<[d:flex w:100% h:100% ai:center]>
					if settings.tabs
						for tab in state.tabs
							let page = getPageById tab
							<div.tab .opentab=(page.id == state.page.id) @click=setPage(page.id) @click.middle=closeTab(page.id)>
								<p> tabTitle page.title
								<span @click.stop=closeTab(page.id)> '⨯'
					else
						<div.tab[o:1 bgc@hover:$bgc]>
							<p> tabTitle state.page.title
				if state.pages.length
					<menu-popup[pos:relative] bind=store.show_page_menu>
						<button @click=(store.show_page_menu = !store.show_page_menu)>
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20">
								<title> "Page settings"
								<path d="M10 12a2 2 0 1 1 0-4 2 2 0 0 1 0 4zm0-6a2 2 0 1 1 0-4 2 2 0 0 1 0 4zm0 12a2 2 0 1 1 0-4 2 2 0 0 1 0 4z">

							if store.show_page_menu
								<.popup_menu [y@off:-32px o@off:0] ease>
									<button.butt[pr:12px h:auto d:flex ai:center g:4px] @click=removePage!>
										<svg viewBox="0 0 12 16">
											<title> "Remove page"
											<path fill-rule="evenodd" clip-rule="evenodd" d="M11 2H9C9 1.45 8.55 1 8 1H5C4.45 1 4 1.45 4 2H2C1.45 2 1 2.45 1 3V4C1 4.55 1.45 5 2 5V14C2 14.55 2.45 15 3 15H10C10.55 15 11 14.55 11 14V5C11.55 5 12 4.55 12 4V3C12 2.45 11.55 2 11 2ZM10 14H3V5H4V13H5V5H6V13H7V5H8V13H9V5H10V14ZM11 4H2V3H11V4Z">
										'Remove page'

									<button.butt[pr:12px h:auto d:flex ai:center g:4px] @click=(state.addNewPage!, clearSpace!)>
										<svg[p:4px] xmlns="http://www.w3.org/2000/svg" viewBox="0 0 10 10">
											<title> 'Fresh page'
											<path d="M6,4 h 4 V 6 H 6 v 4 H 4 V 6 H 0 V 4 H 4 V 0 h 2Z">
										'Fresh page'



				<button @click=toggleSettingsMenu>
					<svg[p:2px] xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16">
						<title> "General settings"
						<path d="M7.502 1.019a.996.996 0 0 0-.998.998v.451a5.734 5.734 0 0 0-1.356.566l-.322-.322a.995.995 0 0 0-1.41 0l-.705.705a.995.995 0 0 0 0 1.41l.32.32a5.734 5.734 0 0 0-.56 1.358h-.454a.995.995 0 0 0-.998.996V8.5c0 .553.446.996.998.996h.45a5.734 5.734 0 0 0 .566 1.356l-.322.322a.995.995 0 0 0 0 1.41l.705.705c.39.391 1.02.391 1.41 0l.32-.32a5.734 5.734 0 0 0 1.358.56v.456c0 .552.445.996.998.996h.996a.995.995 0 0 0 .998-.996v-.451a5.734 5.734 0 0 0 1.355-.567l.323.322c.39.391 1.02.391 1.41 0l.705-.705a.995.995 0 0 0 0-1.41l-.32-.32a5.734 5.734 0 0 0 .56-1.358h.453a.995.995 0 0 0 .998-.996v-.998a.995.995 0 0 0-.998-.996h-.449a5.734 5.734 0 0 0-.566-1.355l.322-.323a.995.995 0 0 0 0-1.41l-.705-.705a.995.995 0 0 0-1.41 0l-.32.32a5.734 5.734 0 0 0-1.358-.56v-.455a.996.996 0 0 0-.998-.998zm.515 3.976a3 3 0 0 1 3 3 3 3 0 0 1-3 3 3 3 0 0 1-3-3 3 3 0 0 1 3-3z" style="marker:none">


			<div[fs:{settings.font.size}px lh:{settings.font.line-height} $ff:{settings.font.family}]>
				<mark-down key=state.page.id page=state.page>


			<nav.drawer @touchstart=slidestart @touchend=closedrawersend @touchcancel=closedrawersend @touchmove=closingdrawer
				style="left: {menu_left}px; {boxShadow(menu_left)}{(onzone || inzone) ? 'transition:none;' : ''}">
				<h1[p:8px d:flex ai:center pr:0]>
					"Pages"
					<button[ml:auto] @click=(state.addNewPage!, clearSpace!)>
						<svg[p:4px] xmlns="http://www.w3.org/2000/svg" viewBox="0 0 10 10">
							<title> 'Fresh page'
							<path d="M6,4 h 4 V 6 H 6 v 4 H 4 V 6 H 0 V 4 H 4 V 0 h 2Z">
				let nothing_found = yes
				for page, i in state.pages when store.nav_search.toLowerCase! in page.title.toLowerCase!
					nothing_found = no
					<div.page_in_nav .active_butt=(i==state.current_page) @click=goToPage(i)>
						<page-preview page=page>

				if nothing_found
					<p[ws:pre fs:14px ta:center pt:16px]> '(ಠ╭╮ಠ)  ¯\\_(ツ)_/¯  ノ( ゜-゜ノ)'

				<[d:flex h:48px pos:absolute b:0px l:0px w:100%]>
					<input$nav_search bind=store.nav_search [h:100% w:100% font:inherit c:inherit bg:$bgc bd:none px:8px] placeholder="Search">
					<svg[h:100% w:40px pr:16px fill:$c @hover:$acc-color-hover cursor:pointer] viewBox="0 0 12 12" width="24px" height="24px" @click=($nav_search.focus!)>
						<title> "Search"
						<path d="M9.827 8.584l1.95 1.951a.879.879 0 0 1-1.242 1.242l-1.95-1.95c-2.137 1.55-5.12 1.383-7.02-.517-2.108-2.108-2.083-5.55.055-7.69C3.76-.518 7.202-.543 9.31 1.565c1.9 1.9 2.067 4.883.517 7.02zm-1.256-.013c1.721-1.72 1.741-4.49.045-6.187C6.92.688 4.15.708 2.429 2.43.708 4.149.688 6.919 2.384 8.616c1.696 1.696 4.466 1.676 6.187-.045z">


			<aside @touchstart=slidestart @touchend=closedrawersend @touchcancel=closedrawersend @touchmove=closingdrawer
				style="right:{MOBILE_PLATFORM ? settings_menu_left : settings_menu_left ? settings_menu_left : settings_menu_left + 12}px;{boxShadow(settings_menu_left)}{(onzone || inzone) ? 'transition:none;' : ''}">
				<h1[fs:24px h:32px d:flex jc:space-between ai:center]>
					"Settings"

					<.current_accent .enlarge_current_accent=show_accents>
						<.visible_accent @click=(do show_accents = !show_accents)>
						<.accents .show_accents=show_accents>
							for accent in accents when accent.name != settings.accent
								<.accent @click=changeAccent(accent.name) [bgc: {settings.light == 'dark' ? accent.light : accent.dark}]>
				<button.btnbox.cbtn.aside_button @click=showMainSearch>
					<svg[size:24px ml:4px mr:16px] viewBox="0 0 12 12" width="24px" height="24px">
						<title> 'Search'
						<path d=svg_paths.search>
					'Search'

				<menu-popup bind=store.show_themes>
					<.btnbox.cbtn.aside_button.popup_menu_box [d:flex transform@important:none ai:center pos:relative] @click=(do store.show_themes = !store.show_themes)>
						<svg[size:24px ml:4px mr:16px] xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512">
							<title> 'Night theme'
							<path d="M167.02 309.34c-40.12 2.58-76.53 17.86-97.19 72.3-2.35 6.21-8 9.98-14.59 9.98-11.11 0-45.46-27.67-55.25-34.35C0 439.62 37.93 512 128 512c75.86 0 128-43.77 128-120.19 0-3.11-.65-6.08-.97-9.13l-88.01-73.34zM457.89 0c-15.16 0-29.37 6.71-40.21 16.45C213.27 199.05 192 203.34 192 257.09c0 13.7 3.25 26.76 8.73 38.7l63.82 53.18c7.21 1.8 14.64 3.03 22.39 3.03 62.11 0 98.11-45.47 211.16-256.46 7.38-14.35 13.9-29.85 13.9-45.99C512 20.64 486 0 457.89 0z">
						"Theme"
						if store.show_themes
							<.popup_menu.themes_popup [l:0 y@off:-32px o@off:0] ease>
								<button.butt[bgc:black c:white bdr:32px solid white] @click=changeTheme('black')> 'Black'
								<button.butt[bgc:rgb(4, 6, 12) c:rgb(255, 238, 238) bdr:32px solid rgb(255, 238, 238)] @click=changeTheme('dark')> 'Night'
								<button.butt[bgc:#f1f1f1 c:black bdr:32px solid black] @click=changeTheme('gray')> 'Gray'
								<button.butt[bgc:rgb(235, 219, 183) c:rgb(46, 39, 36) bdr:32px solid rgb(46, 39, 36)] @click=changeTheme('sepia')> 'Sepia'
								<button.butt[bgc:rgb(255, 238, 238) c:rgb(4, 6, 12) bdr:32px solid rgb(4, 6, 12)] @click=changeTheme('light')> 'Light'
								<button.butt[bgc:white c:black bdr:32px solid black] @click=changeTheme('white')> 'White'


				<.btnbox>
					<button[p: 12px fs: 20px].cbtn @click=decreaseFontSize title='Decreace font size'> "B-"
					<button[p: 8px fs: 24px].cbtn @click=increaseFontSize title='Increace font size'> "B+"

				<.btnbox>
					<svg.cbtn @click=changeLineHeight(no) viewBox="0 0 38 14" fill="context-fill" [padding: 16px 0]>
						<title> "Decrease line height"
						<rect x="0" y="0" width="28" height="2">
						<rect x="0" y="6" width="38" height="2">
						<rect x="0" y="12" width="18" height="2">
					<svg.cbtn @click=changeLineHeight(yes) viewBox="0 0 38 24" fill="context-fill" [padding: 10px 0]>
						<title> "Increase line height"
						<rect x="0" y="0" width="28" height="2">
						<rect x="0" y="11" width="38" height="2">
						<rect x="0" y="22" width="18" height="2">

				if window.innerWidth > 639
					<.btnbox>
						<svg.cbtn @click=changeMaxWidth(no) width="42" height="16" viewBox="0 0 42 16" fill="context-fill" [padding: calc(42px - 28px) 0]>
							<title> "Increase max width"
							<path d="M14.5,7 L8.75,1.25 L10,-1.91791433e-15 L18,8 L17.375,8.625 L10,16 L8.75,14.75 L14.5,9 L1.13686838e-13,9 L1.13686838e-13,7 L14.5,7 Z">
							<path d="M38.5,7 L32.75,1.25 L34,6.58831647e-15 L42,8 L41.375,8.625 L34,16 L32.75,14.75 L38.5,9 L24,9 L24,7 L38.5,7 Z" transform="translate(33.000000, 8.000000) scale(-1, 1) translate(-33.000000, -8.000000)">
						<svg.cbtn @click=changeMaxWidth(yes) width="44" height="16" viewBox="0 0 44 16" fill="context-fill" [padding: calc(42px - 28px) 0]>
							<title> "Decrease max width"
							<path d="M14.5,7 L8.75,1.25 L10,-1.91791433e-15 L18,8 L17.375,8.625 L10,16 L8.75,14.75 L14.5,9 L1.13686838e-13,9 L1.13686838e-13,7 L14.5,7 Z" transform="translate(9.000000, 8.000000) scale(-1, 1) translate(-9.000000, -8.000000)">
							<path d="M40.5,7 L34.75,1.25 L36,-5.17110888e-16 L44,8 L43.375,8.625 L36,16 L34.75,14.75 L40.5,9 L26,9 L26,7 L40.5,7 Z">


				<menu-popup bind=store.show_fonts>
					<.btnbox.cbtn.aside_button.popup_menu_box [d:flex transform@important:none ai:center pos:relative] @click=(do store.show_fonts = !store.show_fonts)>
						<span.font_icon> "B"
						settings.font.name
						if store.show_fonts
							<.popup_menu [l:0 y@off:-32px o@off:0] ease>
								for font in fonts
									<button.butt[ff: {font.code}] .active_butt=font.name==settings.font.name @click=setFontFamily(font)> font.name
				
				<button.btnbox.cbtn.aside_button @click=showImportExport>
					<svg[size:24px ml:4px mr:16px] xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 0 24 24" width="24px">
						<title> 'Export / Import'
						<path d="M0 0h24v24H0z" fill="none">
						<path d="M9 3L5 6.99h3V14h2V6.99h3L9 3zm7 14.01V10h-2v7.01h-3L15 21l4-3.99h-3z">
					'Export / Import'


				<div.parent_checkbox @click=toggleTabs .checked=settings.tabs>
					'Tabs'
					<p.checkbox> <span>

				<div.parent_checkbox @click=toggleShortcutsHint .checked=settings.shortcuts_hint>
					'Shortcuts hint'
					<p.checkbox> <span>



			if modal_window.length
				<section [pos:fixed t:0 b:0 r:0 l:0 bgc:#000A h:100% d:flex jc:center p:14vh 0 @lt-sm:0 o@off:0 visibility@off:hidden zi:3] @click=clearSpace ease>

					<div[pos:relative max-height:72vh @lt-sm:100vh max-width:64em @lt-sm:100% w:80% @lt-sm:100% bgc:$bgc bd:1px solid $acc-bgc-hover @lt-sm:none rd:16px @lt-sm:0 p:12px 24px @lt-sm:12px scale@off:0.75] @click.stop>
						#  .height_auto=(!search_results.length && modal_window=='search')

						if modal_window == 'search'
							<article.search_hat [pos:relative]>
								<svg [fill@hover:firebrick] @click=clearSpace viewBox="0 0 20 20">
									<title> 'Close'
									<path[m:auto] d=svg_paths.close>

								<input$mainsearch[w:100% bg:transparent font:inherit c:inherit p:0 8px fs:1.2em min-width:128px bd:none bxs:none] bind=store.search_input minLength=2 type='text' placeholder="Search" aria-label="Search" @input=searchNotes>

								<svg [w:24px min-width:24px mr:8px fill@hover:$acc-color] viewBox="0 0 12 12" width="24px" height="24px" @click=$mainsearch.focus!>
									<title> "Search"
									<path d=svg_paths.search>

							<article[pb:32px]>
								<>
									for result, key in search_results
										<div.page_in_nav @click=setPage(result.id)>
											<page-preview page=result>

								unless search_results.length
									<div[display:flex flex-direction:column height:100% justify-content:center align-items:center]>
										<p> '(ಠ╭╮ಠ)  ¯\\_(ツ)_/¯  ノ( ゜-゜ノ)'

						elif modal_window == 'imexport'
							<article.search_hat [pos:relative]>
								<svg [fill@hover:firebrick pos:sticky zi:222] @click=clearSpace viewBox="0 0 20 20">
									<title> 'Close'
									<path[m:auto] d=svg_paths.close>

								<div.imex_block>
									<button.imex_block_btn .active_tab=extab @click=(extab = yes)> "Export"
									<button.imex_block_btn .active_tab=!extab @click=(extab = no)> "Import"

							<article#imex>
								if extab
									<h1> 'Export Notes'
									<a download="notes.json" href=downloadUrl!> 'Download notes.json'
									<p[my:16px]> 'or copy'
									<textarea$exportta 
										value=exportData!
										readOnly=yes
										@click=$exportta.select
										[w:100% h:calc(100% - 210px) bgc:$bgc c:$c resize:vertical bd:none cursor:copy]>
								else
									<h1> 'Import Notes'
									<input.file-input type='file' @change=readSingleFile> 'Open notes.json'
									<p[m:24px 0 8px fw:600]>
										"Merge strategy:"

									<label>
										<input type="radio" value="false" bind=store.merge_replace>
										"Skip conflicting pages"
									<label>
										<input type="radio" value="true" bind=store.merge_replace>
										"Replace existing"

									<button.btn disabled=!store.import_data.length @click=importNotes> "Import"

									<textarea
										value=JSON.stringify(store.import_data)
										readOnly=yes
										[w:100% h:calc(100% - 356px) bgc:$bgc c:$c resize:vertical bd:none]>



			if shortalt && settings.shortcuts_hint
				<shortcuts-hint[o@off:0] ease>
				


			<global
				@hotkey("mod+s").force.prevent.stop
				@hotkey("mod+q").force.prevent.stop=(window.open('', '_parent', '').close();)

				@hotkey('alt+right').prevent.stop.force=goToPage(state.current_page + 1)
				@hotkey('alt+left').prevent.stop.force=goToPage(state.current_page - 1)

				@hotkey('alt+n').force.stop.prevent=(state.addNewPage!, clearSpace!)

				@hotkey('mod+shift+f').force.stop.prevent=showMainSearch
				@hotkey('esc').force.stop.prevent=clearSpace

				@hotkey('alt').force.passive=(shortalt = yes)
				@hotkey('alt+w').force.prevent.stop=closeCurrentTab
				>



	css
		p:64px 12px
		min-height:100%


	css
		nav
			svg
				size:24px
				min-width:24px
				fill:$c

			button
				bgc:transparent @hover:$acc-bgc @active:$acc-bgc-hover
				bd:none
				rd:4px
				p:4px
				cursor:pointer
				size:32px

		.disabled
			o:0.25

			
		aside
			border-left: 1px solid $acc-bgc
			padding: 16px 12px
			overflow-y: auto
			-webkit-overflow-scrolling: touch
			transition-property@important: right

		.drawer
			border-right: 1px solid $acc-bgc
			padding: 16px 8px
			transition-property@important: left

		.drawer, aside
			position: fixed
			top: 0
			bottom: 0
			width: 300px
			touch-action: pan-y
			z-index: 1000
			background-color:$bgc
			us:none

		.page_in_nav
			p:8px
			rd:8px
			bgc@hover:$acc-bgc-hover
			cursor:pointer

		.btnbox
			cursor: pointer
			height: 46px
			margin: 16px 0

		.cbtn
			width: 50%
			height: 100%
			fill:$c @hover:$acc-color
			color:$c @hover:$acc-color
			display: inline-block
			text-align: center
			background-color: transparent
			cursor: pointer
			border-radius: 8px
			fill@hover:$acc-color-hover
			bgc@hover:$acc-bgc-hover @active:$acc-bgc
			y@active:4px


		.aside_button
			w:100% h:46px bg:transparent @hover:$acc-bgc-hover d:flex ai:center font:inherit p:0 12px


		.font_icon
			font-family: "Tinos", serif
			font-size: 27px
			padding: 0 8px
			margin-right: 12px


		.current_accent
			cursor:pointer size:1em zi:1100


		.visible_accent
			background-color: $acc-color-hover
			border-radius: 23%
			origin:center right
			size: 1em

		.enlarge_current_accent, .enlarge_current_accent .visible_accent
			size: 32px
			overflow: visible

		.accents
			mr:1em mt:-28px rd:23% d:flex visibility:hidden o:0 scale:0.8 origin:center right

		.show_accents
			margin-left: -2px
			margin-top: -32px
			visibility: visible
			opacity: 1
			transform: scale(1)

		.accents .accent
			border-radius: 23%
			size: 32px
			margin: 0 2px 0
			border: 1px solid $acc-bgc-hover

		.show_accents .accent
			margin: 0 -34px 0

		.themes_popup button
			fw:900

		.active_butt
			bgc: $acc-bgc

		.height_auto
			max-height@important:76px
			mb:auto
			border-bottom:1px solid $acc-bgc-hover

		.search_hat
			display: flex

		.search_hat svg
			min-width: 24px
			width: 26px
			height: 50px
			padding: 12px 0
			fill: $c
			cursor: pointer

		.imex_block
			pos:absolute w:100% h:100% d:flex jc:center g:8px p:4px

		.imex_block_btn
			font:inherit
			c:inherit
			bgc:$acc-bgc @hover:$acc-bgc-hover
			p:0 12px
			rd:4px
			cursor:pointer
			fw:bold
		
		.active_tab
			bgc:$acc-color-hover
			c:$bgc


	css
		#imex
			h1
				my:16px

			a
				c:$c fw:bolder
				d:inline-block
				td:none
				p:12px
				bgc:$acc-bgc
				rd:4px

		.file-input
			font:inherit
			w:100% h:46px
			cursor: pointer

		.file-input::-webkit-file-upload-button
			visibility:hidden

		.file-input::before
			content: 'Open notes.json'
			display: inline-block
			background:$acc-bgc
			w:auto ta:center
			border-radius: 8px
			padding: 12px 16px
			outline: none
			white-space: nowrap
			-webkit-user-select: none

		.file-input@hover::before
			bgc:$acc-bgc-hover

		.file-input@active::before
			bgc:$acc-bgc-hover

		#imex
			h:100%
		
		#imex
			label
				d:flex ai:center
				cursor:pointer
			
			input[type="radio"]::before
				d:inline-block
				p:0 8px
				c:$c
				fs:32px
				content:'○'


			input[type="radio"]@checked::before
				content: '●'

	css
		.tab
			w:100% h:100%
			bgc@hover:$acc-bgc
			d:flex ai:center
			p:8px
			cursor:pointer
			ta:center
			pos:relative
			bc:$acc-bgc
			transition-property:background-color, opacity
			bs:solid
			bw:0px
			o:0.5 @hover:1

			p
				w:100%
				-webkit-line-clamp:1
				overflow: hidden
				display: -webkit-box
				-webkit-box-orient: vertical
				word-break: break-all
			
			span
				pos:absolute
				r:8px
				bgc@hover:$acc-bgc-hover
				d:inline-block
				size:24px
				min-width:24px
				lh:1
				p:3px 4px
				rd:1em
				o:0
			
			@hover
				span
					o:1
			
		.opentab
			bwb:4px
			o:1
			span
				o:1

	css
		.parent_checkbox
			d:flex ai:center
			m:24px 0
			h:38px
			cursor:pointer
			$filling: $disabled
			c:$disabled
			width: 100%
		
		
		.checkbox
			width: 50px
			min-width: 50px
			height: 30px
			border: 2px solid $filling
			border-radius: 40px
			margin-left: auto

		.checkbox span
			display: block
			width: 26px
			height: 26px
			background: $filling
			border-radius: 14px

		.checked
			$filling:$c
			c:$c
		
		.checked span
			x:20px



tag page-preview
	prop page\object

	css self, b
		-webkit-line-clamp:3
		overflow: hidden
		display: -webkit-box
		-webkit-box-orient: vertical
		ws:pre-wrap
		word-break:break-word
	
	css b
		-webkit-line-clamp:2



	def render
		<self>
			if page.title
				let lines = page.title.split('\n')
				<div[d:flex jc:space-between]>
					<b> lines.shift!
					if page.score
						<i> page.score
				if lines.length > 1
					<p[fs:0.9em]> lines.join('\n')
			else
				<b> "Empty page 🤷🏻‍♂️"

tag shortcuts-hint
	<self>
		<h1[fs:1.2em pb:8px]> 'Shortcuts'
		<p>
			<code> 'Alt + Right Arrow'
			" — go to next page"
		<p>
			<code> 'Alt + Left Arrow'
			" — go to previous page"
		<p>
			<code> 'Alt + N'
			" — create a fresh page"

		if settings.tabs
			<p>
				<code> 'Alt + W'
				" — close current tab"
		<p>
			<code> 'Ctrl + Shift + F'
			" — search pages"
		<p>
			<code> 'Ctrl + W'
			" — quit / close app"
		<p>
			'Hold '
			<code> 'Alt'
			' to see this hint'
		
		<global @click.outside=(shortalt = no)>

	css
		pos:fixed t:48px r:16px bgc:$bgc bd:1px solid $acc-bgc rd:16px transition-duration:150ms p:16px

	css
		code
			c:$code
		p
			p:2px 0

imba.mount <app>
