export interface Resize {
    (): void;
}

export interface SetCarouselAnimation {
    (): Promise<void>;
}

export interface AddElement {
    (el:HTMLElement, index:number): void
}

export interface RemoveElement {
    (index:number): void
}

export interface Grouping {
    resize: Resize;
    setCarouselAnimation: SetCarouselAnimation;
    addElement: AddElement;
    removeElement: RemoveElement;
}