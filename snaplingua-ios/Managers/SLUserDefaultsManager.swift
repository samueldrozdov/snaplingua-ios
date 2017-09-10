//
//  SLUserDefaultsManager.swift
//  snaplingua-ios
//
//  Created by Samuel Drozdov on 9/10/17.
//  Copyright © 2017 SnapLingua. All rights reserved.
//

import UIKit

let WORDS_KEY = "wordsKeys"
let LANGUAGE_INDEX_KEY = "languageIndexKey"

final class SLUserDefaultsManager: NSObject {

  static let shared = SLUserDefaultsManager()
  private override init() { }
  
  func addImageWithWord(word: String, image: UIImage) {
    let prevWords = getPreviousWords() as NSMutableArray
    
    let wordDictionary = NSMutableDictionary()
    let imageData = UIImageJPEGRepresentation(image, 0.3)
    wordDictionary.setObject(imageData!, forKey: "image" as NSCopying)
    wordDictionary.setObject(word, forKey: "word" as NSCopying)
    
    prevWords.insert(wordDictionary, at: 0)

    UserDefaults.standard.set(NSArray(array: prevWords), forKey: WORDS_KEY)
    UserDefaults.standard.synchronize()
  }

  func getPreviousWords() -> NSMutableArray {
    var words = NSMutableArray()
    if (UserDefaults.standard.object(forKey: WORDS_KEY) != nil) {
      words = NSMutableArray(array: UserDefaults.standard.object(forKey: WORDS_KEY) as! NSArray)
    }
    return words
  }
  
  func deleteWordAtIndex(index: NSInteger) {
    let prevWords = getPreviousWords() as NSMutableArray
    prevWords.removeObject(at: index)
    UserDefaults.standard.set(NSArray(array: prevWords), forKey: WORDS_KEY)
    UserDefaults.standard.synchronize()
  }
  
  func setLanguage(index: NSInteger) {
    UserDefaults.standard.set(index, forKey: LANGUAGE_INDEX_KEY)
    UserDefaults.standard.synchronize()
  }
  
  func getLanguageIndex() -> NSInteger {
    return UserDefaults.standard.integer(forKey: LANGUAGE_INDEX_KEY)
  }
  
}
