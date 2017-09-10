//
//  SLLogging.swift
//  SnapLingua
//
//  Created by Samuel Drozdov on 9/9/17.
//  Copyright © 2017 SnapLingua. All rights reserved.
//

import Foundation

func DLog(message: String, function: String = #function) {
  #if DEBUG
    print("\(function): \(message)")
  #endif
}
