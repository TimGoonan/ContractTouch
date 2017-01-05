//
//  HomeScreen.swift
//  ContractTouch
//
//  Created by SDG1 on 9/13/16.
//  Copyright © 2016 GoonanCo. All rights reserved.
//

import UIKit
import LocalAuthentication
import Social

class HomeScreen: UIViewController {
    
    var logoutCheck: Bool = false
    
    @IBOutlet weak var viewFriendsBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 /*
    var friendTemp: [Friend]?
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "friendSegue2"){
            let detailVC = segue.destinationViewController as! FriendsController
            //print(friendTemp)
            detailVC.friends = friendTemp
        }
    }
    
    @IBAction func viewFriendsBtn(sender: AnyObject) {
        let parameters = ["fields": "name,picture.type(normal),gender"]
        FBSDKGraphRequest(graphPath: "me/taggable_friends", parameters: parameters).startWithCompletionHandler({ (connection, user, requestError) -> Void in
            if requestError != nil {
                print(requestError)
                return
            }
            
            var friends = [Friend]()
            for friendDictionary in user["data"] as! [NSDictionary] {
                let name = friendDictionary["name"] as? String
                if let picture = friendDictionary["picture"]?["data"]?!["url"] as? String {
                    let friend = Friend(name: name, picture: picture)
                    friends.append(friend)
                    //print(name)
                    //print(friend)
                }
            }
            
            let friendsController = FriendsController(collectionViewLayout: UICollectionViewFlowLayout())
            friendsController.friends = friends
            self.friendTemp = friends
            print(self.friendTemp)
            print(friendsController.friends)
            self.performSegueWithIdentifier("friendSegue2", sender: self)
            //self.navigationController?.pushViewController(friendsController, animated: true)
            //self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        })
    }*/
    
    @IBAction func shareFBBtn(_ sender: UIButton) {
        //if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
            let fbShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            
            self.present(fbShare, animated: true, completion: nil)
            
        //} else {
            //let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            
            //alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            //self.presentViewController(alert, animated: true, completion: nil)
        //}
    }
    
    @IBAction func logoutBtn(_ sender: UIButton) {
        
        
    }
    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "logoutSegue"){
            let destinationVC = segue.destinationViewController as! ViewController
            destinationVC.startBtn.hidden = false
        }
    }*/
}
