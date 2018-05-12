//
//  TaskSaver.swift
//  MovingHelper
//
//  Created by Ellen Shapiro on 6/15/15.
//  Copyright (c) 2015 Razeware. All rights reserved.
//

import Foundation

/*
Struct to save tasks to JSON.
*/
public struct TaskSaver {
  
  /*
  Writes a file to the given file name in the documents directory
  containing JSON storing the given tasks.
  
  :param: The tasks to write out.
  :param: The file name to use when writing out the file.
  */
  static func writeTasksToFile(tasks: [Task], fileName: FileName) {
	
    let dictionaries = tasks.map { $0.asJson() }
	
    let fullFilePath = fileName.jsonFileName().pathInDocumentsDirectory()
    if let jsonData = try? JSONSerialization.data(withJSONObject: dictionaries, options: .prettyPrinted) {
        (jsonData as NSData).write(toFile: fullFilePath, atomically: true)
    }
  }
  
  public static func nukeTaskFile(fileName: FileName) {
    let fullFilePath = fileName.jsonFileName().pathInDocumentsDirectory()
    try? FileManager.default.removeItem(atPath: fullFilePath)
  }
	
}
