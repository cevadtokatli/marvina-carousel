import Util from '../helper/util'
import events from './events'

export default class TouchMove
    constructor: (@carousel) ->
        @start = @start.bind @
        @end = @end.bind @

        @carousel.carouselEl.addEventListener Util.events.mousedown, @start, true

    # Starts touching.
    # @params {Event} e
    start: (e) ->
        unless @carousel.processing
            @carousel.processing = true
            @carousel.el.dispatchEvent events.touchStart
            @startX = e.clientX || e.pageX
            @time = new Date().getTime()
            window.addEventListener Util.events.mouseup, @end, true

        e.preventDefault()

    # Ends touching.
    # @params {Event} e
    end: (e) ->
        @destroy()
        @carousel.el.dispatchEvent events.touchEnd

        endX = e.clientX || e.pageX
        x = endX - @startX
        t = new Date().getTime() - @time
        if Math.abs(x) >= 25 && t <= 250
            if x <= 0
                @carousel.nextIndex true
            else
                @carousel.prevIndex true
        else
            @carousel.processing = false

    # Removes the event listener.
    destroy: ->
        window.removeEventListener Util.events.mouseup, @end, true