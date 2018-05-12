//
//  MasterViewController.swift
//  MovingHelper
//
//  Created by Ellen Shapiro on 6/7/15.
//  Copyright (c) 2015 Razeware. All rights reserved.
//

import UIKit

//MARK: - Main view controller class
public class MasterViewController: UITableViewController {
	
	//MARK: Properties
	
	fileprivate var movingDate: NSDate?
	fileprivate var sections = [[Task]]()
	fileprivate var allTasks = [Task]() {
		didSet {
			sections = SectionSplitter.sectionsFromTasks(allTasks: allTasks)
		}
	}
	
	//MARK: View Lifecycle
	
	override public func viewDidLoad() {
		super.viewDidLoad()
		
		self.title = LocalizedStrings.taskListTitle
		
		movingDate = movingDateFromUserDefaults()
		if let storedTasks = TaskLoader.loadSavedTasksFromJSONFile(fileName: FileName.SavedTasks) {
			allTasks = storedTasks
		} //else case handled in view did appear
	}
	
	override public func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		if allTasks.count == 0 {
			showChooseMovingDateVC()
		} //else we're already good to go.
	}
	
	public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		if let identifier = segue.identifier {
			let segueIdentifier: SegueIdentifier = SegueIdentifier(rawValue: identifier)!
			switch segueIdentifier {
			case .ShowDetailVCSegue:
				if let indexPath = self.tableView.indexPathForSelectedRow {
					let task = taskForIndexPath(indexPath: indexPath as NSIndexPath)
					(segue.destination as! DetailViewController).detailTask = task
				}
				
			case .ShowMovingDateVCSegue:
				(segue.destination as! MovingDateViewController).delegate = self
			default:
				NSLog("Unhandled identifier \(identifier)")
				//Do nothing.
			}
		}
	}
	
	//MARK: Task Handling
	
	func addOrUpdateTask(task: Task) {
		let index = task.dueDate.getIndex()
		let dueDateTasks = sections[index]
		
		
		var tasksWithDifferentID = dueDateTasks.filter { $0.taskID != task.taskID }
		tasksWithDifferentID.append(task)
		tasksWithDifferentID.sort(by: { $0.taskID > $1.taskID })
		
		sections[index] = tasksWithDifferentID
		tableView.reloadData()
	}
	
	//MARK: IBActions
	
	@IBAction func calendarIconTapped() {
		showChooseMovingDateVC()
	}
	
	fileprivate func showChooseMovingDateVC() {
		performSegue(withIdentifier: SegueIdentifier.ShowMovingDateVCSegue.rawValue, sender: nil)
	}
	
	//MARK: File Writing
	
	fileprivate func saveTasksToFile() {
		TaskSaver.writeTasksToFile(tasks: allTasks, fileName: FileName.SavedTasks)
	}
	
	//MARK: Moving Date Handling
	
	fileprivate func movingDateFromUserDefaults() -> NSDate? {
		return UserDefaults.standard.value(forKey: UserDefaultKey.MovingDate.rawValue) as? NSDate
	}
}

//MARK: - Task Updated Delegate Extension

extension MasterViewController: TaskUpdatedDelegate {
  public func taskUpdated(task: Task) {
	addOrUpdateTask(task: task)
    saveTasksToFile()
  }
}

//MARK: - Moving Date Delegate Extension

extension MasterViewController: MovingDateDelegate {
  public func createdMovingTasks(tasks: [Task]) {
    allTasks = tasks
    saveTasksToFile()
  }
  
  public func updatedMovingDate() {
    movingDate = movingDateFromUserDefaults()
    tableView.reloadData()
  }
}

//MARK: - Table View Data Source Extension

extension MasterViewController {
  
  fileprivate func taskForIndexPath(indexPath: NSIndexPath) -> Task {
	let tasks = tasksForSection(section: indexPath.section)
    return tasks[indexPath.row]
  }
  
  private func tasksForSection(section: Int) -> [Task] {
    let currentSection = sections[section]
    return currentSection
  }
	
	override public func numberOfSections(in tableView: UITableView) -> Int {
		return sections.count
	}
	
	
  
	override public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 40
	}
	
	public override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		
		let header = tableView.dequeueReusableCell(withIdentifier: TaskSectionHeaderView.cellIdentifierFromClassName()) as! TaskSectionHeaderView
		let dueDate = TaskDueDate.fromIndex(index: section)
    
    if let moveDate = movingDate {
		header.configureForDueDate(dueDate: dueDate, moveDate: moveDate)
    }
    
    return header
  }
	
	
  
	override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let tasks = tasksForSection(section: section)
    return tasks.count
  }
	
	public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.cellIdentifierFromClassName(), for: indexPath) as! TaskTableViewCell
		let task = taskForIndexPath(indexPath: indexPath as NSIndexPath)
		cell.configureForTask(task: task)
    
    return cell
  }
	
}

