//
//  LoginViewController.swift
//  Twitter
//
//  Created by Super MattMatt on 10/31/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "userLoggedIn") == true {
            self.performSegue(withIdentifier: "loginSegue", sender: self)
        }
    }

    @IBAction func loginTapped(_ sender: Any) {
        let oauthUrl = "https://api.twitter.com/oauth/request_token"
        TwitterAPICaller.client?.login(url: oauthUrl, success: {
            UserDefaults.standard.set(true, forKey: "userLoggedIn")
            self.performSegue(withIdentifier: "loginSegue", sender: self)
        }, failure: { (Error) in
            print("Failed to login")
        })

    }
    
}
