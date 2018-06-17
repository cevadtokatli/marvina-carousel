describe 'elements', ->
    beforeEach ->
        el = document.createElement 'div'
        el.innerHTML += "<div id='#{i}' class='mc-carousel-element'></div>" for i in [0...10]
        document.body.appendChild el

        @carousel = new MarvinaCarousel {
            el
            group: false
        }

    describe 'add', ->
        beforeEach ->
            @newEl = document.createElement 'div'
    
        it 'should add a new element to the head of the carousel', ->
            @carousel.addFirst @newEl
            expect(@carousel.getTotal()).toEqual 11
            expect(@carousel.elements[0]).toEqual @newEl

        it 'should add a new element to index "5"', ->
            @carousel.add @newEl, 5
            expect(@carousel.getTotal()).toEqual 11
            expect(@carousel.elements[5]).toEqual @newEl

        it 'should add a new element to the last of the carousel', ->
            @carousel.addLast @newEl
            expect(@carousel.getTotal()).toEqual 11
            expect(@carousel.elements[10]).toEqual @newEl

    describe 'remove', ->
        it 'should remove the first element from the carousel', ->
            el = @carousel.elements[0]
            @carousel.removeFirst()
            expect(@carousel.getTotal()).toEqual 9
            expect(@carousel.elements).not.toContain el

        it 'should remove the "5th" element from the caroucal', ->
            el = @carousel.elements[5]
            @carousel.remove 5
            expect(@carousel.getTotal()).toEqual 9
            expect(@carousel.elements).not.toContain el

        it 'should remove the last element from the carousel', ->
            el = @carousel.elements[@carousel.getTotal()-1]
            @carousel.removeLast()
            expect(@carousel.getTotal()).toEqual 9
            expect(@carousel.elements).not.toContain el