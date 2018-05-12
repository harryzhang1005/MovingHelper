//
//  TaskSectionHeaderView.swift
//  MovingHelper
//
//  Created by Ellen Shapiro on 6/14/15.
//  Copyright (c) 2015 Razeware. All rights reserved.
//

import UIKit

/**
A section header view which shows when tasks are due and changes color
based on whether the due date has passed for the given move date.
*/
public class TaskSectionHeaderView: UITableViewCell {
  
  //MARK: Properties
  
  //Use a static date formatter since they are expensive to create.
  static let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
	formatter.dateStyle = DateFormatter.Style.short
    return formatter
    }()
  
  @IBOutlet var sectionNameLabel: UILabel!
  @IBOutlet var deadlineDateLabel: UILabel!
  @IBOutlet var fromNowOrAgoLabel: UILabel!
  
  //MARK: Configuration
  
  /**
  Configures the view based on the task due date and the user's move date.
  
  :param: dueDate  The due date for the current section
  :param: moveDate The user's move date.
  */
  func configureForDueDate(dueDate: TaskDueDate, moveDate: NSDate) {
    sectionNameLabel.text = dueDate.getTitle()
    
	let taskDueDate = dueDate.dueDateForMoveDate(moveDate: moveDate)
	deadlineDateLabel.text = TaskSectionHeaderView.dateFormatter.string(from: taskDueDate as Date)
    
	if dueDate.isOverdueForMoveDate(moveDate: moveDate) {
      backgroundColor = UIColor.red
    } else {
      backgroundColor = UIColor.green
    }
    
	fromNowOrAgoLabel.text = dueDate.daysFromDueDate(moveDate: moveDate)
  }
}
