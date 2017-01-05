//
//  FriendsController.swift
//  facebooknewsfeed
//
//  Created by Brian Voong on 2/16/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class FriendsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var friends: [Friend]?
    var clickedCellName: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor.white

        // Register cell classes
        self.collectionView!.register(FriendCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let friendcell = collectionView.cellForItem(at: indexPath){
            print(friendcell)
            performSegue(withIdentifier: "backToFriends", sender: friendcell)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //assert(sender as? UICollectionView != nil, "sender is not a collection view")
        /*
        if let indexPath = self.collectionView?.indexPathForCell(sender as! UICollectionViewCell){
            if (segue.identifier == "backToFriends"){
                let detailVC = segue.destinationViewController as! ProposalScreen
                print("Segue clicked is ", clickedCellName)
                detailVC.recipientTxt.text = clickedCellName
            }
        }*/
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //print(friends)
        return friends != nil ? friends!.count : 0
    }
    /*
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {        
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        cell!.layer.borderWidth = 2.0
        cell!.layer.borderColor = UIColor.grayColor().CGColor
    }
    */
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let friendCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FriendCell
        
        if let friend = friends?[indexPath.item], let name = friend.name, let picture = friend.picture {
            friendCell.nameLabel.text = name
            clickedCellName = name
            print("yo ", clickedCellName)
            
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    
    
}

class FriendCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
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
    }
    
}
