//
//  TaskModel.swift
//  TodoAPP
//
//  Created by David Auger on 11/20/17.
//  Copyright © 2017 David Auger. All rights reserved.
//

import Foundation

// Implemented in TaskViewController.swift
protocol TaskModelProtocol: class
{
    // Async function for retrieving the tasks from the DB request
    func taskList( tasks: [ Task ] )
}

class TaskModel
{
    weak var delegate: TaskModelProtocol!
    
    func loadTasks( usrnm: String )
    {
        let post_string: String = "action=tasks&usrnm=\( usrnm )"
        let request: URLRequest = HTTPRequest.POST( post_string: post_string )
        
        let session_task = URLSession.shared.dataTask( with: request )
        {
            ( data, response, error ) in
            guard let data = data, error == nil
                else
            {
                print( "Task load ERROR: \( error! )" )
                return
            }
            if let http_status = response as? HTTPURLResponse,
                http_status.statusCode != 200
            {
                print( "Task load STATUS: \( http_status.statusCode )" )
                print( "Task load RESPONSE: \( response! )" )
            }
            else
            {
                self.parse( data )
            }
        }
        session_task.resume()
    }
    
    func parse( _ data: Data )
    {
        var tasks: [ Task ] = [ Task ]()
        
        if let json = try? JSONSerialization.jsonObject( with: data, options: [] ) as! NSArray
        {
            for task in json
            {
                if let task = task as? [ String: String ]
                {
                    if let title  = task[ "name"   ],
                       let group  = task[ "class"  ],
                       let date   = task[ "due"    ],
                       let notes  = task[ "notes"  ],
                       let status = task[ "status" ]
                    {
                        let new_task = Task( title: title, group: group, date: date, notes: notes, status: status )
                        tasks.append( new_task )
                    }
                }
            }
            DispatchQueue.main.async(
                execute:
                {
                    () -> Void in
                    // Call asynchronous protocol function
                    self.delegate.taskList( tasks: tasks )
                }
            )
        }
    }
}
