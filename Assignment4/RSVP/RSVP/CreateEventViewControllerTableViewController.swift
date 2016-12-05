//
//  CreateEventViewControllerTableViewController.swift
//  RSVP
//
//  Created by Marta Wegner on 11/6/16.
//  Copyright © 2016 Marta Wegner. All rights reserved.
//

import UIKit

class CreateEventViewControllerTableViewController: UITableViewController {
    
    @IBOutlet weak var name: UITextField!
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
        return 16
    }

    @IBAction func CreateEventButton(_ sender: Any) {
        if(name.text?.isEmpty ?? true) {
            self.message.text="ERROR: must enter event name!"
            
        }
        else {
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
                        let url = URL(string:"https://rsvp-147403.appspot.com/event")!
                        var request = URLRequest(url: url)
                        
                        request.httpMethod = "POST"
                    
                        let postString:String = "name=\(name.text!)&host=\(host.text!)&hostEmail=\(hostEmail.text!)&address1=\(address1.text!)&address2=\(address2.text!)&city=\(city.text!)&state=\(state.text!)&zip=\(zip.text!)&foods[]=\(food1.text!)&foods[]=\(food2.text!)&foods[]=\(food3.text!)"
                        
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
                                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: Any]
                                    print (parsedData)
                                    DispatchQueue.main.async {
                                        let eventID = parsedData["key"]! as! Int
                                        self.message.text = "Event ID: \(eventID)"
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
