describe 'resize', ->
    beforeAll ->
        el = document.createElement 'div'
        el.style.width = "1140px"
        el.innerHTML += '<div class="mc-carousel-element"></div>' for i in [0...10]
        document.body.appendChild el

        @minWidth = 120
        @maxWidth = 600
        @carousel = new MarvinaCarousel {
            el
            minImage: 3
            maxImage: 5
            minWidth: @minWidth
            maxWidth: @maxWidth
            height: 60
        }

    it 'should set keep the width between min and max width', ->
        width = @carousel.elements[0].offsetWidth
        expect(width).toBeGreaterThanOrEqual @minWidth
        expect(width).toBeLessThanOrEqual @maxWidth

    it 'should set the height by ratio', ->
        height = @carousel.carouselEl.offsetHeight
        expectedHeight = 137
        expect(height).toEqual expectedHeight