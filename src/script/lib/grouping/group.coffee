import Util from '../../helper/Util'

export default class Group
    # @params {Boolean} skip
    @resize: (skip=false) ->
        iterator = @resizeIterator arguments...

        $ = iterator.next()
        if $.done
            return
        else
            $ = $.value

        @Group.setTotalIndex.call @, $.imageCount
    
        wrappers = @container.querySelectorAll '.mc-wrapper'
        for i in [0..@totalIndex-1]
            unless wrapper = wrappers[i]
                wrapper = document.createElement 'div'
                wrapper.classList.add 'mc-wrapper'
                wrapper.style.marginRight = "#{@space}px"
                @container.appendChild wrapper
            else
                spaceElements = wrapper.querySelectorAll '.mc-carousel-space-element'
                for s in spaceElements
                    wrapper.removeChild s

            r = i * $.imageCount
            for n in [r..r+$.imageCount-1]
                if e = @elements[n]
                    wrapper.appendChild e
                else
                    s = document.createElement 'div'
                    s.className = 'mc-carousel-element mc-carousel-space-element'
                    s.style.marginRight = "#{@space}px"
                    wrapper.appendChild s

        wrappers = @container.querySelectorAll '.mc-wrapper'
        if wrappers.length > @totalIndex
            for i in [@totalIndex..wrappers.length-1] 
                @container.removeChild wrappers[i]

        for e in @elements
            e.style.width = "#{@width}px"
        spaceElements = @container.querySelectorAll '.mc-wrapper > .mc-carousel-space-element'
        for s in spaceElements
            s.style.width = "#{@width}px"
            
        iterator.next()

    # @returns {Promise<void>}
    @setCarouselAnimation: ->
        new Promise (resolve) =>
            iterator = @setCarouselAnimationIterator arguments...
            $ = iterator.next().value

            if $.reverse
                if $.reverseNext
                    beforeAnmCalc = 0
                    afterAnmCalc = @elWidth + @space
                else
                    beforeAnmCalc = @elWidth + @space
                    afterAnmCalc = 0
            else
                beforeAnmCalc = ($.i * @elWidth) + ($.i * @space)
                afterAnmCalc = (@index * @elWidth) + (@index * @space)

            
            await new Promise (resolve) =>
                requestAnimationFrame =>
                    if $.reverse
                        wrappers = @container.querySelectorAll '.mc-wrapper'
                        @container.insertBefore wrappers[@totalIndex-1], wrappers[0]
                    @container.setAttribute 'style', Util.setCSSPrefix("transform:translateX(-#{beforeAnmCalc}px)")

                    requestAnimationFrame =>
                        @container.setAttribute 'style', [@applyTransition(), Util.setCSSPrefix("transform:translateX(-#{afterAnmCalc}px)")].join('')

                        Util.addMultiEventListenerOnce @container, Util.transitionEndEvents, =>
                            if $.reverse
                                @container.appendChild wrappers[@totalIndex-1]

                            @container.setAttribute 'style', Util.setCSSPrefix("transform:translateX(-#{(@index * @elWidth) + (@index * @space)}px)")
                            resolve()

            iterator.next()
            resolve()

    # @params {HTMLElement} el
    # @params {Number} index
    @addElement: (el, index) ->
        iterator = @addElementIterator arguments...
        iterator.next()
        
        el.style.maxWidth = "#{@maxWidth}px" if @maxWidth
        @container.querySelector('.mc-wrapper').appendChild el

        iterator.next()

    # @params {Number} index
    @removeElement: (index) ->
        iterator = @removeElementIterator arguments...
        iterator.next()
        iterator.next()

    # Sets total index.
    # @params {Number} imageCount
    @setTotalIndex: (imageCount) ->
        totalIndex = Math.ceil @total / imageCount

        unless @totalIndex == totalIndex
            @totalIndex = totalIndex
            @index = 0
            @container.setAttribute 'style', Util.setCSSPrefix("transform:translateX(0)")
        else
            @container.setAttribute 'style', Util.setCSSPrefix("transform:translateX(#{((@index * @elWidth) + (@index * @space)) * -1}px)")
