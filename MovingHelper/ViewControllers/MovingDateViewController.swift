//
//  MovingDateViewController.swift
//  MovingHelper
//
//  Created by Ellen Shapiro on 6/7/15.
//  Copyright (c) 2015 Razeware. All rights reserved.
//

import UIKit

public protocol MovingDateDelegate {
  func createdMovingTasks(tasks: [Task])
  func updatedMovingDate()
}

/**
VC to use to select a moving date.
*/
class MovingDateViewController: UIViewController {
  
  @IBOutlet weak var whenMovingDatePicker: UIDatePicker!
  @IBOutlet weak var whenMovingLabel: UILabel!
  @IBOutlet weak var daysLeftLabel: UILabel!
  @IBOutlet weak var createTasksButton: UIButton!
  var updatingDate = false
  var delegate: MovingDateDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //Localize strings
    whenMovingLabel.text = LocalizedStrings.whenMovingTitle
    
	whenMovingDatePicker.minimumDate = NSDate.startOfToday() as Date
    
	if let movingDate = UserDefaults.standard.object(forKey: UserDefaultKey.MovingDate.rawValue) as? NSDate {
		whenMovingDatePicker.date = movingDate as Date
      createTasksButton.setTitle(LocalizedStrings.updateDate, for: .normal)
    } else {
		whenMovingDatePicker.date = twoMonthsFromToday() as Date
      createTasksButton.setTitle(LocalizedStrings.createTasks, for: .normal)
    }
    
    datePickerChanged()
  }
  
  //MARK: Date helpers
  
  func twoMonthsFromToday() -> NSDate {
    let currentCalendar = NSCalendar.current
    
    let today = NSDate.startOfToday()
    let twoMonths = NSDateComponents()
    twoMonths.month = 2
	let updatedDate = currentCalendar.date(byAdding: twoMonths as DateComponents, to: today as Date)
	
	return updatedDate! as NSDate
  }
  
  //MARK: IBActions
  
  @IBAction func datePickerChanged() {
	
    let updatedDate = (whenMovingDatePicker.date as NSDate).startOfDay()
    let today = NSDate.startOfToday()
	
    let components = NSCalendar.current.dateComponents([.day], from: today as Date, to: updatedDate as Date)
    
	daysLeftLabel.text = NSString(format: LocalizedStrings.daysLeftFormat as NSString, components.day!) as String
  }
  
  @IBAction func createTasks() {
    let updatedDate = (whenMovingDatePicker.date as NSDate).startOfDay()
    
    if !updatingDate {
      //If we're not updating the date, this is a new set of tasks and we should load the stock task.
      let tasks = TaskLoader.loadStockTasks()
		delegate?.createdMovingTasks(tasks: tasks)
    }
    
    //In any case, we should update the moving date and notify the delegate it was updated.
	UserDefaults.standard.set(updatedDate, forKey: UserDefaultKey.MovingDate.rawValue)
    UserDefaults.standard.synchronize()
    delegate?.updatedMovingDate()
    
	dismiss(animated: true, completion: nil)
  }
}
