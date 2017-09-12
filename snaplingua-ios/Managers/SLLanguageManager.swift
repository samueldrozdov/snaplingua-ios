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
  
  // TODO: finish
  func getActiveSourceLanguage() -> String {
    return ""
  }
  
  // TODO: finish
  func getActiveTargetLanguage() -> String {
    return ""
  }
  
  func getTranslation(forString text: String, fromLanguage source: String, toLanguage target: String, completion: @escaping (_ result: String) -> Void) {
    
    let translator = ROGoogleTranslate()
    translator.apiKey = GV_IMAGE_API_KEY
    
    let params = ROGoogleTranslateParams(source: source,
                                         target: target,
                                         text: text)
    
    translator.translate(params: params) { (result) in
      completion(result)
    }
  }
}
