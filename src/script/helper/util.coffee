class Util
    @isMobile: /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test navigator.userAgent
    @events: {
        mousedown: if @isMobile then 'touchstart' else 'mousedown'
        mouseup: if @isMobile then 'touchend' else 'mouseup'
    }
    @transitionEndEvents: ['transitionend', 'webkitTransitionEnd', 'oTransitionEnd', 'otransitionend', 'MSTransitionEnd']

    # Returns the given element.
    # @params {HTMLElement|String} el
    # @returns {HTMLElement}
    @getElement: (el) ->
        if typeof el == 'string'
            return document.querySelector el
        el

    # Attaches the given events to the element.
    # @params {HTMLElement} el
    # @params {String[]} events
    # @params {EventListener} callback
    @addMultiEventListener: (el, events, callback) ->
        for i in events
            el.addEventListener i, callback, true

    # Removes the events from the element.
    # @params {HTMLElement} el
    # @params {String[]} events
    # @params {EventListener} callback
    @removeMultiEventListener: (el, events, callback) ->
        for i in events
            el.removeEventListener i, callback, true

    # Attaches the events to the element for once.
    # @params {HTMLElement} el
    # @params {String[]} events
    # @params {EventListener} callback
    @addMultiEventListenerOnce: (el, events, callback) ->
        cb = (e) =>
            @removeMultiEventListener el, events, cb
            callback e
        @addMultiEventListener el, events, cb

    # @params {String} css
    # @returns {String}
    @setCSSPrefix: (css) ->
        "-webkit-#{css}; -ms-#{css}; #{css};"

    # Creates a new event and initalizes it.
    # @params {String} name
    # @returns {Event}
    @createEvent: (name) ->
        event = document.createEvent('HTMLEvents') || document.createEvent('event')
        event.initEvent name, false, true
        event

export default Util