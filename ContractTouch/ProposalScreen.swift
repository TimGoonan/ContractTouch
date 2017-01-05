//
//  ProposalScreen.swift
//  ContractTouch
//
//  Created by SDG1 on 9/13/16.
//  Copyright © 2016 GoonanCo. All rights reserved.
//

import UIKit
import MessageUI
import LocalAuthentication

class ProposalScreen: UIViewController, MFMessageComposeViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.hideKeyboardWhenTappedAround()
        recipientTxt.isHidden = true
        
        if(recipientName.isEmpty){
            //print("empty")
        }
        else{
            recipientTxt.isHidden = false
            recipientTxt.text = recipientName
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var proposalTxt: UITextView!
    @IBOutlet weak var recipientTxt: UILabel!
    var friendTemp: [Friend]?
    var recipientName: String = ""
    var selectedID: String = ""
    
    @IBAction func selectFriendsBtn(_ sender: AnyObject) {
        recipientTxt.isHidden = false
        let parameters = ["fields": "id,name,picture.type(normal),gender"]
        FBSDKGraphRequest(graphPath: "me/taggable_friends", parameters: parameters).start(completionHandler: { (connection, user, requestError) -> Void in
            if requestError != nil {
                print(requestError as Any)
                return
            }
            
            var friends = [Friend]()
            let dataDict = user as? [String:AnyObject]
            for friendDictionary in dataDict?["data"] as! [NSDictionary] {
                let name = friendDictionary["name"] as? String
                let id = friendDictionary["id"] as? String
                print(name as Any)
                //print(id)
                if let picture = friendDictionary["picture"] as? [String:AnyObject], let data = picture["data"] as? [String:AnyObject], let url = data["url"] as? String {
                    print(url as Any)
                    let friend = Friend(id: id, name: name, picture: url)
                    print(friend as Any)
                    friends.append(friend)
                    //print(name)
                    //print(friend)
                }
            }
            
            //let friendsController = FriendsController(collectionViewLayout: UICollectionViewFlowLayout())
            //let friendsController = AddFriend
            
            //friendsController.friends = friends
            self.friendTemp = friends
            //print(self.friendTemp)
            //print(friendsController.friends)
            self.performSegue(withIdentifier: "friendSegue", sender: self)
            //self.navigationController?.pushViewController(friendsController, animated: true)
            //self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "friendSegue"){
            let detailVC = segue.destination as! AddFriend //FriendController
            //print(friendTemp)
            detailVC.friends = friendTemp
        }
    }
    
    
    @IBAction func sendProposalBtn(_ sender: AnyObject) {
        //print("W")
        
        self.authenticateUser()
        /*
        let messageVC = MFMessageComposeViewController()
        
        let message = messageTxt.text
        if message.isEmpty{
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        messageVC.body = message
        messageVC.recipients = ["Enter tel-nr"]
        messageVC.messageComposeDelegate = self
        
        self.presentViewController(messageVC, animated: false, completion: nil)*/
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result.rawValue) {
        case MessageComposeResult.cancelled.rawValue:
            print("Message was cancelled")
            self.dismiss(animated: true, completion: nil)
        case MessageComposeResult.failed.rawValue:
            print("Message failed")
            self.dismiss(animated: true, completion: nil)
        case MessageComposeResult.sent.rawValue:
            print("Message was sent")
            self.dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
    
    func proposalAlert() {
        let alert = UIAlertController(title: "Alert", message: "Proposal is empty", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func recipientAlert() {
        let alert = UIAlertController(title: "Alert", message: "Have to choose a recipient", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Touch ID Authentication
    
    func authenticateUser()
    {
        if(!recipientName.isEmpty){
            if (proposalTxt.text.isEmpty){
                self.proposalAlert()
            }
            else{
            
                let context = LAContext()
                var error: NSError?
                let reasonString = "Authentication is needed to access your app"
        
                if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error)
                {
                    context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: { (success, policyError) -> Void in
                
                        if success
                        {
                            print("Authentication successful")
                            let timeStamp = Date()
                            print(self.recipientName)
                            print(self.selectedID)
                            print(self.proposalTxt.text)
                            print(timeStamp)
                            // Insert into Proposal UserId, FriendID, FriendName, Message, Date
                            self.performSegue(withIdentifier: "verifiedSegue", sender: self)
                        }
                        else
                        {
                            switch policyError!._code
                            {
                            case LAError.Code.systemCancel.rawValue:
                                print("Authentication was cancelled by the system.")
                            case LAError.Code.userCancel.rawValue:
                                print("Authentication was cancelled by the user.")
                        
                            case LAError.Code.userFallback.rawValue:
                                print("User selected to enter password.")
                                OperationQueue.main.addOperation({ () -> Void in
                                    self.showPasswordAlert()
                                })
                            default:
                                print("Authentication failed!")
                                OperationQueue.main.addOperation({ () -> Void in
                                    self.showPasswordAlert()
                                })
                            }
                        }
                    })
                }
                else
                {
                    print(error?.localizedDescription as Any)
                    OperationQueue.main.addOperation({ () -> Void in
                        self.showPasswordAlert()
                    })
                }
            }
        }
        else{
            self.recipientAlert()
        }
    }
    
    // MARK: Password Alert
    
    func showPasswordAlert()
    {
        let alertController = UIAlertController(title: "Touch ID Password", message: "Please enter your password.", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action) -> Void in
            
            if let textField = alertController.textFields?.first as UITextField?
            {
                if textField.text == "goonan"
                {
                    //self.performSegueWithIdentifier("audioSegue", sender: self)
                    let timeStamp = Date()
                    print(self.recipientName)
                    print(self.selectedID)
                    print(self.proposalTxt.text)
                    print(timeStamp)
                    // Insert into Proposal UserId, FriendID, FriendName, Message, Date
                    self.performSegue(withIdentifier: "verifiedSegue", sender: self)
                }
                else
                {
                    self.showPasswordAlert()
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel){
            UIAlertAction in
            self.performSegue(withIdentifier: "proposalSegue", sender: self)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(defaultAction)
        
        alertController.addTextField { (textField) -> Void in
            
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
            
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
}
