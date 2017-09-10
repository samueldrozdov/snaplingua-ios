//
//  ObjectViewController.swift
//  snaplingua-ios
//
//  Created by Samuel Drozdov on 9/9/17.
//  Copyright © 2017 SnapLingua. All rights reserved.
//

import UIKit

class ObjectViewController: UIViewController {
  
  @IBOutlet weak var snapButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    snapButton.layer.cornerRadius = snapButton.bounds.width / 2
    snapButton.layer.shadowColor = UIColor.black.cgColor
    snapButton.layer.shadowOpacity = 0.3
    snapButton.layer.shadowRadius = snapButton.bounds.width / 2
    snapButton.layer.shadowPath = UIBezierPath(rect: snapButton.bounds).cgPath

  }

  @IBAction func snapButtonPressed(_ sender: UIButton) {
    DLog(message: "pressed button")
  }
}

class ObjectListTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
  
  var words = NSArray()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.delegate = self
    self.dataSource = self
    
    self.separatorInset = .zero
    
    words = SLUserDefaultsManager().getPreviousWords()
    self.reloadData()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return words.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = self.dequeueReusableCell(withIdentifier: "ObjectCell", for:indexPath) as! ObjectTableViewCell
    
    let word = words[indexPath.row] as! NSDictionary
    
    cell.wordImageView?.image = UIImage(data:(word["image"] as! Data), scale:1.0)
    cell.wordLabel?.text = word["word"] as? String
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 84
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("You tapped cell number \(indexPath.row).")
  }
}

class ObjectTableViewCell: UITableViewCell {
  
  @IBOutlet weak var wordLabel: UILabel!
  @IBOutlet weak var wordImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
}
