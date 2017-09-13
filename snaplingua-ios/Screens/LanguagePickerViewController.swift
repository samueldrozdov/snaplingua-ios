//
//  LanguagePickerViewController.swift
//  snaplingua-ios
//
//  Created by Samuel Drozdov on 9/10/17.
//  Copyright © 2017 SnapLingua. All rights reserved.
//

import UIKit

class LanuagePickerViewController: UIViewController, UITableViewDelegate {
  
  @IBOutlet weak var languagePickerTableView: LanguagePickerTableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    languagePickerTableView.delegate = self;
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    SLLanguageManager.shared.setTargetLanguage(language: getAlphabetizedListOfLanguages()[indexPath.row])
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func pressedCancel(_ sender: UIBarButtonItem) {
    self.dismiss(animated: true, completion: nil)
  }
}

class LanguagePickerTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
  
  let languages: [String] = getAlphabetizedListOfLanguages()
  let sourceLanguage: String = SLLanguageManager.shared.getSourceLanguage()
  let targetLanguage: String = SLLanguageManager.shared.getTargetLanguage()
  var selectedIndex: NSInteger = -1
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.selectedIndex = languages.index(of: targetLanguage)!
    
    self.delegate = self
    self.dataSource = self
    
    self.tableFooterView = UIView()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return languages.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = self.dequeueReusableCell(withIdentifier: "LanguageCell", for:indexPath)
    
    cell.textLabel?.text = getFlagForLanguage(languageName: languages[indexPath.row]) + " " + getNameForLanguage(languageName: languages[indexPath.row])
    
    if selectedIndex == indexPath.row {
      cell.accessoryType = .checkmark
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }
}
