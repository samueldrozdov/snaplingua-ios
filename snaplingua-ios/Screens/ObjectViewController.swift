//
//  ObjectViewController.swift
//  snaplingua-ios
//
//  Created by Samuel Drozdov on 9/9/17.
//  Copyright © 2017 SnapLingua. All rights reserved.
//

import UIKit

class ObjectViewController: UIViewController, UITableViewDelegate {
  
  @IBOutlet weak var snapButton: UIButton!
  @IBOutlet weak var objectListTableView: ObjectListTableView!
  
  var selectedWord: String = ""
  var selectedWordOrig: String = ""
  var selectedImage: UIImage = UIImage()
  var selectedIndexPath: IndexPath = IndexPath()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    snapButton.layer.cornerRadius = snapButton.bounds.width / 2
    snapButton.layer.shadowColor = UIColor.black.cgColor
    snapButton.layer.shadowOpacity = 0.25
    snapButton.layer.shadowRadius = snapButton.bounds.width / 2
    snapButton.layer.shadowPath = UIBezierPath(rect: snapButton.bounds).cgPath
    
    self.objectListTableView.delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    self.updateBarItemFlag()
    self.objectListTableView.reload()
  }
  
  func updateBarItemFlag() {
    self.navigationItem.leftBarButtonItem?.title = getFlagForLanguage(languageName: SLLanguageManager.shared.getTargetLanguage())
  }

  @IBAction func snapButtonPressed(_ sender: UIButton) {
    DLog(message: "pressed snap Button")
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell: ObjectTableViewCell = objectListTableView.cellForRow(at: indexPath) as! ObjectTableViewCell
    selectedImage = cell.wordImageView.image!
    selectedWord = cell.wordLabel.text!
    selectedIndexPath = indexPath
    
    let word = objectListTableView.words[indexPath.row] as! NSDictionary
    selectedWordOrig = (word["word"] as? String)!
    performSegue(withIdentifier: "ShowObjectDetail", sender: nil)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 140
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
    if tableView == objectListTableView {
      if objectListTableView.showedTranslationFailedAlert == false && objectListTableView.translationFailed {
        objectListTableView.showedTranslationFailedAlert = true
        
        let alert = UIAlertController(title: "Translation Failed", message: "Please check you internet connection and try again.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
      }
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ShowObjectDetail" {
      let viewController: ObjectDetailViewController = segue.destination as! ObjectDetailViewController
      viewController.wordImage = selectedImage
      viewController.wordTranslate = selectedWord
      viewController.wordOrig = selectedWordOrig
      viewController.title = selectedWord
      
      let backItem = UIBarButtonItem()
      backItem.title = "Back"
      navigationItem.backBarButtonItem = backItem
    }
    else if segue.identifier == "ShowLanguagePicker" {
      let backItem = UIBarButtonItem()
      backItem.title = "Cancel"
      navigationItem.backBarButtonItem = backItem
    }
  }
}

class ObjectListTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
  
  var words = NSArray()
  
  var translationFailed = false
  var showedTranslationFailedAlert = false
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.delegate = self
    self.dataSource = self
    
    self.separatorInset = .zero
    
    self.reload()
    
    self.refreshControl = UIRefreshControl()
    self.refreshControl?.attributedTitle = NSAttributedString(string: "")
    self.refreshControl?.addTarget(self, action: #selector(self.reload), for: UIControlEvents.valueChanged)
    self.addSubview(self.refreshControl!)
  }
  
  func reload() {
    translationFailed = false
    showedTranslationFailedAlert = false
    words = SLUserDefaultsManager.shared.getPreviousWords()
    self.reloadData()
    self.refreshControl?.endRefreshing()
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    let cell = self.cellForRow(at: indexPath)
    cell?.contentView.clipsToBounds = true;
    
    if editingStyle == .delete {
      SLUserDefaultsManager.shared.deleteWordAtIndex(index: indexPath.row)
      words = SLUserDefaultsManager.shared.getPreviousWords()
      self.deleteRows(at: [indexPath], with: .automatic)
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return words.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = self.dequeueReusableCell(withIdentifier: "ObjectCell", for:indexPath) as! ObjectTableViewCell
    
    let word = words[indexPath.row] as! NSDictionary
    
    cell.wordImageView?.image = UIImage(data:(word["image"] as! Data), scale:1.0)
    
    let wordText = word["word"] as! String
    cell.wordLabel?.text = wordText
    SLLanguageManager.shared.getTranslationForActive(forString:wordText) { (result) in
      if result == "" {
        self.translationFailed = true
      }
      else {
        DispatchQueue.main.async {
          cell.wordLabel?.text = result
        }
      }
    }
    
    return cell
  }
}

class ObjectTableViewCell: UITableViewCell {
  
  @IBOutlet weak var wordLabel: UILabel!
  @IBOutlet weak var wordImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    wordLabel.text = ""
  }
}
