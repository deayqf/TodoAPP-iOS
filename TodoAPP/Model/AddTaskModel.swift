//
//  AddTaskModel.swift
//  TodoAPP
//
//  Created by David Auger on 11/20/17.
//  Copyright © 2017 David Auger. All rights reserved.
//

import Foundation
import UIKit

// Implemented in AddTaskViewController.swift
protocol AddTaskModelProtocol: class
{
    // Async function for knowing when the DB request has finished
    func taskAdded()
}

class AddTaskModel
{
    weak var delegate: AddTaskModelProtocol!
    
    func addTask( usrnm: String, task: Task )
    {
        let post_string: String = "action=insert_task&usrnm=\( usrnm )&name=\( task.title )&group=\( task.group )&due=\( task.date )"
        let request = HTTPRequest.POST( post_string: post_string )
        
        let session_task = URLSession.shared.dataTask( with: request )
        {
            ( data, response, error ) in
            guard let _ = data, error == nil
                else
            {
                print( "Add task ERROR: \( error! )" )
                return
            }
            if let http_status = response as? HTTPURLResponse,
                http_status.statusCode != 200
            {
                print( "Add task STATUS: \( http_status.statusCode )" )
                print( "Add task RESPONSE: \( response! )" )
            }
            else
            {
                DispatchQueue.main.async(
                    execute:
                    {
                        () -> Void in
                        // Call asynchronous protocol function
                        self.delegate.taskAdded()
                    }
                )
            }
        }
        session_task.resume()
    }
    
    // Alert for displaying to the user any errors that may have occured
    func showAlert( sender: AddTaskViewController, title: String, msg: String )
    {
        let alert = UIAlertController( title: title, message: msg, preferredStyle: .alert )
        alert.addAction( UIAlertAction( title: "Ok", style: .default, handler: nil ) )
        sender.present( alert, animated: true, completion: nil )
    }
}
