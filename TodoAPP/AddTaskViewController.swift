//
//  AddTaskViewController.swift
//  TodoAPP
//
//  Created by David Auger on 11/20/17.
//  Copyright © 2017 David Auger. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController, AddTaskModelProtocol
{
    @IBOutlet weak var title_field: UITextField!
    @IBOutlet weak var class_field: UITextField!
    @IBOutlet weak var date_label: UILabel!
    @IBOutlet weak var date_picker: UIDatePicker!
    
    var current_user: String = String()
    let add_model: AddTaskModel = AddTaskModel()
    
    let date_formatter = DateFormatter()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.add_model.delegate = self
        
        self.date_formatter.dateFormat = "MMM dd, YYYY"
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func taskAdded()
    {
        self.dismiss( animated: true, completion: nil )
    }
    
    @IBAction func initiateAddTask( _ sender: UIButton )
    {
        if let title = title_field.text,
           let group = class_field.text,
           title != "", group != ""
        {
            let date = self.date_formatter.string( from: date_picker.date )
            let task = Task( title: title, group: group, date: date, notes: "", status: "" )
            add_model.addTask( usrnm: current_user, task: task )
        }
        else
        {
            add_model.showAlert( sender: self, title: "Invalid Inputs", msg: "All inputs are required" )
        }
    }
    
    @IBAction func cancelAddTask( _ sender: UIButton )
    {
        self.dismiss( animated: true, completion: nil )
    }
}
