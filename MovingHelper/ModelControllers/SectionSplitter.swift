//
//  SectionSplitter.swift
//  MovingHelper
//
//  Created by Ellen Shapiro on 6/9/15.
//  Copyright (c) 2015 Razeware. All rights reserved.
//

import Foundation

/*
Helper struct to split up the array of tasks into sections based on the due date of each task.
*/
struct SectionSplitter {
  
  private static func tasksForDueDate(dueDate: TaskDueDate, allTasks: [Task]) -> [Task] {
    var tasks = allTasks.filter {
      task in
      return task.dueDate == dueDate
    }
    
	tasks.sort(by: { $0.taskID > $1.taskID })
    return tasks
  }
  
  static func sectionsFromTasks(allTasks: [Task]) -> [[Task]] {
	let oneMonthBefore = tasksForDueDate(dueDate: .OneMonthBefore, allTasks: allTasks)
	let oneWeekBefore = tasksForDueDate(dueDate: .OneWeekBefore, allTasks: allTasks)
	let oneDayBefore = tasksForDueDate(dueDate: .OneDayBefore, allTasks: allTasks)
	let oneDayAfter = tasksForDueDate(dueDate: .OneDayAfter, allTasks: allTasks)
	let oneWeekAfter = tasksForDueDate(dueDate: .OneWeekAfter, allTasks: allTasks)
	let oneMonthAfter = tasksForDueDate(dueDate: .OneMonthAfter, allTasks: allTasks)
    
    return [oneMonthBefore, oneWeekBefore, oneDayBefore, oneDayAfter, oneWeekAfter, oneMonthAfter]
  }
}
