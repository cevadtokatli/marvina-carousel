describe 'accessors', ->
    beforeEach ->
        el = document.createElement 'div'
        el.style.width = "1140px"
        el.innerHTML += '<div class="mc-carousel-element"></div>' for i in [0...10]
        document.body.appendChild el

        @timing = 'ease-in-out'
        @duration = 650
        @autoPlaySpeed = 3000
        @carousel = new MarvinaCarousel {
            el
            minImage: 1
            maxImage: 3
            minWidth: 500
            maxWidth: 1500
            timing: @timing
            duration: @duration
            autoPlaySpeed: @autoPlaySpeed
        }        

    describe 'index', ->
        it 'getter', ->
            index = @carousel.getIndex()
            expectedIndex = 0
            expect(index).toEqual expectedIndex

        it 'setter', ->
            val = 3
            await @carousel.setIndex val
            index = @carousel.getIndex()
            expect(index).toEqual val

    describe 'total', ->
        it 'getter', ->
            total = @carousel.getTotal()
            expectedTotal = 10
            expect(total).toEqual expectedTotal

    describe 'totalIndex', ->
        it 'getter', ->
            totalIndex = @carousel.getTotalIndex()
            expectedTotalIndex = 5
            expect(totalIndex).toEqual expectedTotalIndex

    describe 'timing', ->
        it 'getter', ->
            timing = @carousel.getTiming()
            expect(timing).toEqual @timing

        it 'setter', ->
            val = 'linear'
            @carousel.setTiming val
            timing = @carousel.getTiming()
            expect(timing).toEqual val

    describe 'duration', ->
        it 'getter', ->
            duration = @carousel.getDuration()
            expect(duration).toEqual @duration

        it 'setter', ->
            val = 1200
            @carousel.setDuration val
            duration = @carousel.getDuration()
            expect(duration).toEqual val

    describe 'autoPlaySpeed', ->
        it 'getter', ->
            autoPlaySpeed = @carousel.getAutoPlaySpeed()
            expect(autoPlaySpeed).toEqual @autoPlaySpeed

        it 'setter', ->
            val = 4500
            @carousel.setAutoPlaySpeed val
            autoPlaySpeed = @carousel.getAutoPlaySpeed()
            expect(autoPlaySpeed).toEqual val