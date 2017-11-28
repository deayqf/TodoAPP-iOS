//
//  LoginViewController.swift
//  TodoAPP
//
//  Created by David Auger on 11/20/17.
//  Copyright © 2017 David Auger. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, LoginModelProtocol
{
    @IBOutlet weak var usrnm_field: UITextField!
    @IBOutlet weak var psswd_field: UITextField!
    
    let login_model: LoginModel = LoginModel()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.login_model.delegate = self
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func loginResponse( status: Int )
    {
        if status == 0
        {
            self.performSegue( withIdentifier: "taskViewSegue", sender: self )
        }
        else
        {
            login_model.showAlert( sender: self, title: "Login Failed", msg: "Invalid username or password" )
        }
    }
    
    @IBAction func initiateLogin( _ sender: UIButton )
    {
        if let usrnm = usrnm_field.text,
           let psswd = psswd_field.text,
           usrnm != "", psswd != ""
        {
            login_model.sendLoginRequest( usrnm: usrnm, psswd: psswd )
        }
        else
        {
            login_model.showAlert( sender: self, title: "Invalid Inputs", msg: "All inputs are required" )
        }
    }
    
    @IBAction func loadRegistrationModal( _ sender: UIButton )
    {
        self.performSegue( withIdentifier: "toRegisterSegue", sender: self )
    }
    
    override func prepare( for segue: UIStoryboardSegue, sender: Any? )
    {
        let id = segue.identifier
        if id == "taskViewSegue"
        {
            let destination = segue.destination as! TaskViewController
            destination.current_user = usrnm_field.text!
            self.usrnm_field.text = ""
            self.psswd_field.text = ""
        }
    }
}
