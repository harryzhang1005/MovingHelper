//
//  TaskLoader.swift
//  MovingHelper
//
//  Created by Ellen Shapiro on 6/7/15.
//  Copyright (c) 2015 Razeware. All rights reserved.
//

import UIKit

/*
Struct to load tasks from JSON.
*/
public struct TaskLoader {
  
  static func loadSavedTasksFromJSONFile(fileName: FileName) -> [Task]? {
    let path = fileName.jsonFileName().pathInDocumentsDirectory()
    if let data = NSData(contentsOfFile: path) {
		return tasksFromData(data: data)
    } else {
      return nil
    }
  }
  
  
  /**
  :returns: The stock moving tasks included with the app.
  */
  public static func loadStockTasks() -> [Task] {
    if let path = Bundle.main.path(forResource: FileName.StockTasks.rawValue, ofType: "json"),
      let data = NSData(contentsOfFile: path),
		let tasks = tasksFromData(data: data) {
        return tasks
    }
    
    //Fall through case
    NSLog("Tasks did not load!")
    return [Task]()
  }
  
  private static func tasksFromData(data: NSData) -> [Task]? {
	
	let result = try? JSONSerialization.jsonObject(with: data as Data, options: .allowFragments)
	
	if let arrayOfTaskDictionaries = result as? [NSDictionary] {
		return Task.tasksFromArrayOfJSONDictionaries(arrayOfDictionaries: arrayOfTaskDictionaries)
    } else {
      NSLog("Error loading data: ")
      return nil
    }
  }
	
}
