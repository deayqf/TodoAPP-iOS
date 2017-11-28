//
//  RegisterViewController.swift
//  TodoAPP
//
//  Created by David Auger on 11/20/17.
//  Copyright © 2017 David Auger. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, RegisterModelProtocol
{
    @IBOutlet weak var usrnm_field: UITextField!
    @IBOutlet weak var psswd_field: UITextField!
    @IBOutlet weak var cnfrm_field: UITextField!
    
    let register_model: RegisterModel = RegisterModel()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.register_model.delegate = self
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func registerResponse( status: Int )
    {
        if status == 0
        {
            print( "Registration Successfull" )
        }
        else
        {
            register_model.showAlert(sender: self, title: "Registration Failed", msg: "This username is already taken" )
        }
    }
    
    @IBAction func initiateRegistration( _ sender: UIButton )
    {
        if let usrnm = usrnm_field.text,
           let psswd = psswd_field.text,
           let cnfrm = cnfrm_field.text,
           usrnm != "", psswd != "", cnfrm != "",
           psswd == cnfrm
        {
            register_model.sendRegisterRequest( usrnm: usrnm, psswd: psswd )
        }
        else
        {
            register_model.showAlert( sender: self, title: "Invalid Inputs", msg: "All inputs are required" )
        }
    }
    
    @IBAction func cancelRegistration( _ sender: UIButton )
    {
        self.dismiss( animated: true, completion: nil )
    }
}
