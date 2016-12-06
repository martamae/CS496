//
//  View RSVP.swift
//  RSVP
//
//  Created by Mauricio Ochoa on 12/5/16.
//  Copyright © 2016 Marta Wegner. All rights reserved.
//

import UIKit

class View_RSVP: UITableViewController {

    @IBOutlet weak var rsvpID: UITextField!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var answer: UILabel!
    
    @IBOutlet weak var message: UILabel!
    
    var id: String!
    
    @IBAction func submitID(_ sender: UIButton) {
        if(rsvpID.text?.isEmpty ?? true) {
            //   self.message.text="ERROR: must enter an Event ID!"
        }
        else {
            self.message.text=""
            id = (rsvpID.text)!
            
            let urlString = "https://rsvp-147403.appspot.com/rsvp/\(id!)"
            
            let url = URL(string: urlString)!
            
            var request = URLRequest(url: url)
            
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
                            self.name.text = parsedData["name"] as! String!
                            
                            self.number.text = "\(parsedData["number"]!)"
                            
                            if let e = parsedData["email"] as? String {
                                 self.email.text = e
                            }
                            
                            let a = "\(parsedData["answer"]!)"
                            
                            if a == "1" {
                                self.answer.text = "Invitation Accepted"
                            }
                            else {
                                self.answer.text = "Invitation Declined"
                                print (a)
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
