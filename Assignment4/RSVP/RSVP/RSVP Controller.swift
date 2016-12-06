//
//  RSVP Controller.swift
//  RSVP
//
//  Created by Mauricio Ochoa on 12/4/16.
//  Copyright © 2016 Marta Wegner. All rights reserved.
//

import UIKit

class RSVP_Controller: UITableViewController {
    var id: String!
    var event: String!

    @IBOutlet weak var eventTitle: UILabel!
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var number: UITextField!
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var message: UILabel!
    
    var answer: String!
    
    @IBAction func AcceptRSVP(_ sender: Any) {
        answer = "True"
        
        message.text=""
        
        getRSVP()
    }
    
    @IBAction func DeclineRSVP(_ sender: Any) {
        answer = "False"
        
        message.text=""
        
        getRSVP()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let t = eventTitle.text!
        eventTitle.text = t + event!
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func getRSVP() {
        if (name.text?.isEmpty ?? true) {
            self.message.text="ERROR: must enter your name"
        }
        else {
            if (self.number.text?.isEmpty ?? true) {
                self.message.text="ERROR: must enter the number of people if your party"
            }
            else {
                let n = number.text!
                let num = Int(n)
                
                if num == nil {
                    self.message.text="ERROR: must enter an integer number for number in party"
                }
                else {
                    let url = URL(string:"https://rsvp-147403.appspot.com/rsvp")!
                    var request = URLRequest(url: url)
                
                    request.httpMethod = "POST"
                
                    let postString:String = "name=\(name.text!)&number=\(number.text!)&email=\(email.text!)&answer=\(answer!)"
                    
                
                    request.httpBody = postString.data(using: String.Encoding.utf8)
                    request.addValue("application/json", forHTTPHeaderField: "Accept")
                
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
                            do {
                                let parsedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: Any]
                                
                                let rsvpID = parsedData["key"]! as! Int
                                    
                                //Add RSVP to Event
                                let url = URL(string:"https://rsvp-147403.appspot.com/event/\(self.id!)/rsvp/\(rsvpID)")!
                                    var request = URLRequest(url: url)
                                    
                                request.httpMethod = "PUT"
                                
                                
                                request.addValue("application/json", forHTTPHeaderField: "Accept")
                                    
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
                                        DispatchQueue.main.sync {
                                            self.message.text = "RSVP ID: \(rsvpID)"
                                        }
                                    }
                                }).resume()
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
        return 6
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
