//
//  TaskDetailModel.swift
//  TodoAPP
//
//  Created by David Auger on 11/28/17.
//  Copyright © 2017 David Auger. All rights reserved.
//

import Foundation

// Implemented in TaskDetailViewController.swift
protocol TaskDetailModelProtocol: class
{
    // Async function for knowing when the DB request has finished
    func afterDeletion()
}

class TaskDetailModel
{
    weak var delegate: TaskDetailModelProtocol!
    
    func updateStatus( usrnm: String, task: String, status: String )
    {
        let post_string: String = "action=update_status&usrnm=\( usrnm )&name=\( task )&status=\( status )"
        let request = HTTPRequest.POST( post_string: post_string )
        
        let session_task = URLSession.shared.dataTask( with: request )
        {
            ( data, response, error ) in
            guard let _ = data, error == nil
            else
            {
                print( "Update task's status ERROR: \( error! )" )
                return
            }
            if let http_status = response as? HTTPURLResponse,
               http_status.statusCode != 200
            {
                print( "Update task's status STATUS: \( http_status.statusCode )" )
                print( "Update task's status RESPONSE: \( response! )" )
            }
        }
        session_task.resume()
    }
    
    func updateTitle( usrnm: String, old_title: String, new_title: String )
    {
        let post_string: String = "action=update_title&usrnm=\( usrnm )&old=\( old_title )&new=\( new_title )"
        let request = HTTPRequest.POST( post_string: post_string )
        
        let session_task = URLSession.shared.dataTask( with: request )
        {
            ( data, response, error ) in
            guard let _ = data, error == nil
                else
            {
                print( "Update task's title ERROR: \( error! )" )
                return
            }
            if let http_status = response as? HTTPURLResponse,
                http_status.statusCode != 200
            {
                print( "Update task's title STATUS: \( http_status.statusCode )" )
                print( "Update task's title RESPONSE: \( response! )" )
            }
        }
        session_task.resume()
    }
    
    func updateClass( usrnm: String, title: String, group: String )
    {
        let post_string: String = "action=update_class&usrnm=\( usrnm )&title=\( title )&class=\( group )"
        let request = HTTPRequest.POST( post_string: post_string )
        
        let session_task = URLSession.shared.dataTask( with: request )
        {
            ( data, response, error ) in
            guard let _ = data, error == nil
                else
            {
                print( "Update task's class ERROR: \( error! )" )
                return
            }
            if let http_status = response as? HTTPURLResponse,
                http_status.statusCode != 200
            {
                print( "Update task's class STATUS: \( http_status.statusCode )" )
                print( "Update task's class RESPONSE: \( response! )" )
            }
        }
        session_task.resume()
    }
    
    func updateDate( usrnm: String, title: String, date: String )
    {
        let post_string: String = "action=update_date&usrnm=\( usrnm )&title=\( title )&date=\( date )"
        let request = HTTPRequest.POST( post_string: post_string )
        
        let session_task = URLSession.shared.dataTask( with: request )
        {
            ( data, response, error ) in
            guard let _ = data, error == nil
                else
            {
                print( "Update task's date ERROR: \( error! )" )
                return
            }
            if let http_status = response as? HTTPURLResponse,
                http_status.statusCode != 200
            {
                print( "Update task's date STATUS: \( http_status.statusCode )" )
                print( "Update task's date RESPONSE: \( response! )" )
            }
        }
        session_task.resume()
    }
    
    func updateNotes( usrnm: String, title: String, notes: String )
    {
        let post_string: String = "action=update_notes&usrnm=\( usrnm )&title=\( title )&notes=\( notes )"
        let request = HTTPRequest.POST( post_string: post_string )
        
        let session_task = URLSession.shared.dataTask( with: request )
        {
            ( data, response, error ) in
            guard let _ = data, error == nil
                else
            {
                print( "Update task's notes ERROR: \( error! )" )
                return
            }
            if let http_status = response as? HTTPURLResponse,
                http_status.statusCode != 200
            {
                print( "Update task's notes STATUS: \( http_status.statusCode )" )
                print( "Update task's notes RESPONSE: \( response! )" )
            }
        }
        session_task.resume()
    }
    
    func deleteTask( usrnm: String, title: String )
    {
        let post_string: String = "action=delete_task&usrnm=\( usrnm )&name=\( title )"
        let request = HTTPRequest.POST( post_string: post_string )
        
        let session_task = URLSession.shared.dataTask( with: request )
        {
            ( data, response, error ) in
            guard let _ = data, error == nil
                else
            {
                print( "Delete task ERROR: \( error! )" )
                return
            }
            if let http_status = response as? HTTPURLResponse,
                http_status.statusCode != 200
            {
                print( "Delete task STATUS: \( http_status.statusCode )" )
                print( "Delete task RESPONSE: \( response! )" )
            }
            else
            {
                DispatchQueue.main.async(
                    execute:
                    {
                        () -> Void in
                        // Call asynchronous protocol function
                        self.delegate.afterDeletion()
                    }
                )
            }
        }
        session_task.resume()
    }
}
