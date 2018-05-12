//
//  Task.swift
//  MovingHelper
//
//  Created by Ellen Shapiro on 6/7/15.
//  Copyright (c) 2015 Razeware. All rights reserved.
//

import Foundation

//MARK: Equatable

public func == (lhs: Task, rhs: Task) -> Bool {
  return lhs.taskID == rhs.taskID
}

/**
The main representation of a moving task.
*/
public class Task: CustomStringConvertible, Equatable {
  
  //MARK: Constants
  
  
  //MARK: Property variables
  
  public var taskID: Int
  public var title: String
  public var notes: String?
  public var dueDate: TaskDueDate
  public var done: Bool = false
  
  // MARK: CustomStringConvertible
  public var description: String {
    return "\(title)"
  }
  
  //MARK: Initializers
  
  /**
  Initializes a task with required values
  
  :param: aTitle   The title of the task
  :param: aDueDate The due date of the task
  
  :returns: The created task with an assigned ID
  */
  public init(aTitle: String, aDueDate: TaskDueDate) {
    title = aTitle
    dueDate = aDueDate
    taskID = Task.nextIdentifier()
  }
  
  /**
  Initializes a task from JSON.
  
  :param: fromJSON The NSDictionary with the data regarding the task.
  
  :returns: The instantiated task object.
  */
  public init(fromJSON: NSDictionary) {
	title = fromJSON.safeString(key: TaskJSONKey.Title.rawValue)
    
	let dueDateString = fromJSON.safeString(key: TaskJSONKey.DueDate.rawValue)
    if let enumDueDate = TaskDueDate(rawValue: dueDateString) {
      dueDate = enumDueDate
    } else {
      dueDate = TaskDueDate.OneDayBefore
    }
    
	let fromJSONNotes = fromJSON.safeString(key: TaskJSONKey.Notes.rawValue)
	if fromJSONNotes.lengthOfBytes(using: String.Encoding.utf8) > 0 {
      notes = fromJSONNotes
    }
    
	done = fromJSON.safeBoolean(key: TaskJSONKey.Done.rawValue)
	taskID = fromJSON.safeInt(key: TaskJSONKey.TaskID.rawValue)
    
    if taskID == 0 {
      taskID = Task.nextIdentifier()
    }
  }
  
  
  static func tasksFromArrayOfJSONDictionaries(arrayOfDictionaries: [NSDictionary]) -> [Task] {
    var tasks = [Task]()
    for dict in arrayOfDictionaries {
      tasks.append(Task(fromJSON: dict))
    }
    
    return tasks
  }
  
  //MARK: Identifier generation
  
  /**
  :returns: The next sequential identifier so all task identifiers are unique.
  */
  private static func nextIdentifier() -> Int {
    let defaults = UserDefaults.standard
    let lastIdentifier = defaults.integer(forKey: UserDefaultKey.LastAddedTaskID.rawValue)
    let nextIdentifier = lastIdentifier + 1
    
    defaults.set(nextIdentifier, forKey:UserDefaultKey.LastAddedTaskID.rawValue)
    defaults.synchronize()
    
    return nextIdentifier
  }
  
  //MARK: JSON generation
  
  public func asJson() -> NSDictionary {
    var dict = [String: AnyObject]()
    
	dict.updateValue(taskID as AnyObject, forKey: TaskJSONKey.TaskID.rawValue)
	dict.updateValue(title as AnyObject, forKey: TaskJSONKey.Title.rawValue)
    
    if let notes = notes {
		dict.updateValue(notes as AnyObject, forKey: TaskJSONKey.Notes.rawValue)
    }
    
	dict.updateValue(dueDate.rawValue as AnyObject, forKey: TaskJSONKey.DueDate.rawValue)
	dict.updateValue(NSNumber(value: done), forKey: TaskJSONKey.Done.rawValue)
    
    return dict as NSDictionary
  }
}
