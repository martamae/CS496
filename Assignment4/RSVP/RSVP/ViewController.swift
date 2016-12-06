//
//  ViewController.swift
//  RSVP
//
//  Created by Marta Wegner on 11/6/16.
//  Copyright © 2016 Marta Wegner. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

        
    @IBAction func EventView(_ sender: Any) {
        print ("View & RSVP Button")
    }
 
    @IBAction func RSVPView(_ sender: Any) {
        print ("View RSVP")
    }
    
}

