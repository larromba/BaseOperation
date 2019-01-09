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

    private var operation: Operation!

    override func setUp() {
        super.setUp()
        operation = Operation()
    }

    override func tearDown() {
        operation = nil
        super.tearDown()
    }

    func testInitState() {
        // test
        XCTAssertEqual(operation.state, .ready)
    }

    func testIsReady() {
        // sut
        operation.state = .ready

        // test
        XCTAssertTrue(operation.isReady)
        XCTAssertFalse(operation.isExecuting)
        XCTAssertFalse(operation.isFinished)
    }

    func testIsExecuting() {
        // sut
        operation.state = .executing

        // test
        XCTAssertFalse(operation.isReady)
        XCTAssertTrue(operation.isExecuting)
        XCTAssertFalse(operation.isFinished)
    }

    func testStartWhenIsCancelledChangesStateToFinished() {
        // mocks
        operation._isCancelled = true

        // sut
        operation.start()

        // test
        XCTAssertEqual(operation.state, .finished)
    }

    func testStartWhenIsNotCancelledChangesStateToExecutingAndExecutes() {
        // sut
        operation.start()

        // test
        XCTAssertEqual(operation.state, .executing)
        XCTAssertTrue(operation.isExecuteInvoked)
    }

    func testChangeStateExecutingCallsWillChangeValueForKey() {
        // sut
        operation.state = .executing

        // test
        XCTAssertEqual(operation.willChangeValueForKeyValue, "isExecuting")
    }

    func testChangeStateExecutingCallsDidChangeValueForKey() {
        // sut
        operation.state = .executing

        // test
        XCTAssertEqual(operation.didChangeValueForKeyValue, "isExecuting")
    }

    func testChangeStateFinishedCallsWillChangeValueForKey() {
        // sut
        operation.state = .finished

        // test
        XCTAssertEqual(operation.willChangeValueForKeyValue, "isFinished")
    }

    func testChangeStateFinishedCallsDidChangeValueForKey() {
        // sut
        operation.state = .finished

        // test
        XCTAssertEqual(operation.didChangeValueForKeyValue, "isFinished")
    }

    func testChangeSameStateDoesNotCallWillChangeValueForKey() {
        // sut
        operation.state = .ready

        // test
        XCTAssertNil(operation.willChangeValueForKeyValue)
    }

    func testChangeSameStateDoesNotCallDidChangeValueForKey() {
        // sut
        operation.state = .ready

        // test
        XCTAssertNil(operation.didChangeValueForKeyValue)
    }
}
