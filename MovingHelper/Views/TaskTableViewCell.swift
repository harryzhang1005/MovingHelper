//
//  TaskTableViewCell.swift
//  MovingHelper
//
//  Created by Ellen Shapiro on 6/9/15.
//  Copyright (c) 2015 Razeware. All rights reserved.
//

import UIKit

public class TaskTableViewCell: UITableViewCell {
	
	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var notesLabel: UILabel!
	@IBOutlet public var checkbox: Checkbox!
	
	var currentTask: Task?
	public var delegate: TaskUpdatedDelegate?
	
	// Sinces cells are reused, clear the values of these variables before the cell is reused
	public override func prepareForReuse() {
		super.prepareForReuse()
		currentTask = nil
		delegate = nil
	}
	
	public func configureForTask(task: Task) {
		currentTask = task
		titleLabel.text = task.title
		notesLabel.text = task.notes
		configureForDoneState(done: task.done)
	}
	
	func configureForDoneState(done: Bool) {
		checkbox.isChecked = done
		if done {
			backgroundColor = .lightGray
			titleLabel.alpha = 0.5
			notesLabel.alpha = 0.5
		} else {
			backgroundColor = .white
			titleLabel.alpha = 1
			notesLabel.alpha = 1
		}
	}
	
	@IBAction func tappedCheckbox() {
		configureForDoneState(done: !checkbox.isChecked)
		
		//TODO: Actually mark task done
		if let task = currentTask {
			task.done = checkbox.isChecked
			delegate?.taskUpdated(task: task)
		}
	}
	
}
