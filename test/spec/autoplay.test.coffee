describe 'autoplay', ->
    beforeEach ->
        el = document.createElement 'div'
        el.innerHTML += "<div class='mc-carousel-element'></div>" for i in [0...10]
        document.body.appendChild el

        @carousel = new MarvinaCarousel {
            el
            autoPlay: true
        }    

    it 'should start autoplay', ->
        @carousel.autoPlayStatus = false
        @carousel.play()
        expect(@carousel.autoPlayStatus).toEqual true

    it 'should stop autoplay', ->
        @carousel.stop()
        expect(@carousel.autoPlayStatus).toEqual false

    it 'should toggle autoplay', ->
        status = @carousel.autoPlayStatus
        @carousel.toggle()
        expect(@carousel.autoPlayStatus).not.toEqual status 