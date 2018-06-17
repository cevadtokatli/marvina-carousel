import {MarvinaCarousel} from './marvina-carousel';

export interface ArrowElements {
    prevArrow?: HTMLElement;
    nextArrow?: HTMLElement;
}

export declare class Arrows {
	carousel: MarvinaCarousel;
	arrowEls: ArrowElements;
	asArrows: ArrowElements;
	
	prev: () => Promise<void>;
	next: () => Promise<void>;

	constructor(carousel:MarvinaCarousel, arrows:boolean, asArrows:ArrowElements);
	destroy(): void;
}