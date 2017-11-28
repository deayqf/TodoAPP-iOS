//
//  LoginModel.swift
//  TodoAPP
//
//  Created by David Auger on 11/20/17.
//  Copyright © 2017 David Auger. All rights reserved.
//

import Foundation
import UIKit

// Implemented in LoginViewController.swift
protocol LoginModelProtocol: class
{
    // Async protocol function for retrieving the status of the login request
    func loginResponse( status: Int )
}

class LoginModel
{
    weak var delegate: LoginModelProtocol!
    
    func sendLoginRequest( usrnm: String, psswd: String )
    {
        let post_string: String = "action=login&u=\( usrnm )&p=\( psswd )"
        let request: URLRequest = HTTPRequest.POST( post_string: post_string )
        
        let session_task = URLSession.shared.dataTask( with: request )
        {
            ( data, response, error ) in
            guard let data = data, error == nil
            else
            {
                print( "Login ERROR: \( error! )" )
                return
            }
            if let http_status = response as? HTTPURLResponse,
               http_status.statusCode != 200
            {
                print( "Login STATUS: \( http_status.statusCode )" )
                print( "Login RESPONSE: \( response! )" )
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
        var status: Int!
        if let json = try? JSONSerialization.jsonObject( with: data, options: [] ) as! NSArray
        {
            for item in json
            {
                if let item = item as? [ String: Int ]
                {
                    status = item[ "status" ]!
                }
            }
            DispatchQueue.main.async(
                execute:
                {
                    () -> Void in
                    // Call asynchronous protocol function
                    self.delegate.loginResponse( status: status )
                }
            )
        }
    }
    
    // Alert for displaying to the user any errors that may have occured
    func showAlert( sender: LoginViewController, title: String, msg: String )
    {
        let alert = UIAlertController( title: title, message: msg, preferredStyle: .alert )
        alert.addAction( UIAlertAction( title: "Ok", style: .default, handler: nil ) )
        sender.present( alert, animated: true, completion: nil )
    }
}
