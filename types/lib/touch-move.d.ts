import {MarvinaCarousel} from './marvina-carousel';

export declare class TouchMove {
	carousel: MarvinaCarousel;
	startX: number;
	time: number;
	
	constructor(carousel:MarvinaCarousel);
	start(e:Event): void;
	end(e:Event): void;
	destroy(): void;
}