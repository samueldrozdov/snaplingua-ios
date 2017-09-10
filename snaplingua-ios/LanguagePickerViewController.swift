//
//  LanguagePickerViewController.swift
//  snaplingua-ios
//
//  Created by Samuel Drozdov on 9/10/17.
//  Copyright © 2017 SnapLingua. All rights reserved.
//

import UIKit

let languageCodes: [String] = ["es", "ru", "sv", "ja", "el", "fr", "iw"]
let languageNames: [String] = ["Spanish", "Russian", "Swedish", "Japanese", "Greek", "French", "Hebrew"]
let languageFlags: [String] = ["🇪🇸", "🇷🇺", "🇸🇪", "🇯🇵", "🇬🇷", "🇫🇷", "🇮🇱"]
let languageCodesApple: [String] = ["es-ES", "ru-RU", "sv-SE", "ja-JP", "el-GR", "fr-FR", "he-IL"]


class LanuagePickerViewController: UIViewController, UITableViewDelegate {
  
  @IBOutlet weak var languagePickerTableView: LanguagePickerTableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    languagePickerTableView.delegate = self;
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    SLUserDefaultsManager.shared.setLanguage(index: indexPath.row)
    self.dismiss(animated: true, completion: nil)
  }
  @IBAction func pressedCancel(_ sender: UIBarButtonItem) {
    self.dismiss(animated: true, completion: nil)
  }
}

class LanguagePickerTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
  
  var selectedIndex: NSInteger = -1
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.selectedIndex = SLUserDefaultsManager.shared.getLanguageIndex()
    
    self.delegate = self
    self.dataSource = self
    
    self.tableFooterView = UIView()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return languageCodes.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = self.dequeueReusableCell(withIdentifier: "LanguageCell", for:indexPath)
    
    cell.textLabel?.text = languageFlags[indexPath.row] + " " + languageNames[indexPath.row]
    
    if selectedIndex == indexPath.row {
      cell.accessoryType = .checkmark
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }
}
