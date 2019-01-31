export interface Options {
    el: string|HTMLElement;
    timing?: string;
    duration?: number;
    group?: boolean;
    minImage?: number;
    maxImage?: number;
    minWidth?: number;
    maxWidth?: number;
    height?: number;
	space?: number;
    touchMove?: boolean;
    list?: boolean;
    asList?: string|HTMLUListElement|HTMLOListElement;
    arrows?: boolean;
    asPrevArrow?: string|HTMLElement;
    asNextArrow?: string|HTMLElement;
    autoPlay?: boolean;
    autoPlaySpeed?: number;
    init?: boolean;
}