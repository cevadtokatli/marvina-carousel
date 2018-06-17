import Util from '../helper/util'

export default class List
    constructor: (@carousel, list, @asList) ->
        @setIndex = @setIndex.bind @

        if list
            @listEl = document.createElement 'ul'
            @carousel.el.appendChild @listEl
            @listEl.addEventListener Util.events.mousedown, @setIndex, true

            for i in [0..@carousel.totalIndex-1]
                @add()

        if @asList
            @asList.addEventListener Util.events.mousedown, @setIndex, true

        @index = @carousel.index

    Object.defineProperties @prototype,
        index:
            get: ->
                @_index
            set: (value) -> 
                @_index = value
                @setActive()

    # Sets the new index by checking elements clicked on the list.
    # @params {Event} e
    setIndex: (e) ->
        target = e.target

        while target != @listEl && target != @asList && target.parentNode != @listEl && target.parentNode != @asList
            target = target.parentNode

        if target.parentNode == @listEl || target.parentNode == @asList
            index = Array.prototype.slice.call(target.parentNode.children).indexOf target
            @carousel.setIndex index

    # Sets active class by index.
    setActive: ->
        if @listEl
            activeEl = @listEl.querySelector '.mc-active'
            activeEl.classList.remove 'mc-active' if activeEl

            el = @listEl.querySelectorAll('li')[@index]
            el.classList.add 'mc-active' if el

        if @asList
            activeEl = @asList.querySelector '.mc-active'
            activeEl.classList.remove 'mc-active' if activeEl

            el = Array.prototype.slice.call(@asList.children)[@index]
            el.classList.add 'mc-active' if el

    # Adds a new element to the list.
    add: ->
        if @listEl
            @listEl.appendChild document.createElement('li')

    # Removes an element from the list.
    remove: ->
        if @listEl
            @listEl.removeChild @listEl.lastChild

    # Removes the event listener.
    destroy: ->
        if @asList
            @asList.removeEventListener Util.events.mousedown, @setIndex, true