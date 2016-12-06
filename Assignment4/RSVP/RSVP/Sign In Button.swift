//
//  Sign In Button.swift
//  
//
//  Created by Marta Wegner on 12/3/16.
//
//

import UIKit

class Sign_In_Button: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate{
    
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    var idToken: String!
    var fullName: String!
    var givenName:  String!
    var email: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.        
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert (configureError == nil, "Error configuring Google services: \(configureError)")
        
        GIDSignIn.sharedInstance().clientID = "339387879661-ggvs52n884dtdq68er4ls406tu00j1me.apps.googleusercontent.com"
        
        GIDSignIn.sharedInstance().delegate = self


        GIDSignIn.sharedInstance().uiDelegate = self
        
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/plus.me")
    }
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            let authentication = user.authentication
            
            let credential = FIRGoogleAuthProvider.credential(withIDToken: (authentication?.idToken)!, accessToken: (authentication?.accessToken)!)
            
            FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                if let error = error {
                    print (error)
                    return
                }
                
                let user = FIRAuth.auth()?.currentUser
                self.fullName = user?.displayName
                self.email = user?.email
                
                
                self.performSegue(withIdentifier: "eventFunctions", sender: self)
                
            }
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }


    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "eventFunctions") {
            let EventVC = segue.destination as! Event_Functions
            
            //how to send vars
            EventVC.fullName = fullName!
            EventVC.email = email!
            
        }
    }

    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user: GIDGoogleUser!, withError error: NSError!) {
        
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
