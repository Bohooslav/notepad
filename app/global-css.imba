global css
	html[data-theme="light"]
		$bgc: hsl(0, 100%, 97%)
		$c: rgb(4, 6, 12)
		$acc-bgc: hsl(276, 100%, 90%)
		$acc-bgc-hover: hsl(276, 100%, 94%)
		$disabled: rgb(86, 82, 78)
		$codebg:red1
		$code:warmer8

		$indigo:indigo8
		$lime:lime7
		$cyan:cyan5
		$violet:violet7
		$orange:orange7
		$yellow:yellow7
		$sky:sky6
		$amber:amber6
		$blue:blue7
		$rose:rose7
		$cool:cool5


	html[data-theme="dark"]
		$bgc: rgb(4, 6, 12)
		$c: rgb(255, 238, 238)
		$acc-bgc: #252749
		$acc-bgc-hover: #383a6d
		$disabled: rgb(168, 162, 159)
		$codebg:cooler8
		$code:warmer2

		$indigo:indigo3
		$lime:lime4
		$cyan:cyan3
		$violet:violet4
		$orange:orange4
		$yellow:yellow4
		$sky:sky4
		$amber:amber5
		$blue:blue4
		$rose:rose4
		$cool:cool5


	html[data-theme="sepia"]
		$bgc: rgb(235, 219, 183)
		$c: rgb(46, 39, 36)
		$acc-bgc: rgb(226, 204, 152)
		$acc-bgc-hover: rgb(230, 211, 167)
		$disabled: rgb(86, 82, 78)

	html[data-theme="gray"]
		$bgc: #f1f1f1
		$c: black
		$acc-bgc: #d3d3d3
		$acc-bgc-hover: #e5e5e5
		$disabled: rgb(86, 82, 78)

	html[data-theme="black"]
		$bgc: black
		$c: white
		$acc-bgc: #252749
		$acc-bgc-hover: #383a6d
		$disabled: rgb(168, 162, 159)

	html[data-theme="white"]
		$bgc: white
		$c: black
		$acc-bgc: hsl(276, 100%, 90%)
		$acc-bgc-hover: hsl(276, 100%, 94%)
		$disabled: rgb(86, 82, 78)



	html[data-accent="bluedark"]
		$acc-color: hsl(240, 100%, 75%)
		$acc-color-hover: hsla(219, 100%, 77%, 0.996)

	html[data-accent="bluelight"]
		$acc-color: hsl(240, 100%, 24%)
		$acc-color-hover: hsla(200, 100%, 32%, 0.996)

	html[data-accent="greendark"]
		$acc-color: hsl(80, 100%, 70%)
		$acc-color-hover: hsla(80, 100%, 76%, 0.996)

	html[data-accent="greenlight"]
		$acc-color: hsl(80, 100%, 24%)
		$acc-color-hover: hsla(80, 100%, 32%, 0.996)

	html[data-accent="purpledark"]
		$acc-color: hsl(291, 100%, 70%)
		$acc-color-hover: hsla(291, 100%, 76%, 0.996)

	html[data-accent="purplelight"]
		$acc-color: hsl(291, 100%, 24%)
		$acc-color-hover: hsla(291, 100%, 32%, 0.996)

	html[data-accent="golddark"]
		$acc-color: hsl(43, 100%, 70%)
		$acc-color-hover: hsla(43, 100%, 76%, 0.996)

	html[data-accent="goldlight"]
		$acc-color: hsl(43, 100%, 24%)
		$acc-color-hover: hsla(43, 100%, 32%, 0.996)

	html[data-accent="reddark"]
		$acc-color: hsl(0, 100%, 70%)
		$acc-color-hover: hsla(0, 100%, 76%, 0.996)

	html[data-accent="redlight"]
		$acc-color: hsl(0, 100%, 24%)
		$acc-color-hover: hsla(0, 100%, 32%, 0.996)


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

		transition-timing-function: ease-in-out
		transition-delay: 0
		transition-duration: 500ms
		transition-property: color, background, width, height, transform, opacity, max-height, max-width, top, left, bottom, right, visibility, fill, stroke, margin, padding, border

	*::selection
		background-color: $acc-bgc

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
		ws:pre
		cursor: pointer
		padding: 12px
		font-size: 16px
		display: block
		width: 100%
		text-align: left
		min-width: 148px


	.btn
		bgc:$acc-bgc @hover:$acc-bgc-hover p:8px 12px c:$c font:inherit m:16px 0 rd:4px cursor:pointer

		o@disabled:0.5

	
	mark-down
		*
			transition@important: none