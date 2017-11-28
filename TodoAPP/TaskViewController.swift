//
//  TaskViewController.swift
//  TodoAPP
//
//  Created by David Auger on 11/20/17.
//  Copyright © 2017 David Auger. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TaskModelProtocol
{
    @IBOutlet weak var task_table_view: UITableView!
    
    var current_user: String = String()
    let task_model: TaskModel = TaskModel()
    var selected_task: Task!
    var task_list: [ Task ] = [ Task ]()
    
    var date_formatter = DateFormatter()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.task_table_view.delegate   = self
        self.task_table_view.dataSource = self
        
        self.title = "Tasks"
        self.navigationItem.hidesBackButton = true
        
        self.task_model.delegate = self
        self.task_model.loadTasks( usrnm: self.current_user )
        
        self.date_formatter.dateStyle = .long
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear( _ animated: Bool )
    {
        self.task_model.loadTasks( usrnm: self.current_user )
    }
    
    func taskList( tasks: [ Task ] )
    {
        self.task_list = tasks
        self.task_table_view.reloadData()
    }
    
    func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int ) -> Int
    {
        return task_list.count
    }
    
    func tableView( _ tableView: UITableView, cellForRowAt indexPath: IndexPath ) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell( withIdentifier: "taskCell", for: indexPath )
        if let cell = cell as? TaskTableViewCell
        {
            let task = task_list[ indexPath.row ]
            cell.title_label.text = task.title
            cell.date_label.text  = task.date
        }
        return cell
    }
    
    @IBAction func loadAddTaskModal( _ sender: UIBarButtonItem )
    {
        self.performSegue( withIdentifier: "addTaskSegue", sender: self )
    }
    
    override func prepare( for segue: UIStoryboardSegue, sender: Any? )
    {
        let id = segue.identifier
        if id == "addTaskSegue"
        {
            let destination = segue.destination.childViewControllers[ 0 ] as! AddTaskViewController
            destination.current_user = self.current_user
        }
        else if id == "taskDetailSegue"
        {
            let destination = segue.destination as! TaskDetailViewController
            let row = self.task_table_view.indexPathForSelectedRow?.row
            destination.task = self.task_list[ row! ]
            destination.current_user = self.current_user
        }
    }
    
    @IBAction func logout( _ sender: UIBarButtonItem )
    {
        self.navigationController?.popToRootViewController( animated: true )
    }
}
