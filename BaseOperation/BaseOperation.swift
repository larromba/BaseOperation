import Foundation

open class BaseOperation: Operation {
    enum State {
        case ready, executing, finished
    }
    private enum KVOKey: String {
        case isExecuting, isFinished
    }

    public override init() {
        super.init()
        assert(superclass != nil, "must be subclassed")
    }

    private var _state: State = .ready
    var state: State {
        get {
            return _state
        }
        set {
            guard _state != newValue else {
                return
            }

            let kvoKey: String
            switch newValue {
            case .ready:
                assertionFailure("not reusable")
                return
            case .executing:
                kvoKey = KVOKey.isExecuting.rawValue
            case .finished:
                kvoKey = KVOKey.isFinished.rawValue
            }

            willChangeValue(forKey: kvoKey)
            _state = newValue
            didChangeValue(forKey: kvoKey)
        }
    }

    public final override var isReady: Bool {
        return state == .ready
    }

    public final override var isExecuting: Bool {
        return state == .executing
    }

    public final override var isFinished: Bool {
        return state == .finished
    }

    public final override func start() {
        if isCancelled {
            state = .finished
        } else {
            state = .executing
            execute()
        }
    }

    open func execute() {
        assertionFailure("super should not be called")
    }

    public final func finish() {
        state = .finished
    }
}
