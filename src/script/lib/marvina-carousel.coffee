import {Group, Solo} from './grouping'
import Util from '../helper/util'
import TouchMove from './touch-move'
import List from './list'
import Arrows from './arrows'
import defaultOptions from './default-options'
import events from './events'

export default class MarvinaCarousel
    # @params {Object} o
    constructor: (o=defaultOptions) ->
        # dont install if runs on the server.
        return if typeof window == 'undefined'

        @extractAttributes o
        @o = o
        
        unless @el = Util.getElement(o.el)
            throw new Error 'Element could not be found'

        # group
        @Group = if @group then Group else Solo
        @resize = @Group.resize.bind @
        @setCarouselAnimation = @Group.setCarouselAnimation.bind @
        @addElement = @Group.addElement.bind @
        @removeElement = @Group.removeElement.bind @

        @initDOM() if @init

    # Inits slider with creating DOM.
    initDOM: ->
        @el.classList.add 'mc'

        # elements & carousel
        @carouselEl = document.createElement 'div'
        @carouselEl.classList.add 'mc-carousel'
        @carouselEl.innerHTML = '<div class="mc-container"></div>'
        if c = @el.childNodes[0]
            @el.insertBefore @carouselEl, c
        else
            @el.appendChild @carouselEl
        @container = @carouselEl.querySelector 'div'

        elements = @el.querySelectorAll '.mc-carousel-element'
        @elements = []

        if @group
            wrapper = document.createElement 'div'
            wrapper.classList.add 'mc-wrapper'
            wrapper.style.marginRight = "#{@space}px"
            @container.appendChild wrapper
            for e in elements
                e.style.marginRight = "#{@space}px"
                wrapper.appendChild e
                @elements.push e
        else
            @cloneElements = []
            for e in elements
                e.style.marginRight = "#{@space}px"
                @container.appendChild e  
                @elements.push e      
            @totalIndex = @elements.length
            @index = 0

        @total = @elements.length
        @resize()

        @initSettingsElements()

        window.addEventListener 'resize', @resize, true
        @resize()

    # Inits carousel without creating DOM.
    initCarousel: ->
        @carouselEl = @el.querySelector '.mc-carousel'
        @container = @carouselEl.querySelector '.mc-container'
        @total = @totalIndex = @carouselEl.querySelectorAll('.mc-carousel-element').length
        @index = 0
        @initSettingsElements()

    # Inits settings elements.
    initSettingsElements: ->
        # touchMove
        @touchMove = new TouchMove @ if @o.touchMove

        # list / asList
        @list = new List @, @o.list, @o.asList if @o.list || @o.asList

        # arrows / prevArrow / nextArrow
        @arrows = new Arrows @, @o.arrows, {prevArrow:@o.asPrevArrow, nextArrow:@o.asNextArrow} if @o.arrows || @o.asPrevArrow || @o.asNextArrow 

        # auto playing
        if @autoPlay
            @autoPlayStatus = true
            @autoPlayContainer = document.createElement 'div'
            @autoPlayContainer.className = 'mc-autoplay-container mc-active'
            @autoPlayContainer.innerHTML = [
                '<svg class="mc-play" viewBox="0 0 48 48"> \t\t\t\t\t\t<path d="M16 10v28l22-14z"></path> \t\t\t\t\t</svg>'
                '<svg class="mc-stop" viewBox="0 0 512 512"> \t\t\t\t\t\t<rect height="320" width="60" x="153" y="96"></rect><rect height="320" width="60" x="299" y="96"></rect> \t\t\t\t\t</svg>'
            ].join('')
            @autoPlayContainer.addEventListener Util.events.mousedown, @toggle.bind(@), true
            @setAutoPlayInterval(false)
            @el.appendChild @autoPlayContainer

    # Extracts attributes from default options.
    # @params {Object} o
    extractAttributes: (o) ->
        for key, value of defaultOptions
            o[key] = value unless o[key]?

        attrsKey = ['timing', 'duration', 'group', 'minImage', 'maxImage', 'minWidth', 'maxWidth', 'height', 'space', 'autoPlay', 'autoPlaySpeed', 'init']
        for key in attrsKey
            @[key] = o[key] if o[key]?

    # @params {HTMLElement} el
    # @params {Number} index
    addElementIterator: (el, index) ->
        el.classList.add 'mc-carousel-element'
        el.style.marginRight = "#{@space}px"

        yield

        @total += 1
        @elements.splice index, 0, el
        @resize(true)

    # Adds a new element to the carousel.
    # @params {String|HTMLElement} el
    # @params {Number} index
    add: (el, index) ->
        if (el = Util.getElement(el)) && index > -1 && index <= @total
            unless @processing
                @addElement el, index
            else
                setTimeout () =>
                    @add arguments...
                    , 500

    # Adds a new element to the head of the carousel.
    # @params {String|HTMLElement} el
    addFirst: (el) ->
        @add el, 0

    # Adds a new element to the last of the carousel.
    # @params {String|HTMLElement} el
    addLast: (el) ->
        @add el, @total

    # @params {Number} index
    removeElementIterator: (index) ->
        @elements[index].parentNode.removeChild @elements[index]

        yield

        @total -= 1
        @elements.splice index, 1
        @resize(true)

    # Removes the element at the specified index from the carousel.
    # @params {Number} index
    remove: (index) ->
        if index > -1 && index < @total && @total > 2
            unless @processing
                @removeElement index
            else
                setTimeout () =>
                    @remove arguments...
                    , 500

    # Removes the first element from the carousel.
    removeFirst: ->
        @remove 0

    # Removes the last element from the carousel.
    removeLast: ->
        @remove @total-1

    # Triggers previous image. Returns false if the carousel is in animation.
    # @returns {Promise<boolean>}
    prev: ->
        new Promise (resolve) =>
            unless @processing
                @prevIndex()
                .then (resp) => resolve(resp)
            else
                resolve false

    # @params {Boolean} touchMove
    # @returns {Promise<boolean>}
    prevIndex: (touchMove=false) ->
        new Promise (resolve) =>
            if (!@processing || touchMove) && @totalIndex > 1
                index = if @index - 1 >= 0 then @index - 1 else @totalIndex - 1
                @setCarouselAnimation index, false, false
                .then () => resolve(true)
            else
                resolve false

    # Triggers next image. Returns false if the carousel is in animation.
    # @returns {Promise<boolean>}
    next: ->
        new Promise (resolve) =>
            unless @processing
                @nextIndex()
                .then (resp) => resolve(resp)
            else
                resolve false

    # @params {Boolean} touchMove
    # @params {Boolean} auto
    # @returns {Promise<boolean>}
    nextIndex: (touchMove=false, auto=false) ->
        new Promise (resolve) =>
            if (!@processing || touchMove) && @totalIndex > 1
                index = if @index + 1 < @totalIndex then @index + 1 else 0
                @setCarouselAnimation index, true, auto
                .then () => resolve(true)
            else
                resolve false

    # Starts autoplay.
    play: ->
        unless @autoPlayStatus
            @autoPlayStatus = true
            @autoPlayContainer.classList.add 'mc-active'
            @setAutoPlayInterval()
            @el.dispatchEvent events.play

    # Stops autoplay.
    stop: ->
        if @autoPlayStatus
            @autoPlayStatus = false
            @autoPlayContainer.classList.remove 'mc-active'
            clearInterval @autoPlayInterval
            @el.dispatchEvent events.stop

    # Toggles autoplay.
    toggle: ->
        if @autoPlayStatus
            @stop()
        else
            @play()

    # Destroys the carousel.
    destroy: ->
        @touchMove.destroy() if @touchMove
        @list.destroy() if @list
        @arrows.destroy() if @arrows
        clearInterval @autoPlayInterval if @autoPlay && @autoPlayStatus
        @el.innerHTML = ''
        @el.classList.remove 'mc'
        @el.dispatchEvent events.destroy

    # @params {Number} index
    # @params {Boolean} next
    # @params {Boolean} auto
    # Sets animation
    setCarouselAnimationIterator: (index, next, auto=false) ->
        @processing = true

        i = @index
        @index = index
        if @list
            @list.index = index

        if (next && @index == 0 && i+1 == @totalIndex) || (!next && @index+1 == @totalIndex && i == 0)
            reverse = true
            reverseNext = @index == 0
        else
            reverse = false

        yield {i, reverse, reverseNext}

        @processing = false
        @el.dispatchEvent events.change
        
        if @autoPlay && @autoPlayStatus && !auto
            clearInterval @autoPlayInterval
            @setAutoPlayInterval false

        yield

    applyTransition: ->
        ["-webkit-transition:-webkit-transform #{@duration}ms 0s #{@timing};", 
        "-ms-transition:-ms-transform #{@duration}ms 0s #{@timing};",
        "transition:transform #{@duration}ms 0s #{@timing};"].join('')

    # Sets index, total index and image size
    # @params {Boolean} skip
    resizeIterator: (skip=false) ->
        unless @processing
            elWidth = @carouselEl.offsetWidth
            return if elWidth == @elWidth && skip != true
            @elWidth = elWidth
            @processing = true

            imageCount = @maxImage
            loop
                @width = (@elWidth - (@space * (imageCount - 1))) / imageCount

                if @minWidth && @width < @minWidth
                    imageCount -= 1
                else
                    break
            imageCount = @minImage if @minImage > imageCount
            @width = (@elWidth - (@space * (imageCount - 1))) / imageCount
            @width = @maxWidth if @maxWidth && @width > @maxWidth

            if @height
                elHeight = (@width * @height) / 100
                @carouselEl.style.height = "#{elHeight}px"

                unless elHeight == @elHeight
                    @elHeight = elHeight
                    @resize()

            totalIndex = @totalIndex
            yield {imageCount}

            unless @totalIndex == totalIndex
                if @list
                    m = if @totalIndex > totalIndex then @list.add.bind(@list) else @list.remove.bind(@list)
                    d = Math.abs @totalIndex - totalIndex
                    for i in [1..d]
                        m()
                    @list.index = @index

                @el.dispatchEvent events.totalIndex
            
            @processing = false
        else
            clearTimeout @processingTimeout if @processingTimeout
            @processingTimeout = setTimeout @resize, 500

    # Calculates resize values.
    # @param {Number} total
    calculateResize: (total) ->
        iterator = @resizeIterator true

        $ = iterator.next()
        unless $.done
            $ = $.value
            @imageCount = $.imageCount

        if @group
            @Group.setTotalIndex.call @, @imageCount
        else
            @total = @totalIndex = total
            @container.setAttribute 'style', Util.setCSSPrefix("transform:translateX(-#{(@index * @width) + (@index * @space)}px)")

        iterator.next()

    # @returns {Number}
    getIndex: ->
        @index

    # @params {Number} index
    # @returns {Promise<boolean>}
    setIndex: (index) ->
        new Promise (resolve) =>
            unless @processing
                if index > -1 && index < @totalIndex && index != @index
                    next = index > @index
                    @setCarouselAnimation index, next
                    .then () => resolve(true)
                else
                    resolve false
            else
                resolve false

    # @returns {Number}
    getTotal: ->
        @total

    # @returns {Number}
    getTotalIndex: ->
        @totalIndex

    # @returns {String}
    getTiming: ->
        @timing

    # @params {Number} timing
    setTiming: (@timing) ->

    # @returns {Number}
    getDuration: ->
        @duration

    # @params {Number} duration
    setDuration: (@duration) ->

    # @returns {Number}
    getAutoPlaySpeed: ->
        @autoPlaySpeed

    # @params {Number} speed
    setAutoPlaySpeed: (@autoPlaySpeed) ->

    # @params {Number} duration
    setAutoPlayInterval: (duration=true) ->
        speed = unless duration then @autoPlaySpeed else @autoPlaySpeed + @duration
        @autoPlayInterval = setInterval (() => @nextIndex(false, true)), speed