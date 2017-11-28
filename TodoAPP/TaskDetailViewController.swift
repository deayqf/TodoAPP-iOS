//
//  TaskDetailViewController.swift
//  TodoAPP
//
//  Created by David Auger on 11/28/17.
//  Copyright © 2017 David Auger. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController, TaskDetailModelProtocol
{
    @IBOutlet weak var title_field: UITextField!
    @IBOutlet weak var class_field: UITextField!
    @IBOutlet weak var date_field: UITextField!
    @IBOutlet weak var status_btn: UIButton!
    @IBOutlet weak var notes_view: UITextView!
    
    var current_user: String = String()
    let detail_model: TaskDetailModel = TaskDetailModel()
    var task: Task!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        detail_model.delegate = self

        title_field.text = task.title
        class_field.text = task.group
        date_field.text  = task.date
        notes_view.text  = task.notes
        
        self.updateStatusBtn()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func afterDeletion()
    {
        self.navigationController?.popViewController( animated: true )
    }
    
    @IBAction func setTaskStatus( _ sender: UIButton )
    {
        task.status = ( task.status == "0" ) ? "1" : "0"
        detail_model.updateStatus( usrnm: current_user, task: task.title, status: task.status )
        self.updateStatusBtn()
    }
    
    func updateStatusBtn() -> Void
    {
        if task.status == "0"
        {
            status_btn.setTitle( "active", for: .normal )
            status_btn.layer.backgroundColor = UIColor.green.cgColor
        }
        else
        {
            status_btn.setTitle( "inactive", for: .normal )
            status_btn.layer.backgroundColor = UIColor.red.cgColor
        }
    }
    
    @IBAction func updateTaskTitle( _ sender: UIButton )
    {
        title_field.isEnabled = !title_field.isEnabled
        
        if title_field.isEnabled == true
        {
            sender.setTitle( "Save", for: .normal )
        }
        else
        {
            sender.setTitle( "Edit", for: .normal )
            if title_field.text != task.title,
               title_field.text != ""
            {
                print( "Task title changed" )
                detail_model.updateTitle( usrnm: current_user, old_title: task.title, new_title: title_field.text! )
                task.title = title_field.text!
            }
            else
            {
                title_field.text = task.title
            }
        }
    }
    
    @IBAction func updateTaskClass( _ sender: UIButton )
    {
        class_field.isEnabled = !class_field.isEnabled
        
        if class_field.isEnabled == true
        {
            sender.setTitle( "Save", for: .normal )
        }
        else
        {
            sender.setTitle( "Edit", for: .normal )
            if class_field.text != task.group,
               class_field.text != ""
            {
                detail_model.updateClass( usrnm: current_user, title: task.title, group: class_field.text! )
                task.group = class_field.text!
            }
            else
            {
                class_field.text = task.group
            }
        }
    }
    
    @IBAction func updateTaskDate( _ sender: UIButton )
    {
        date_field.isEnabled = !date_field.isEnabled
        
        if date_field.isEnabled == true
        {
            sender.setTitle( "Save", for: .normal )
        }
        else
        {
            sender.setTitle( "Edit", for: .normal )
            if date_field.text != task.date,
               date_field.text != ""
            {
                detail_model.updateDate( usrnm: current_user, title: task.title, date: date_field.text! )
                task.date = date_field.text!
            }
            else
            {
                date_field.text = task.date
            }
        }
    }
    
    @IBAction func updateTaskNotes( _ sender: UIButton )
    {
        notes_view.isEditable = !notes_view.isEditable
        
        if notes_view.isEditable == true
        {
            sender.setTitle( "Save", for: .normal )
        }
        else
        {
            sender.setTitle( "Edit", for: .normal )
            if notes_view.text != task.notes
            {
                detail_model.updateNotes( usrnm: current_user, title: task.title, notes: notes_view.text! )
                task.notes = notes_view.text!
            }
        }
    }
    
    @IBAction func deleteTask( _ sender: UIBarButtonItem )
    {
        detail_model.deleteTask( usrnm: current_user, title: task.title )
    }
}
