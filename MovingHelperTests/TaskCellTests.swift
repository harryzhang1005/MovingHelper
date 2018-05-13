//
//  TaskCellTests.swift
//  MovingHelperTests
//
//  Created by Hongfei Zhang on 5/13/18.
//  Copyright © 2018 HappyGuy. All rights reserved.
//

import UIKit
import XCTest
import MovingHelper

class TaskCellTests: XCTestCase {
	
	func testCheckingCheckboxMarksTaskDone() {
		let cell = TaskTableViewCell()
		
		// 1. Create an expectation for which to wait. Since the delegate is a separate object from the test, you may not hit the success block immediately.
		let promise = expectation(description: "Task updated")
		
		// 2. Create an inline struct, you want this struct to tell you when the expection has been met
		struct TestDelegate: TaskUpdatedDelegate {
			let testPromise: XCTestExpectation
			let expectedDone: Bool
			
			init(updatedPromise: XCTestExpectation, expectedDoneStateAfterToggle: Bool) {
				testPromise = updatedPromise
				expectedDone = expectedDoneStateAfterToggle
			}
			
			func taskUpdated(task: Task) {
				XCTAssertEqual(expectedDone, task.done, "Task done state did not match expected!")
				testPromise.fulfill()
			}
		}
		
		// 3.x
		let testTask = Task(aTitle: "TestTask", aDueDate: .OneMonthAfter)
		XCTAssertFalse(testTask.done, "Newly created task is alread done!")
		cell.delegate = TestDelegate(updatedPromise: promise, expectedDoneStateAfterToggle: true)
		cell.configureForTask(task: testTask)
		
		// 4.x
		XCTAssertFalse(cell.checkbox.isChecked, "Checkbox checked for not-done task!")
		
		// 5. Fake a tap on the checkbox
		cell.checkbox.sendActions(for: .touchUpInside)
		
		// 6.x
		XCTAssertTrue(cell.checkbox.isChecked, "Checkbox not checked after tap!")
		
		waitForExpectations(timeout: 1, handler: nil)
	}
	
}
