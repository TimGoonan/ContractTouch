//
//  AddFriend.swift
//  ContractTouch
//
//  Created by SDG1 on 10/11/16.
//  Copyright © 2016 GoonanCo. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class AddFriend: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    @IBOutlet weak var tableView: UITableView!
    
    var friends: [Friend]?
    var selectedName: String!
    var passID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.backgroundColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(friends)
        return friends!.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        let cell = tableView.cellForRow(at: indexPath!) as! FriendTableCell2
        passID = cell.idLabel.text
        selectedName = cell.nameLabel.text
        performSegue(withIdentifier: "backToFriends", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "backToFriends"){
            let viewController: ProposalScreen = segue.destination as! ProposalScreen
            //print(selectedName)
            viewController.recipientName = selectedName
            //print(passID)
            viewController.selectedID = passID
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let friendCell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FriendTableCell2
        
        if let friend = friends?[indexPath.item], let id = friend.id, let name = friend.name, let picture = friend.picture {
            friendCell.nameLabel.text = name
            friendCell.idLabel.text = id
            friendCell.idLabel.isHidden = true
            //print(friendCell.nameLabel.text , friendCell.idLabel.text)
            friendCell.userImageView.image = nil
            
            if let url = URL(string: picture) {
                if let image = FriendsController.imageCache.object(forKey: url as AnyObject) as? UIImage {
                    friendCell.userImageView.image = image
                    //                    print("cache hit for \(name)")
                } else {
                    URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
                        if error != nil {
                            print(error as Any)
                            return
                        }
                        
                        let image = UIImage(data: data!)
                        FriendsController.imageCache.setObject(image!, forKey: url as AnyObject)
                        DispatchQueue.main.async(execute: { () -> Void in
                            friendCell.userImageView.image = image
                        })
                        
                    }).resume()
                }
                
            }
        }
        return friendCell
    }
    
    static let imageCache = NSCache<AnyObject, AnyObject>()
}

class FriendTableCell2: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    /*
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFontOfSize(14)
        return label
    }()
    
    let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFit
        return imageView
    }()
    
    func setupViews() {
        addSubview(userImageView)
        addSubview(nameLabel)
        
        addConstraintsWithFormat("H:|-8-[v0(48)]-8-[v1]|", views: userImageView, nameLabel)
        
        addConstraintsWithFormat("V:|[v0]|", views: nameLabel)
        
        addConstraintsWithFormat("V:|-8-[v0(48)]", views: userImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }*/
    
}

































/*
import UIKit

class AddFriend: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var friendsIDArray: [String] = []
    var friendsNameArray: [String] = []
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var nameArray = ["joe","tim","bob"]
    var dateArray = ["01/01/2001","01/01/2010","01/01/2016"]
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return nameArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomCell
        print("HI")
        print(friendsNameArray)
        cell.friendNameTxt?.text = nameArray[indexPath.row]

        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("YO")
        //returnFacebookData()
        print("YO2")
        
        
        
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name"])
        graphRequest.startWithCompletionHandler{(connection: FBSDKGraphRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
            print("Error")
            if (error != nil){
                print("Error")
            }
            else{
                //print("Fetched user: \(result)")
            }
            
        }
        
        // Get User friends that are using app
        
        let graphFriendRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me/friends", parameters: ["fields": "id, name"])
        graphFriendRequest.startWithCompletionHandler{(connection, result, error) -> Void in
            if (error != nil){
                print("Error: \(error)")
            }
            else{
                //print("Fetched user: \(result)")
                if let userNameArray : NSArray = result.valueForKey("data") as? NSArray
                {
                    for i in (0..<userNameArray.count)
                    {
                        let valueDict : NSDictionary = userNameArray[i] as! NSDictionary
                        let id = valueDict.objectForKey("id") as! String
                        let name = valueDict.objectForKey("name") as! String
                        self.friendsIDArray.append(id)
                        self.friendsNameArray.append(name)
                    }
                    print(self.friendsIDArray)
                    print(self.friendsNameArray)
                }
            }
        }
        
        // Get User's friends that aren't on the app
        
        let graphAllFriendRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me/taggable_friends", parameters: ["fields": "id, name"])
        graphAllFriendRequest.startWithCompletionHandler{(connection, result, error) -> Void in
            if (error != nil){
                print("Error: \(error)")
            }
            else{
                //print("Fetched user: \(result)")
                if let userNameArray : NSArray = result.valueForKey("data") as? NSArray
                {
                    for i in (0..<userNameArray.count)
                    {
                        let valueDict : NSDictionary = userNameArray[i] as! NSDictionary
                        let id = valueDict.objectForKey("id") as! String
                        let name = valueDict.objectForKey("name") as! String
                        self.friendsIDArray.append(id)
                        self.friendsNameArray.append(name)
                    }
                    //print(self.friendsIDArray)
                    //print(self.friendsNameArray)
                }
            }
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func returnFacebookData(){
        // Get user data
        
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name"])
        graphRequest.startWithCompletionHandler{(connection: FBSDKGraphRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
          print("Error")
        if (error != nil){
                print("Error")
        }
        else{
                //print("Fetched user: \(result)")
        }
            
        }
        
        // Get User friends that are using app
        
        let graphFriendRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me/friends", parameters: ["fields": "id, name"])
        graphFriendRequest.startWithCompletionHandler{(connection, result, error) -> Void in
            if (error != nil){
                print("Error: \(error)")
            }
            else{
                //print("Fetched user: \(result)")
                if let userNameArray : NSArray = result.valueForKey("data") as? NSArray
                {
                    for i in (0..<userNameArray.count)
                    {
                        let valueDict : NSDictionary = userNameArray[i] as! NSDictionary
                        let id = valueDict.objectForKey("id") as! String
                        let name = valueDict.objectForKey("name") as! String
                        self.friendsIDArray.append(id)
                        self.friendsNameArray.append(name)
                    }
                    print(self.friendsIDArray)
                    print(self.friendsNameArray)
                }
            }
        }
        
        // Get User's friends that aren't on the app
        
        let graphAllFriendRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me/taggable_friends", parameters: ["fields": "id, name"])
        graphAllFriendRequest.startWithCompletionHandler{(connection, result, error) -> Void in
            if (error != nil){
                print("Error: \(error)")
            }
            else{
                //print("Fetched user: \(result)")
                if let userNameArray : NSArray = result.valueForKey("data") as? NSArray
                {
                    for i in (0..<userNameArray.count)
                    {
                        let valueDict : NSDictionary = userNameArray[i] as! NSDictionary
                        let id = valueDict.objectForKey("id") as! String
                        let name = valueDict.objectForKey("name") as! String
                        self.friendsIDArray.append(id)
                        self.friendsNameArray.append(name)
                    }
                    //print(self.friendsIDArray)
                    //print(self.friendsNameArray)
                }
            }
            
        }
    }

    
    
    
    
}*/
