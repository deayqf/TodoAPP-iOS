//
//  RegisterModel.swift
//  TodoAPP
//
//  Created by David Auger on 11/20/17.
//  Copyright © 2017 David Auger. All rights reserved.
//

import Foundation
import UIKit

// Implemented in RegisterViewController.swift
protocol RegisterModelProtocol: class
{
    // Async function for retrieving the status of the registration request
    func registerResponse( status: Int )
}

class RegisterModel
{
    weak var delegate: RegisterModelProtocol!
    
    func sendRegisterRequest( usrnm: String, psswd: String )
    {
        let post_string: String = "action=register&u=\( usrnm )&p=\( psswd )"
        let request: URLRequest = HTTPRequest.POST( post_string: post_string )
        
        let session_task = URLSession.shared.dataTask( with: request )
        {
            ( data, response, error ) in
            guard let data = data, error == nil
                else
            {
                print( "Register ERROR: \( error! )" )
                return
            }
            if let http_status = response as? HTTPURLResponse,
                http_status.statusCode != 200
            {
                print( "Register STATUS: \( http_status.statusCode )" )
                print( "Register STATUS: \( response! )" )
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
                    // Call the asynchronous protocol function
                    self.delegate.registerResponse( status: status )
                }
            )
        }
    }
    
    // Alert for displaying to the user any errors that may have occured
    func showAlert( sender: RegisterViewController, title: String, msg: String )
    {
        let alert = UIAlertController( title: title, message: msg, preferredStyle: .alert )
        alert.addAction( UIAlertAction( title: "Ok", style: .default, handler: nil ) )
        sender.present( alert, animated: true, completion: nil )
    }
}
