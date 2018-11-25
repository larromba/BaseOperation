import XCTest
@testable import BaseOperation

final class BaseOperationTests: XCTestCase {
    private class Operation: BaseOperation {
        var isExecuteInvoked: Bool = false
        override func execute() {
            isExecuteInvoked = true
        }
        var _isCancelled = false
        override var isCancelled: Bool {
            return _isCancelled
        }
        var _willChangeValueForKey: String?
        override func willChangeValue(forKey key: String) {
            _willChangeValueForKey = key
        }
        var _didChangeValueForKey: String?
        override func didChangeValue(forKey key: String) {
            _didChangeValueForKey = key
        }
    }

    func testInitState() {
        let operation = Operation()
        XCTAssertEqual(operation.state, .ready)
    }

    func testIsReady() {
        let operation = Operation()
        operation.state = .ready
        XCTAssertTrue(operation.isReady)
        XCTAssertFalse(operation.isExecuting)
        XCTAssertFalse(operation.isFinished)
    }

    func testIsExecuting() {
        let operation = Operation()
        operation.state = .executing
        XCTAssertFalse(operation.isReady)
        XCTAssertTrue(operation.isExecuting)
        XCTAssertFalse(operation.isFinished)
    }

    func testStartWhenIsCancelledChangesStateToFinished() {
        let operation = Operation()
        operation._isCancelled = true
        operation.start()
        XCTAssertEqual(operation.state, .finished)
    }

    func testStartWhenIsNotCancelledChangesStateToExecutingAndExecutes() {
        let operation = Operation()
        operation.start()
        XCTAssertEqual(operation.state, .executing)
        XCTAssertTrue(operation.isExecuteInvoked)
    }

    func testChangeStateExecutingCallsWillChangeValueForKey() {
        let operation = Operation()
        operation.state = .executing
        XCTAssertEqual(operation._willChangeValueForKey, "isExecuting")
    }

    func testChangeStateExecutingCallsDidChangeValueForKey() {
        let operation = Operation()
        operation.state = .executing
        XCTAssertEqual(operation._didChangeValueForKey, "isExecuting")
    }

    func testChangeStateFinishedCallsWillChangeValueForKey() {
        let operation = Operation()
        operation.state = .finished
        XCTAssertEqual(operation._willChangeValueForKey, "isFinished")
    }

    func testChangeStateFinishedCallsDidChangeValueForKey() {
        let operation = Operation()
        operation.state = .finished
        XCTAssertEqual(operation._didChangeValueForKey, "isFinished")
    }

    func testChangeSameStateDoesNotCallWillChangeValueForKey() {
        let operation = Operation()
        operation.state = .ready
        XCTAssertNil(operation._willChangeValueForKey)
    }

    func testChangeSameStateDoesNotCallDidChangeValueForKey() {
        let operation = Operation()
        operation.state = .ready
        XCTAssertNil(operation._didChangeValueForKey)
    }
}
