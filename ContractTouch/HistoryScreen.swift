//
//  HistoryScreen.swift
//  ContractTouch
//
//  Created by SDG1 on 10/6/16.
//  Copyright © 2016 GoonanCo. All rights reserved.
//

import UIKit

class HistoryScreen: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var nameArray = ["tim", "bob", "joe"]
    var dateArray = ["01/01/2001","01/01/2010","01/01/2016"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        //cell.layer.borderColor = UIColor.blackColor().CGColor
        cell.nameTxt?.text = nameArray[indexPath.row]
        cell.dateTxt?.text = dateArray[indexPath.row]
        cell.resultTxt?.text = "Accepted"        
        
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
