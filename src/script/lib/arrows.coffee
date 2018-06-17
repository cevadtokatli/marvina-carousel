import Util from '../helper/util'

export default class Arrows
    constructor: (@carousel, arrows, @asArrows) ->
        @prev = @carousel.prev.bind @carousel
        @next = @carousel.next.bind @carousel

        @arrowEls = {}
        if arrows
            prevArrow = @arrowEls.prevArrow = document.createElement 'div'
            prevArrow.className = 'mc-arrow mc-prev-arrow'
            prevArrow.innerHTML = '<svg width="50" height="50" viewBox="0 0 1792 1792"><path d="M1203 544q0 13-10 23l-393 393 393 393q10 10 10 23t-10 23l-50 50q-10 10-23 10t-23-10l-466-466q-10-10-10-23t10-23l466-466q10-10 23-10t23 10l50 50q10 10 10 23z"/></svg>'
            @carousel.el.appendChild prevArrow
            prevArrow.addEventListener Util.events.mousedown, @prev, true

            nextArrow = @arrowEls.nextArrow = document.createElement 'div'
            nextArrow.className = 'mc-arrow mc-next-arrow'
            nextArrow.innerHTML = '<svg width="50" height="50" viewBox="0 0 1792 1792"><path d="M1171 960q0 13-10 23l-466 466q-10 10-23 10t-23-10l-50-50q-10-10-10-23t10-23l393-393-393-393q-10-10-10-23t10-23l50-50q10-10 23-10t23 10l466 466q10 10 10 23z"/></svg>'
            @carousel.el.appendChild nextArrow
            nextArrow.addEventListener Util.events.mousedown, @next, true

        if @asArrows.prevArrow
            @asArrows.prevArrow.addEventListener Util.events.mousedown, @prev, true

        if @asArrows.nextArrow
            @asArrows.nextArrow.addEventListener Util.events.mousedown, @next, true

    # Removes the event listeners.
    destroy: ->
        if @asArrows.prevArrow
            @asArrows.prevArrow.removeEventListener Util.events.mousedown, @prev, true

        if @asArrows.nextArrow
            @asArrows.nextArrow.removeEventListener Util.events.mousedown, @next, true