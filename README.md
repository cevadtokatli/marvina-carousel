# Marvina Carousel
Image Carousel for web and mobile browsers.\
For more information you can take a look at the demos: [Demo 1](https://cevadtokatli.github.io/marvina-carousel/demo-1.html), [Demo 2](https://cevadtokatli.github.io/marvina-carousel/demo-2.html), [Demo 3](https://cevadtokatli.github.io/marvina-carousel/demo-3.html).

## NPM
``` 
npm install --save marvina-carousel 
```

## Installation
You can simply import `Carousel` class and create a new object with it.
```
import Carousel from 'marvina-carousel';

const carousel = new Carousel({
    el: '#carousel'
});
```

You can also add the script file into your html.
```
<script src="/node_modules/marvina-carousel/dist/js/marvina-carousel.min.js"></script>
<script>
var carousel = new MarvinaCarousel({
    el: '#carousel'
});
</script>
```

Add the css file.
```
<link rel="stylesheet" href="/node_modules/marvina-carousel/dist/css/marvina-carousel.min.css" />
```

Insert carousel elements into the container element.
```
<div id="carousel">
    <div class="mc-carousel-element">Image-1</div>
    <div class="mc-carousel-element">Image-2</div>
    <div class="mc-carousel-element">Image-3</div>
</div>
```

## Configuration
### Options
Option | Type | Default | Description
------ | ---- | ------- | -----------
el | string \| HTMLElement* | null | Container element.
timing | string | "ease" | Specifies the speed curve of an animation. Takes all the values CSS3 can take. *(like ease, linear, cubic-bezier, step)*
duration | number | 800 | Defines how long an animation should take to complete one cycle. *(as milliseconds)*
group | boolean | true | Specifies grouping type of the carousel elements.
minImage | number | 1 | Minimum carousel element number that the carousel displays at once.
maxImage | number | 1 | Maximum carousel element number that the carousel displays at once.
minWidth | number | null | Specifies min width of an carousel element. *(as pixel)*
maxWidth | number | null | Specifies max width of an carousel element. *(as pixel)*
height | number | null | Sets height value according to width. *(as percent)*
space | number | 0 | Specifies the space between the carousel elements. *(as pixel)*
touchMove | boolean | true | Enables slide transitive with touch.
list | boolean | true | Displays a list at the bottom of the carousel.
[asList](#as-list) | string \| HTMLUListElement \| HTMLOListElement* | null | Declares the given list as the carousel list.
arrows | boolean | true | Displays right and left arrows to change the index.
asPrevArrow | string \| HTMLElement* | null | Declares the given element as the prev arrow.
asNextArrow | string \| HTMLElement* | null | Declares the given element as the next arrow.
autoPlay | boolean | false | Enables auto play of slides.
autoPlaySpeed | number | 5000 | Sets auto play interval. *(as milliseconds)*

<span style="font-size:.9rem;">*: You can give an HTML element or a CSS selector (like `#carousel`, `.container > div:first-child`)</span>

#### As List
You can convert an HTML list element to a carousel list that shows the current index and works as a pager. 
* It can be a `ul` or `ol` element.
* It can be placed anywhere in the `body`.
* List is updated when the current index is changed.
* Assigns `mc-active` class to list element that holds the current index.
```
// html
<div id="carousel">
    <div class="mc-carousel-element">Image-1</div>
    <div class="mc-carousel-element">Image-2</div>
    <div class="mc-carousel-element">Image-3</div>
</div>
<ul id="list">
    <li>1</li>
    <li>2</li>
    <li>3</li>
</ul>

// script
var carousel = new MarvinaCarousel({
    el: '#carousel',
    list: false,
    asList: '#list'
});
```

### Events
Event | Description
----- | -----------
change | Fires when index changes.
totalIndex | Fires when total number of indexes change.
touchStart | Fires when touching starts.
touchEnd | Fires when touching ends.
play | Fires when autoplay starts.
stop | Fires when autoplay stops.
destroy | Fires when the carousel is destroyed.
```
import Carousel from 'marvina-carousel';

const carousel = new Carousel({
    el: '#carousel'
});

carousel.el.addEventListener('touchStart', () => {
    console.log('touching starts');
});

carousel.el.addEventListener('touchEnd', () => {
    console.log('touching ends');
});
```

### Methods
Method | Params | Return | Description
------ | ------ | ------ | -----------
add | el: string \| HTMLElement* <br /> index: number | void | Adds a new element to the carousel.
addFirst | el: string \| HTMLElement* | void | Adds a new element to the head of the carousel.
addLast | el: string \| HTMLElement* | void | Adds a new element to the last of the carousel.
remove | index: number | void | Removes the element at the specified index from the carousel.
removeFirst | | void | Removes the first element from the carousel.
removeLast | | void | Removes the last element from the carousel. 
prev | | Promise\<boolean> | Triggers previous image. Returns `false` if the carousel is in animation.
next | | Promise\<boolean> | Triggers next image. Returns `false` if the carousel is in animation.
play | | void | Starts autoplay.
stop | | void | Stops autoplay.
toggle | | void | Toggles autoplay.
destroy | | void | Destroys the carousel.
getIndex | | number | Returns index.
setIndex | index: number | Promise\<boolean> | Sets index and animates the carousel. Returns `false` if the carousel is in animation.
getTotal | | number | Returns total number of carousel elements.
getTotalIndex | | number | Returns total index.
getTiming | | string | Returns timing value.
setTiming | timing: string | void | Sets timing value.
getDuration | | number | Returns duration.
setDuration | duration: number | void | Sets duration.
getAutoPlaySpeed | | number | Returns auto play speed.
setAutoPlaySpeed | speed: number | void | Sets auto play speed.

<span style="font-size:.9rem;">*: You can give an HTML element or a CSS selector (like `#carousel`, `.container > div:first-child`)</span>

## IE Support
IE 10 is not supported and patches to fix problems will not be accepted.

## License
Marvina Carousel is provided under the [MIT License](https://opensource.org/licenses/MIT).