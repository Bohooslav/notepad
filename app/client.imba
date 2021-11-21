import './state'
import './global-css'
import './mark-down'
import './menu-popup'

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

let settings = {
	theme: 'dark'
	accent: 'blue'
	font:
		size: 16
		family: "sans, sans-serif"
		name: "Sans Serif"
		line-height: 1.6
		max-width: 30
}
let menu_left = -300
let settings_menu_left = -300
let show_accents = no


let store = {
	show_page_menu: no
	show_fonts: no
}

const fonts = [
	{
		name: "Sans Serif",
		code: "sans, sans-serif"
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
	},
	{
		name: "Monospace",
		code: "monospace"
	}
]

const accents = [
	{
		name: "green",
		light: '#9acd32',
		dark: '#9acd32'
	},
	{
		name: "blue",
		light: '#8080FF',
		dark: '#417690'
	},
	{
		name: "purple",
		light: '#984da5',
		dark: '#994EA6'
	},
	{
		name: "gold",
		light: '#DAA520',
		dark: '#E1AF33'
	},
	{
		name: "red",
		light: '#DE5454',
		dark: '#D93A3A'
	},
]




tag app
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
		else
			if settings.theme == 'dark'
				changeTheme(settings.theme)
			else
				changeTheme('light')

		settings.font.size = parseInt(state.getCookie('font')) || settings.font.size
		settings.font.family = state.getCookie('font-family') || settings.font.family
		settings.font.name = state.getCookie('font-name') || settings.font.name
		settings.font.line-height = parseFloat(state.getCookie('line-height')) || settings.font.line-height
		settings.font.max-width = parseInt(state.getCookie('max-width')) || settings.font.max-width


	def clearSpace
		menu_left = -300
		settings_menu_left = -300
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
		settings.theme == 'light' ? "box-shadow: 0 0 {(grade + 300) / 5}px rgba(0, 0, 0, 0.067);" : ''

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
		if 0 <= index < state.pages.length
			state.current_page = index
			state.setCookie('current_page', index)
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

		html.dataset.theme = settings.accent + settings.theme
		html.dataset.light = settings.theme

		state.setCookie('theme', theme)

		setTimeout(&, 75) do
			imba.commit!.then do html.dataset.pukaka = 'no'


	def changeAccent accent
		settings.accent = accent
		html.dataset.theme = settings.accent + settings.theme
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

	def render
		<self @mousemove=mousemove>

			<nav[pos:fixed t:0 l:0 r:0 h:48px d:flex ai:center px:12px g:4px bgc:$bgc]>
				<button @click=goToPage(state.current_page - 1) .disabled=(state.current_page < 1)>
					<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20">
						<title> 'Prev'
						<path d="M7.05 9.293L6.343 10 12 15.657l1.414-1.414L9.172 10l4.242-4.243L12 4.343z">
				<button @click=toggleMenu>
					<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
						<title> 'Menu'
						<path d="M0 0h24v24H0z" fill="none" />
						<path d="M3 18h18v-2H3v2zm0-5h18v-2H3v2zm0-7v2h18V6H3z" />
				<button @click=goToPage(state.current_page + 1) .disabled=(state.current_page + 1 >= state.pages.length)>
					<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20">
						<title> 'Next'
						<path d="M12.95 10.707l.707-.707L8 4.343 6.586 5.757 10.828 10l-4.242 4.243L8 15.657l4.95-4.95z">

				<menu-popup[ml:auto pos:relative] bind=store.show_page_menu>
					<button @click=(store.show_page_menu = !store.show_page_menu)>
						<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20">
							<path d="M10 12a2 2 0 1 1 0-4 2 2 0 0 1 0 4zm0-6a2 2 0 1 1 0-4 2 2 0 0 1 0 4zm0 12a2 2 0 1 1 0-4 2 2 0 0 1 0 4z">

						if store.show_page_menu
							<.popup_menu [y@off:-32px o@off:0] ease>
								<button.butt[p:8px] @click=removePage!> 'Remove page'


				<button @click=toggleSettingsMenu>
					<svg[p:2px] xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16">
						<path d="M7.502 1.019a.996.996 0 0 0-.998.998v.451a5.734 5.734 0 0 0-1.356.566l-.322-.322a.995.995 0 0 0-1.41 0l-.705.705a.995.995 0 0 0 0 1.41l.32.32a5.734 5.734 0 0 0-.56 1.358h-.454a.995.995 0 0 0-.998.996V8.5c0 .553.446.996.998.996h.45a5.734 5.734 0 0 0 .566 1.356l-.322.322a.995.995 0 0 0 0 1.41l.705.705c.39.391 1.02.391 1.41 0l.32-.32a5.734 5.734 0 0 0 1.358.56v.456c0 .552.445.996.998.996h.996a.995.995 0 0 0 .998-.996v-.451a5.734 5.734 0 0 0 1.355-.567l.323.322c.39.391 1.02.391 1.41 0l.705-.705a.995.995 0 0 0 0-1.41l-.32-.32a5.734 5.734 0 0 0 .56-1.358h.453a.995.995 0 0 0 .998-.996v-.998a.995.995 0 0 0-.998-.996h-.449a5.734 5.734 0 0 0-.566-1.355l.322-.323a.995.995 0 0 0 0-1.41l-.705-.705a.995.995 0 0 0-1.41 0l-.32.32a5.734 5.734 0 0 0-1.358-.56v-.455a.996.996 0 0 0-.998-.998zm.515 3.976a3 3 0 0 1 3 3 3 3 0 0 1-3 3 3 3 0 0 1-3-3 3 3 0 0 1 3-3z" style="marker:none">


			# The heart of the app ;)
			<mark-down $key=state.page.id page=state.page [w:100% m:auto max-width:{settings.font.max-width}em min-height:calc(100vh - 128px) ff:{settings.font.family} fs:{settings.font.size}px lh:{settings.font.line-height}]>


			<nav.drawer @touchstart=slidestart @touchend=closedrawersend @touchcancel=closedrawersend @touchmove=closingdrawer style="left: {menu_left}px; {boxShadow(menu_left)}{(onzone || inzone) ? 'transition:none;' : ''}">
				<h1[p:8px d:flex ai:center]>
					"Pages"
					<button[ml:auto] @click=(state.addNewPage!, clearSpace!)>
						<svg[p:4px] xmlns="http://www.w3.org/2000/svg" viewBox="0 0 10 10">
							<title> 'Fresh page'
							<path d="M6,4 h 4 V 6 H 6 v 4 H 4 V 6 H 0 V 4 H 4 V 0 h 2Z">
				for page, i in state.pages
					<div.page_in_nav @click=goToPage(i)>
						<div.page_preview>
							let lines = page.title.split('\n')
							<b> lines.shift!
							if lines.length
								<p[fs:0.9em]> lines.join('\n')


			<aside @touchstart=slidestart @touchend=closedrawersend @touchcancel=closedrawersend @touchmove=closingdrawer style="right:{MOBILE_PLATFORM ? settings_menu_left : settings_menu_left ? settings_menu_left : settings_menu_left + 12}px;{boxShadow(settings_menu_left)}{(onzone || inzone) ? 'transition:none;' : ''}">
				<h1[fs:24px h:32px d:flex jc:space-between ai:center]>
					"Settings"

					<.current_accent .enlarge_current_accent=show_accents>
						<.visible_accent @click=(do show_accents = !show_accents)>
						<.accents .show_accents=show_accents>
							for accent in accents when accent.name != settings.accent
								<.accent @click=changeAccent(accent.name) [bgc: {settings.theme == 'dark' ? accent.light : accent.dark}]>
				<.btnbox>
					<svg.cbtn[p:8px w:50%] @click=changeTheme('dark') enable-background="new 0 0 24 24" viewBox="0 0 24 24" >
						<title> 'Night theme'
						<g>
							<path d="M11.1,12.08C8.77,7.57,10.6,3.6,11.63,2.01C6.27,2.2,1.98,6.59,1.98,12c0,0.14,0.02,0.28,0.02,0.42 C2.62,12.15,3.29,12,4,12c1.66,0,3.18,0.83,4.1,2.15C9.77,14.63,11,16.17,11,18c0,1.52-0.87,2.83-2.12,3.51 c0.98,0.32,2.03,0.5,3.11,0.5c3.5,0,6.58-1.8,8.37-4.52C18,17.72,13.38,16.52,11.1,12.08z">
						<path d="M7,16l-0.18,0C6.4,14.84,5.3,14,4,14c-1.66,0-3,1.34-3,3s1.34,3,3,3c0.62,0,2.49,0,3,0c1.1,0,2-0.9,2-2 C9,16.9,8.1,16,7,16z">
					<svg.cbtn[w:50% p:8px] @click=changeTheme('light') viewBox="0 0 20 20">
						<title> 'Day theme'
						<path d="M10 14a4 4 0 1 1 0-8 4 4 0 0 1 0 8zM9 1a1 1 0 1 1 2 0v2a1 1 0 1 1-2 0V1zm6.65 1.94a1 1 0 1 1 1.41 1.41l-1.4 1.4a1 1 0 1 1-1.41-1.41l1.4-1.4zM18.99 9a1 1 0 1 1 0 2h-1.98a1 1 0 1 1 0-2h1.98zm-1.93 6.65a1 1 0 1 1-1.41 1.41l-1.4-1.4a1 1 0 1 1 1.41-1.41l1.4 1.4zM11 18.99a1 1 0 1 1-2 0v-1.98a1 1 0 1 1 2 0v1.98zm-6.65-1.93a1 1 0 1 1-1.41-1.41l1.4-1.4a1 1 0 1 1 1.41 1.41l-1.4 1.4zM1.01 11a1 1 0 1 1 0-2h1.98a1 1 0 1 1 0 2H1.01zm1.93-6.65a1 1 0 1 1 1.41-1.41l1.4 1.4a1 1 0 1 1-1.41 1.41l-1.4-1.4z">
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




	css
		d:flex
		fld:column
		jc:center
		p:64px 12px
		min-height:100%

		nav
			svg
				size:24px
				fill:$c

			button
				bgc:transparent @hover:$acc-bgc @active:$acc-bgc-hover
				bd:none
				rd:4px
				p:4px
				cursor:pointer

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
			bgc@hover:$acc-bgc
			cursor:pointer

		.page_preview
			-webkit-line-clamp:3
			overflow: hidden
			display: -webkit-box
			-webkit-box-orient: vertical
			ws:pre-wrap
		
		.btnbox
			cursor: pointer
			height: 46px
			margin: 16px 0

		.cbtn
			width: 50%
			height: 100%
			fill: $c
			color: $c
			display: inline-block
			text-align: center
			background-color: transparent
			cursor: pointer
			border-radius: 8px
			fill@hover:$acc-color-hover
			bgc@hover:$acc-bgc-hover @active:$acc-bgc
			y@active:4px
		

		.aside_button
			w:100% h:46px bg:transparent @hover:$btn-bg-hover d:flex ai:center font:inherit p:0 12px
		
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



imba.mount <app>