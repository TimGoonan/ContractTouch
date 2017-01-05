//
//  Feed.swift
//  ContractTouch
//
//  Created by SDG1 on 11/3/16.
//  Copyright © 2016 GoonanCo. All rights reserved.
//
import UIKit

class Feed: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var nameArray = ["tim", "bob", "joe"]
    var priceArray = ["5.00","8.50","1.00"]
    var messageArray = ["5 bucks on the cubs game","I dare you to ding dong ditch","Yo do my laundry tonight please"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FeedCell
        //cell.layer.borderColor = UIColor.blackColor().CGColor
        cell.senderLabel?.text = nameArray[indexPath.row]
        cell.recipientLabel?.text = nameArray[indexPath.row]
        cell.priceLabel?.text = priceArray[indexPath.row]
        cell.messageView?.text = messageArray[indexPath.row]
        
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

class FeedCell: UITableViewCell {
    
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var recipientLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var messageView: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
