describe 'arrows', ->
    beforeEach ->
        el = document.createElement 'div'
        el.style.width = "1140px"
        el.innerHTML += '<div class="mc-carousel-element"></div>' for i in [0...10]
        document.body.appendChild el

        @carousel = new MarvinaCarousel {
            el
        }

    it 'should set the previous element\'s index as the current index', ->
        await @carousel.prev()
        index = @carousel.getIndex()
        expectedIndex = @carousel.getTotalIndex() - 1
        expect(index).toEqual expectedIndex

    it 'should set the next element\'s index as the current index', ->
        await @carousel.next()
        index = @carousel.getIndex()
        expectedIndex = 1
        expect(index).toEqual expectedIndex