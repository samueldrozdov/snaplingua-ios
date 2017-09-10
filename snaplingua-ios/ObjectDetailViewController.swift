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
    self.wordImageView.image = wordImage
  }
  
  @IBAction func pressedListen(_ sender: UIBarButtonItem) {
    let utterance = AVSpeechUtterance(string: wordTranslate)
    let languageCodeApple = languageCodesApple[SLUserDefaultsManager.shared.getLanguageIndex()]
    utterance.voice = AVSpeechSynthesisVoice(language: languageCodeApple)
    
    let synth = AVSpeechSynthesizer()
    synth.speak(utterance)
  }
}
