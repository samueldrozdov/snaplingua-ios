//
//  SLLanguageManager.swift
//  snaplingua-ios
//
//  Created by Samuel Drozdov on 9/12/17.
//  Copyright © 2017 SnapLingua. All rights reserved.
//

import Foundation

struct LanguageNames {
  static let Arabic       = "Arabic"
  static let Chinese      = "Chinese"
  static let French       = "French"
  static let Greek        = "Greek"
  static let Hebrew       = "Hebrew"
  static let Hindi        = "Hindi"
  static let Japanese     = "Japanese"
  static let Portuguese   = "Portuguese"
  static let Russian      = "Russian"
  static let Spanish      = "Spanish"
  static let Swedish      = "Swedish"
}

struct LanguageKeys {
  static let Name      = "name"
  static let Google    = "googleCode"
  static let Apple     = "appleCode"
  static let Flag      = "flag"
}

let languageDictionary = [
  "Arabic": [
    "name" : "Arabic",
    "googleCode" : "ar",
    "appleCode" : "ar-SA",
    "flag" : "🇸🇦"
  ],
  "Chinese": [
    "name" : "Chinese",
    "googleCode" : "zh",
    "appleCode" : "zh-CN",
    "flag" : "🇨🇳"
  ],
  "French": [
    "name" : "French",
    "googleCode" : "es",
    "appleCode" : "fr-FR",
    "flag" : "🇫🇷"
  ],
  "Greek": [
    "name" : "Greek",
    "googleCode" : "el",
    "appleCode" : "el-GR",
    "flag" : "🇬🇷"
  ],
  "Hebrew": [
    "name" : "Hebrew",
    "googleCode" : "iw",
    "appleCode" : "he-IL",
    "flag" : "🇮🇱"
  ],
  "Hindi": [
    "name" : "Hindi",
    "googleCode" : "hi",
    "appleCode" : "he-IL",
    "flag" : "🇮🇳"
  ],
  "English": [
    "name" : "English",
    "googleCode" : "en",
    "appleCode" : "en",
    "flag" : "🇺🇸"
  ],
  "Japanese": [
    "name" : "Japanese",
    "googleCode" : "ja",
    "appleCode" : "sv-SE",
    "flag" : "🇯🇵"
  ],
  "Portuguese": [
    "name" : "Portuguese",
    "googleCode" : "pt",
    "appleCode" : "pt-BR",
    "flag" : "🇧🇷"
  ],
  "Russian": [
    "name" : "Russian",
    "googleCode" : "ru",
    "appleCode" : "ru-RU",
    "flag" : "🇷🇺"
  ],
  "Spanish": [
    "name" : "Spanish",
    "googleCode" : "es",
    "appleCode" : "es-ES",
    "flag" : "🇪🇸"
  ],
  "Swedish": [
    "name" : "Swedish",
    "googleCode" : "sv",
    "appleCode" : "sv-SE",
    "flag" : "🇸🇪"
  ],
]

func isLanguageIncluded(language: String) -> Bool {
  return languageDictionary[language] != nil
}

func getAlphabetizedListOfLanguages() -> [String] {
  return languageDictionary.keys.sorted() as [String]
}

func getNameForLanguage(languageName: String) -> String {
  guard let name = languageDictionary[languageName]?[LanguageKeys.Name] else {
    DLog(message: "No flag for \(languageName)")
    return ""
  }
  return name
}

func getGoogleCodeForLanguage(languageName: String) -> String {
  guard let code = languageDictionary[languageName]?[LanguageKeys.Google] else {
    DLog(message: "No Google code for \(languageName)")
    return ""
  }
  return code
}

func getAppleCodeForLanguage(languageName: String) -> String {
  guard let code = languageDictionary[languageName]?[LanguageKeys.Apple] else {
    DLog(message: "No Apple code for \(languageName)")
    return ""
  }
  return code
}

func getFlagForLanguage(languageName: String) -> String {
  guard let flag = languageDictionary[languageName]?[LanguageKeys.Flag] else {
    DLog(message: "No flag for \(languageName)")
    return ""
  }
  return flag
}




