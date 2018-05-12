//
//  StartOfDayNSDateExtension.swift
//  MovingHelper
//
//  Created by Ellen Shapiro on 6/20/15.
//  Copyright (c) 2015 Razeware. All rights reserved.
//

import Foundation

/**
A quick extension to save having to grab NSCalendar references everywhere.
*/
extension NSDate {
  
  /**
  The start of the day per NSCalendar rules for the receiver.
  */
  func startOfDay() -> NSDate {
	return NSCalendar.current.startOfDay(for: self as Date) as NSDate
  }
  
  /**
  The start of the current day per NSCalendar rules for the receiver.
  */
  static func startOfToday() -> NSDate {
    return NSDate().startOfDay()
  }
}
