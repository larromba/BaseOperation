@testable import BaseOperation
import XCTest

final class BaseOperationTests: XCTestCase {
    private class Operation: BaseOperation {
        var isExecuteInvoked: Bool = false
        var willChangeValueForKeyValue: String?
        var didChangeValueForKeyValue: String?

        var _isCancelled = false
        override var isCancelled: Bool {
            return _isCancelled
        }

        override func execute() {
            isExecuteInvoked = true
        }
        override func willChangeValue(forKey key: String) {
            willChangeValueForKeyValue = key
        }
        override func didChangeValue(forKey key: String) {
            didChangeValueForKeyValue = key
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
        XCTAssertEqual(operation.willChangeValueForKeyValue, "isExecuting")
    }

    func testChangeStateExecutingCallsDidChangeValueForKey() {
        let operation = Operation()
        operation.state = .executing
        XCTAssertEqual(operation.didChangeValueForKeyValue, "isExecuting")
    }

    func testChangeStateFinishedCallsWillChangeValueForKey() {
        let operation = Operation()
        operation.state = .finished
        XCTAssertEqual(operation.willChangeValueForKeyValue, "isFinished")
    }

    func testChangeStateFinishedCallsDidChangeValueForKey() {
        let operation = Operation()
        operation.state = .finished
        XCTAssertEqual(operation.didChangeValueForKeyValue, "isFinished")
    }

    func testChangeSameStateDoesNotCallWillChangeValueForKey() {
        let operation = Operation()
        operation.state = .ready
        XCTAssertNil(operation.willChangeValueForKeyValue)
    }

    func testChangeSameStateDoesNotCallDidChangeValueForKey() {
        let operation = Operation()
        operation.state = .ready
        XCTAssertNil(operation.didChangeValueForKeyValue)
    }
}
