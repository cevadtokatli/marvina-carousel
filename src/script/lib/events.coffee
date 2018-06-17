import Util from '../helper/util'

export default {
    change: Util.createEvent 'change'
    totalIndex: Util.createEvent 'totalIndex'
    touchStart: Util.createEvent 'touchStart'
    touchEnd: Util.createEvent 'touchEnd'
    play: Util.createEvent 'play'
    stop: Util.createEvent 'stop'
    destroy: Util.createEvent 'destroy'
}