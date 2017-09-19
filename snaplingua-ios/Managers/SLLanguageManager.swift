//
//  SLLanguageManager.swift
//  snaplingua-ios
//
//  Created by Samuel Drozdov on 9/12/17.
//  Copyright © 2017 SnapLingua. All rights reserved.
//

import Foundation
import ROGoogleTranslate

final class SLLanguageManager: NSObject {
  
  static let shared = SLLanguageManager()
  private override init() { }
  
  func getSourceLanguage() -> String {
    guard let language = UserDefaults.standard.object(forKey: UserDefaultKeys.Languages.Source) else {
      return "English"
    }
    return language as! String
  }
  
  @discardableResult func setSourceLanguage(language: String) -> Bool {
    if isLanguageIncluded(language: language) == false {
      DLog(message: "Failed to set source language. Language not available.")
      return false
    }
    UserDefaults.standard.set(language, forKey: UserDefaultKeys.Languages.Source)
    return true
  }
  
  func getTargetLanguage() -> String {
    guard let language = UserDefaults.standard.object(forKey: UserDefaultKeys.Languages.Target) else {
      return "Russian"
    }
    return language as! String
  }
  
  @discardableResult func setTargetLanguage(language: String) -> Bool {
    if isLanguageIncluded(language: language) == false {
      DLog(message: "Failed to set target language. Language not available.")
      return false
    }
    UserDefaults.standard.set(language, forKey: UserDefaultKeys.Languages.Target)
    return true
  }
  
  func getTranslation(forString text: String, fromLanguage source: String, toLanguage target: String, completion: @escaping (_ result: String) -> Void) {
    
    let translator = ROGoogleTranslate()
    translator.apiKey = GV_IMAGE_API_KEY
    
    let params = ROGoogleTranslateParams(source: getGoogleCodeForLanguage(languageName: source),
                                         target: getGoogleCodeForLanguage(languageName: target),
                                         text: text)
    var completed = false
    translator.translate(params: params) { (result) in
      completed = true
      completion(result)
    }
    if completed == false {
      completion("")
    }
  }
  
  func getTranslationForActive(forString text: String, completion: @escaping (_ result: String) -> Void) {
    getTranslation(forString: text,
                   fromLanguage: SLLanguageManager.shared.getSourceLanguage(),
                   toLanguage: SLLanguageManager.shared.getTargetLanguage(),
                   completion: { (result) in
      completion(result)
    })
  }
}
