import {MarvinaCarousel} from './marvina-carousel';

export declare class List {
    carousel: MarvinaCarousel;
	listEl: HTMLUListElement;
	asList: HTMLUListElement|HTMLOListElement;
	index: number;
	
	constructor(carousel:MarvinaCarousel, list:boolean, asList:HTMLUListElement|HTMLOListElement);
	setIndex(e:Event): void;
	setActive(): void;
	add(): void;
	remove(): void;
	destroy(): void;
}