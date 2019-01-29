import Util from '../../helper/Util'

export default class Solo
    @resize: ->
        iterator = @resizeIterator arguments...

        $ = iterator.next()
        if $.done
            return
        else
            $ = $.value

        if (count = $.imageCount - 1) > 0
            for c in [0..count-1]
                unless @cloneElements[c]
                    e = @elements[c].cloneNode true
                    e.classList.add 'mc-carousel-clone-element'
                    @container.appendChild e
                    @cloneElements.push e

        if @cloneElements.length > count
            for c in [@cloneElements.length-1..count]
                @container.removeChild @cloneElements[c]
                @cloneElements.splice c, 1

        for e in @elements
            e.style.width = "#{@width}px"
        for e in @cloneElements
            e.style.width = "#{@width}px"
        @container.setAttribute 'style', Util.setCSSPrefix("transform:translateX(-#{(@index * @width) + (@index * @space)}px)")

        iterator.next()

    # @returns {Promise<void>}
    @setCarouselAnimation: ->
        new Promise (resolve) =>
            iterator = @setCarouselAnimationIterator arguments...
            $ = iterator.next().value

            if $.reverse
                if $.reverseNext
                    beforeAnmCalc = 0
                    afterAnmCalc = @width + @space
                else
                    beforeAnmCalc = @width + @space
                    afterAnmCalc = 0
            else
                beforeAnmCalc = ($.i * @width) + ($.i * @space)
                afterAnmCalc = (@index * @width) + (@index * @space)
          
            await new Promise (resolve) =>
                requestAnimationFrame =>
                    if $.reverse
                        @container.insertBefore @elements[@totalIndex-1], @elements[0]
                    @container.setAttribute 'style', Util.setCSSPrefix("transform:translateX(-#{beforeAnmCalc}px)")      
                    
                    requestAnimationFrame =>
                        @container.setAttribute 'style', [@applyTransition(), Util.setCSSPrefix("transform:translateX(-#{afterAnmCalc}px)")].join('')

                        Util.addMultiEventListenerOnce @container, Util.transitionEndEvents, =>
                            if $.reverse
                                if @cloneElements.length > 0
                                    @container.insertBefore @elements[@totalIndex-1], @cloneElements[0]
                                else
                                    @container.appendChild @elements[@totalIndex-1]

                            @container.setAttribute 'style', Util.setCSSPrefix("transform:translateX(-#{(@index * @width) + (@index * @space)}px)")
                            resolve()

            iterator.next()
            resolve()

    # @params {HTMLElement} el
    # @params {Number} index
    @addElement: (el, index) ->
        iterator = @addElementIterator arguments...
        iterator.next()

        if index < @total
            @container.insertBefore el, @elements[index]
        else
            @container.appendChild el
            
        @totalIndex += 1
        if @list
            @list.add()

        @Group.removeCloneElements.call @

        iterator.next()

    # @params {Number} index
    @removeElement: (index) ->
        iterator = @removeElementIterator arguments...
        iterator.next()

        if index <= @index && @index != 0
            @index -= 1
            if @list
                @list.index = @index

        @totalIndex -= 1
        if @list
            @list.remove()

        @Group.removeCloneElements.call @
        
        iterator.next()

    # Removes the cloned elements.
    @removeCloneElements: ->
        for c in @cloneElements
            @container.removeChild c
        @cloneElements = []