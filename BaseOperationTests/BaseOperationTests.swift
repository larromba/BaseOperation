@testable import BaseOperation
import XCTest

final class BaseOperationTests: XCTestCase {
    // swiftlint:disable identifier_name lower_acl_than_parent
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

    func test_state_whenInitialized_expectReady() {
        // test
        XCTAssertEqual(operation.state, .ready)
    }

    func test_state_whenReady_expectConfiguration() {
        // sut
        operation.state = .ready

        // test
        XCTAssertTrue(operation.isReady)
        XCTAssertFalse(operation.isExecuting)
        XCTAssertFalse(operation.isFinished)
    }

    func test_state_whenExecuting_expectConfiguration() {
        // sut
        operation.state = .executing

        // test
        XCTAssertFalse(operation.isReady)
        XCTAssertTrue(operation.isExecuting)
        XCTAssertFalse(operation.isFinished)
    }

    func test_operation_whenCancelled_expectStateChangesToFinished() {
        // mocks
        operation._isCancelled = true
        XCTAssertNotEqual(operation.state, .finished)

        // sut
        operation.start()

        // test
        XCTAssertEqual(operation.state, .finished)
    }

    func test_operation_whenStarted_expectChangesStateToExecuting() {
        // sut
        operation.start()
        XCTAssertNotEqual(operation.state, .executing)

        // test
        XCTAssertEqual(operation.state, .executing)
        XCTAssertTrue(operation.isExecuteInvoked)
    }

    func test_operation_whenStarted_expectExecuteIsInvoked() {
        // sut
        operation.start()

        // test
        XCTAssertTrue(operation.isExecuteInvoked)
    }

    func test_state_whenExecuting_expectCorrectWillChangeValueForKey() {
        // sut
        operation.state = .executing

        // test
        XCTAssertEqual(operation.willChangeValueForKeyValue, "isExecuting")
    }

    func test_state_whenExecuting_expectCorrectDidChangeValueForKey() {
        // sut
        operation.state = .executing

        // test
        XCTAssertEqual(operation.didChangeValueForKeyValue, "isExecuting")
    }

    func test_state_whenFinished_expectCorrectWillChangeValueForKey() {
        // sut
        operation.state = .finished

        // test
        XCTAssertEqual(operation.willChangeValueForKeyValue, "isFinished")
    }

    func test_state_whenFinished_expectCorrectDidChangeValueForKey() {
        // sut
        operation.state = .finished

        // test
        XCTAssertEqual(operation.didChangeValueForKeyValue, "isFinished")
    }

    func test_state_whenReady_expectCorrectWillChangeValueForKey() {
        // sut
        operation.state = .ready

        // test
        XCTAssertNil(operation.willChangeValueForKeyValue)
    }

    func test_state_whenReady_expectCorrectDidChangeValueForKey() {
        // sut
        operation.state = .ready

        // test
        XCTAssertNil(operation.didChangeValueForKeyValue)
    }
}
