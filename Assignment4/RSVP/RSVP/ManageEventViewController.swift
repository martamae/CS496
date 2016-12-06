//
//  ManageEventViewController.swift
//  RSVP
//
//  Created by Marta Wegner on 11/6/16.
//  Copyright © 2016 Marta Wegner. All rights reserved.
//

import UIKit

class ManageEventViewController: UITableViewController {
    var fullName: String!
    var email: String!
    
    @IBOutlet weak var EventID: UITextField!
    
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var host: UITextField!
    @IBOutlet weak var hostEmail: UITextField!
    @IBOutlet weak var address1: UITextField!
    @IBOutlet weak var address2: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var zip: UITextField!
    @IBOutlet weak var food1: UITextField!
    @IBOutlet weak var food2: UITextField!
    @IBOutlet weak var food3: UITextField!
    
    @IBOutlet weak var message: UILabel!
    
    var id: String!
    
    @IBAction func submitID(_ sender: UIButton) {
        if(EventID.text?.isEmpty ?? true) {
            self.message.text="ERROR: must enter an Event ID!"
            
        }
        else {
            self.message.text=""
            id = (EventID.text)!
            
            let urlString = "https://rsvp-147403.appspot.com/event/manage"

            let url = URL(string: urlString)!
            
            var request = URLRequest(url: url)
            
            request.httpMethod = "POST"
            
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let postString:String = "id=\(id!)&un=\(email!)"
            print(postString)
    
            request.httpBody = postString.data(using: String.Encoding.utf8)
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in
                if error != nil {
                    DispatchQueue.main.async {
                        self.message.text = ("error=\(error)!")
                    }
                }
                else if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    DispatchQueue.main.async {
                        self.message.text = ("ERROR: \(httpStatus.statusCode)")
                    }
                }
                else {
                    do {
                        let parsedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                        
                        DispatchQueue.main.async {
                            self.eventName.text = parsedData["name"] as! String!
                            self.host.text = parsedData["host"] as! String!
                            if let email = parsedData["hostEmail"] as? String {
                                self.hostEmail.text = email
                            }
                            self.address1.text = parsedData["address1"] as! String!
                            if let add = parsedData["address2"] as? String {
                                self.address2.text = add
                            }
                            self.city.text = parsedData["city"] as! String!
                            self.state.text = parsedData["state"] as! String!
                            self.zip.text = parsedData["zip"] as! String!
                            
                            if let f: NSArray = parsedData["foods"] as? NSArray {
                                for i in 0...f.count-1 {
                                    if let fi = f[i] as? String {
                                        if i == 0 {
                                            self.food1.text = fi
                                        }
                                        else if i == 1 {
                                            self.food2.text = fi
                                        }
                                        else if i == 2 {
                                            self.food3.text = fi
                                        }
                                    }
                                    
                                }
                            }
                        }
                        
                    }
                    catch {
                        print ("Cannot create json")
                        return
                    }
                }
            }).resume()
        }
    }
    
    
    @IBAction func updateEvent(_ sender: UIButton) {
        if (id.isEmpty) {
            self.message.text = "ERROR: must submit an event id"
            return
        }
        else {
            if(eventName.text?.isEmpty ?? true) {
                self.message.text="ERROR: must enter event name!"
            
            }
            else {
                let name = eventName.text!
                print(name)
                if(host.text?.isEmpty ?? true) {
                    self.message.text="ERROR: must enter host's name!"
                }
                else {
                    if(address1.text?.isEmpty ?? true || city.text?.isEmpty ?? true || state.text?.isEmpty ?? true || zip.text?.isEmpty ?? true) {
                        self.message.text="ERROR: must enter complete address!"
                    }
                    else {
                        if(food1.text?.isEmpty ?? true) {
                            self.message.text="ERROR: must enter a food option"
                        }
                        else {
                            let url = URL(string:"https://rsvp-147403.appspot.com/event/edit/\(id!)")!
                            var request = URLRequest(url: url)
                        
                            request.httpMethod = "POST"
                        
                            let postString:String = "name=\(eventName.text!)&host=\(host.text!)&hostEmail=\(hostEmail.text!)&address1=\(address1.text!)&address2=\(address2.text!)&city=\(city.text!)&state=\(state.text!)&zip=\(zip.text!)&foods[]=\(food1.text!)&foods[]=\(food2.text!)&foods[]=\(food3.text!)"
                        
                            request.httpBody = postString.data(using: String.Encoding.utf8)
                            request.addValue("application/json", forHTTPHeaderField: "Accept")
                        
                            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                                print ("task completed")
                                if error != nil {
                                    DispatchQueue.main.async {
                                        self.message.text = ("error=\(error)")
                                    }
                                }
                                else if let httpStatus = response as? HTTPURLResponse,httpStatus.statusCode != 200 {
                                    DispatchQueue.main.sync {
                                        self.message.text =  "ERROR: \(httpStatus.statusCode): \(response)"
                                    }
                                }
                                else {
                                    do {
                                        let _ = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: Any]
                                        DispatchQueue.main.async {
                                            self.message.text = "Your Event has been updated!"
                                        }
                                    }
                                    catch {
                                        print ("Cannot create json")
                                        return
                                    }
                                }
                            }).resume()
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func deleteEvent(_ sender: UIButton) {
        if(eventName.text?.isEmpty ?? true) {
            self.message.text="ERROR: must enter event name!"
            
        }
        else {
            let url = URL(string:"https://rsvp-147403.appspot.com/event/delete/\(id!)")!
            var request = URLRequest(url: url)
            
            request.httpMethod = "DELETE"
            
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if error != nil {
                    DispatchQueue.main.async {
                        self.message.text = ("error=\(error)")
                    }
                }
                else if let httpStatus = response as? HTTPURLResponse,httpStatus.statusCode != 200 {
                    DispatchQueue.main.sync {
                        self.message.text =  "ERROR: \(httpStatus.statusCode): \(response)"
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.eventName.text = ""
                        self.host.text = ""
                        self.hostEmail.text = ""
                        self.address1.text = ""
                        self.address2.text = ""
                        self.city.text = ""
                        self.state.text = ""
                        self.zip.text = ""
                        self.food1.text = ""
                        self.food2.text = ""
                        self.food3.text = ""
                        self.EventID.text = ""
                        self.message.text = "Your Event has been deleted!"
                    }
                }
            }).resume()
        }
        
    }
    
    @IBAction func logout(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signOut()
        performSegue(withIdentifier: "logout", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 17
    }
        

    
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


}
