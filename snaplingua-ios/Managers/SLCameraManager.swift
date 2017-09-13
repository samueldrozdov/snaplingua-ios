//
//  SLCameraManager.swift
//  snaplingua-ios
//
//  Created by Samuel Drozdov on 9/12/17.
//  Copyright © 2017 SnapLingua. All rights reserved.
//

import UIKit
import AVFoundation

final class SLCameraManager: NSObject {
  
  static let shared = SLCameraManager()
  private override init() { }
  
  func didRequestCameraPermission() -> Bool {
    return UserDefaults.standard.bool(forKey: UserDefaultKeys.Camera.Requested)
  }
  
  private func setReqestedCameraPermission() {
    UserDefaults.standard.set(true, forKey: UserDefaultKeys.Camera.Requested)
  }
  
  func didUserGrantCameraPermission(completion: @escaping (_ granted: Bool) -> Void)  {
    if AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) == AVAuthorizationStatus.authorized {
      completion(true)
    } else {
      AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: {
        (granted: Bool) -> Void in
        self.setReqestedCameraPermission()
        if granted == true {
          completion(true)
        } else {
          completion(false)
        }
      })
    }
  }
  
  func getCameraDeniedAlert() -> UIAlertController {
    let alert = UIAlertController(title: "Enable Your Camera", message: "SnapLingua is better with your camera.", preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "Settings", style: .cancel) { alert in
      UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, completionHandler: nil)
    })
    alert.addAction(UIAlertAction(title: "Cancel", style: .default))
    return alert
  }
  
}
