//
//  Event Functions.swift
//  RSVP
//
//  Created by Marta Wegner on 12/3/16.
//  Copyright © 2016 Marta Wegner. All rights reserved.
//

import UIKit

class Event_Functions: UIViewController {
    var fullName: String!
    var email: String!

    

    @IBOutlet weak var welcome: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        welcome.text = "Hello " + fullName + "!"
        
    }

    @IBAction func createEventBtn(_ sender: UIButton) {
        performSegue(withIdentifier: "createEventSeg", sender: self)
    }
    
    @IBAction func manageEventBtn(_ sender: UIButton) {
        performSegue(withIdentifier: "manageEventSeg", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "createEventSeg") {
            let CreateVC = segue.destination as! CreateEventViewControllerTableViewController
        
            //how to send vars
            CreateVC.fullName = fullName!
            CreateVC.email = email!
        }
        else if (segue.identifier == "manageEventSeg") {
            let ManageVC = segue.destination as! ManageEventViewController
            
            //how to send vars
            ManageVC.fullName = fullName!
            ManageVC.email = email!
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        GIDSignIn.sharedInstance().signOut()
        performSegue(withIdentifier: "logout", sender: self)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
