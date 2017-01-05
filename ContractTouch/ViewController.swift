//
//  ViewController.swift
//  ContractTouch
//
//  Created by SDG1 on 9/6/16.
//  Copyright © 2016 GoonanCo. All rights reserved.
//


import UIKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate  {
    /*!
     @abstract Sent to the delegate when the button was used to login.
     @param loginButton the sender
     @param result The results of the login
     @param error The error (if any) from the login
     */
    public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        fetchProfile()
        startBtn.isHidden = false
    }

    
    var logoutCheck: Bool = false
    @IBOutlet weak var startBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        //startBtn.hidden = true
        
        if (FBSDKAccessToken.current() != nil)
        {
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile","email","user_friends"]
            loginView.delegate = self
        }
        else
        {
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile","email","user_friends"]
            loginView.delegate = self
         }

    }
    /*
    func showFriends() {
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
                }
            }
            
            let friendsController = FriendsController(collectionViewLayout: UICollectionViewFlowLayout())
            friendsController.friends = friends
            self.navigationController?.pushViewController(friendsController, animated: true)
            self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        })
    }*/
    
    func fetchProfile() {
        let parameters = ["fields": "id, email, first_name, last_name, picture.type(large)"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start(completionHandler: { (connection, user, requestError) -> Void in
            
            if requestError != nil {
                print(requestError as Any)
                return
            }
            
            let dataDict = user as? [String:AnyObject]
            
            let userID = dataDict?["id"]
            print(userID as Any)
            
            let userEmail = dataDict?["email"]
            let firstName = dataDict?["first_name"]
            let lastName = dataDict?["last_name"]
            
            print(userEmail as Any)
            print(firstName as Any)
            print(lastName as Any)
            
            
            //self.nameLabel.text = "\(firstName!) \(lastName!)"
            
            var pictureUrl = ""
            
            if let picture = dataDict?["picture"] as? [String:AnyObject], let data = picture["data"] as? [String:AnyObject], let url = data["url"] as? String {
                pictureUrl = url
            }
            
            let url = URL(string: pictureUrl)
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) -> Void in
                if error != nil {
                    print(error as Any)
                    return
                }
                /*
                let image = UIImage(data: data!)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.userImageView.image = image
                })*/
                
            }).resume()
            
        })
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        startBtn.isHidden = true
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        startBtn.isHidden = false
        return true
    }
    
}

struct Friend {
    var id, name, picture: String?
}

extension UIView {
    func addConstraintsWithFormat(_ format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}



extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
