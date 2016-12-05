//
//  EventView.swift
//  RSVP
//
//  Created by Marta Wegner on 11/7/16.
//  Copyright © 2016 Marta Wegner. All rights reserved.
//

import UIKit

class EventView: UITableViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var host: UILabel!
    @IBOutlet weak var hostEmail: UILabel!
    @IBOutlet weak var address1: UILabel!
    @IBOutlet weak var address2: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var state: UILabel!
    @IBOutlet weak var zip: UILabel!
    @IBOutlet weak var foods: UILabel!


    
    @IBOutlet weak var EventID: UITextField!
    
    @IBOutlet weak var message: UILabel!
    
    @IBAction func SubmitID(_ sender: Any) {
        if(EventID.text?.isEmpty ?? true) {
            self.message.text="ERROR: must enter an Event ID!"
        }
        else {
            self.message.text=""
            let id = EventID.text!
            
            let urlString = "https://rsvp-147403.appspot.com/event/\(id)"
            
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
                            
                            self.foods.text = ""
                            
                            if let f: NSArray = parsedData["foods"] as? NSArray {
                                for i in 0...f.count-1 {
                                    let fi = f[i] as? String
                                    let string = (self.foods.text)! + " " + fi!
                                    self.foods.text = string
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
    

    @IBAction func directions(_ sender: Any) {
        if (name.text?.isEmpty ?? true){
            self.message.text = "ERROR: Must enter Event ID"
        }
        else {
            self.performSegue(withIdentifier: "directionsTo", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "directionsTo") {
            let MapVC = segue.destination as! Map_View_Controller
            
            MapVC.eventName = name.text!
            
            let fullAddress = address1.text! + " " + address2.text! + " " + city.text! + " " + state.text! + " " + zip.text!
            
            MapVC.address = fullAddress
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
        return 15
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
