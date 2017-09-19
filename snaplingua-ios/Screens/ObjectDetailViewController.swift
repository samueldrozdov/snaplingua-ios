//
//  ObjectDetailViewController.swift
//  snaplingua-ios
//
//  Created by Samuel Drozdov on 9/10/17.
//  Copyright © 2017 SnapLingua. All rights reserved.
//

import UIKit
import AVFoundation

class ObjectDetailViewController: UIViewController {
  
  @IBOutlet weak var wordImageView: UIImageView!
  var wordImage: UIImage = UIImage()
  var wordOrig: String = ""
  var wordTranslate: String = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    wordImageView.image = wordImage
  }
  
  @IBAction func pressedListen(_ sender: Any) {
    speak()
  }
  
  @IBAction func pressedShow(_ sender: UIBarButtonItem) {
    let alert = UIAlertController(title: wordOrig, message: "", preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "Got it", style: UIAlertActionStyle.default, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
  
  func speak() {
    let utterance = AVSpeechUtterance(string: wordTranslate)
    utterance.voice = AVSpeechSynthesisVoice(language: getAppleCodeForLanguage(languageName:  SLLanguageManager.shared.getTargetLanguage()))
    utterance.rate = 0.4
    
    let synth = AVSpeechSynthesizer()
    synth.speak(utterance)
  }
}
