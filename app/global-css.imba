global css

	@root[data-light="light"]
		--bgc: white
		--c: black
		--acc-bgc: hsl(276, 100%, 90%)
		--acc-bgc-hover: hsl(276, 100%, 94%)


	@root[data-light="dark"]
		--bgc: black
		--c: white
		--acc-bgc: #252749
		--acc-bgc-hover: #383a6d


	html[data-theme="bluedark"]
		$acc-color: rgb(128, 128, 255)
		$acc-color-hover: rgba(150, 182, 243, 0.996)

	html[data-theme="bluelight"]
		$acc-color: navy
		$acc-color-hover: rgba(65, 118, 144, 0.996)

	html[data-theme="greendark"]
		$acc-color: olivedrab
		$acc-color-hover: yellowgreen

	html[data-theme="greenlight"]
		$acc-color: olivedrab
		$acc-color-hover: yellowgreen

	html[data-theme="purpledark"]
		$acc-color: rgb(152, 77, 165)
		$acc-color-hover: rgba(177, 113, 188, 0.996)

	html[data-theme="purplelight"]
		$acc-color: rgb(102, 52, 111)
		$acc-color-hover: rgba(153, 78, 166, 0.996)

	html[data-theme="golddark"]
		$acc-color: rgb(218, 165, 32)
		$acc-color-hover: rgba(231, 193, 95, 0.996)

	html[data-theme="goldlight"]
		$acc-color: rgb(169, 128, 25)
		$acc-color-hover: rgba(225, 175, 51, 0.996)

	html[data-theme="reddark"]
		$acc-color: rgb(222, 84, 84)
		$acc-color-hover: rgba(230, 122, 122, 0.996)

	html[data-theme="redlight"]
		$acc-color: rgb(137, 26, 26)
		$acc-color-hover: rgba(217, 58, 58, 0.996)


	html[data-pukaka="yes"] *
		transition-property@important: none


	*
		box-sizing: border-box
		scrollbar-color: $acc-bgc rgba(0,0,0,0)
		scrollbar-width: auto
		margin: 0
		padding: 0
		scroll-behavior: smooth
		-webkit-overflow-scrolling: touch
		-webkit-tap-highlight-color: transparent

		transition-timing-function: ease
		transition-delay: 0
		transition-duration: 500ms
		transition-property: color, background, width, height, transform, opacity, max-height, max-width, top, left, bottom, right, visibility, fill, stroke, margin, padding, border

	*::selection
		text-decoration-color: $bgc
		color: $bgc
		background-color: $c

	::-webkit-scrollbar
		width: 12px

	::-webkit-scrollbar-track
		background: transparent

	::-webkit-scrollbar-thumb
		background: $acc-bgc-hover
		border-radius: 4px

	::-webkit-scrollbar-thumb:hover
		background: $acc-bgc

	@focus
		outline: none


	input
		-webkit-appearance: none
		-moz-appearance: none
		appearance: none

	button
		bd:none

	html
		c:$c
		bgc:$bgc
		ff:sans
		font-size: 18px @lt-sm: 16px


	.popup_menu
		background-color: $bgc
		position: absolute
		r:0
		top: calc(100% + 8px)
		border-radius: 8px
		border: 1px solid #8888
		z-index: 10000000


	.popup_menu .butt
		background: transparent @hover:$acc-bgc-hover
		color: $c
		cursor: pointer
		padding: 12px
		font-size: 16px
		display: block
		width: 100%
		text-align: left
		min-width: 128px

