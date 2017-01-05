//
//  FriendTableController.swift
//  ContractTouch
//
//  Created by SDG1 on 10/13/16.
//  Copyright © 2016 GoonanCo. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class FriendTableController: UITableViewController {
    
    var friends: [Friend]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.backgroundColor = UIColor.white
    }
    
    func tableView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(friends as Any)
        return friends != nil ? friends!.count : 0
    }
    
    func tableView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        let friendCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FriendCell
        
        if let friend = friends?[indexPath.item], let name = friend.name, let picture = friend.picture {
            friendCell.nameLabel.text = name
            
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

class FriendTableCell: UITableViewCell {
    
    
    
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
