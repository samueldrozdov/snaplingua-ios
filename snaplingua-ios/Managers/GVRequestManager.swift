//
//  GVRequest.swift
//  snaplingua-ios
//
//  Created by Samuel Drozdov on 9/9/17.
//  Copyright © 2017 SnapLingua. All rights reserved.
//

import UIKit
import SwiftyJSON

let GV_IMAGE_URL = "https://vision.googleapis.com/v1/images:annotate"

let PRIVATE_KEY_PATH = Bundle.main.path(forResource: "PrivateKeys", ofType: "plist")
let GV_IMAGE_API_KEY = NSDictionary(contentsOfFile: PRIVATE_KEY_PATH!)?["GOOGLE_API_KEY"] as! String

struct GVImageResponseStatus {
  static let RequestSucceeded                     = "RequestSucceeded"
  static let RequestFailed                        = "RequestFailed"
  static let RequestSucceededButUncertainLabels   = "RequestSucceededButUncertainLabels"
}

protocol GCImageRequestManagerDelegate: class {
  func requestCompleted(_ manager: GVImageRequestManager, responseStatus: String, labels: NSArray)
}

class GVImageRequestManager: NSObject {

  weak var delegate: GCImageRequestManagerDelegate?
    
  func resizeImage(_ imageSize: CGSize, image: UIImage) -> Data {
    UIGraphicsBeginImageContext(imageSize)
    image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    let resizedImage = UIImagePNGRepresentation(newImage!)
    UIGraphicsEndImageContext()
    return resizedImage!
  }

  func base64EncodeImage(_ image: UIImage) -> String {
    var imagedata = UIImagePNGRepresentation(image)
    
    // Resize the image if it exceeds the 2MB API limit
    if ((imagedata?.count)! > 2097152) {
      let oldSize: CGSize = image.size
      let newSize: CGSize = CGSize(width: 800, height: oldSize.height / oldSize.width * 800)
      imagedata = resizeImage(newSize, image: image)
    }
    
    return imagedata!.base64EncodedString(options: .endLineWithCarriageReturn)
  }

  func createRequest(with imageBase64: String) {
    // Create our request URL
    let requestURLString = GV_IMAGE_URL + "?key=" + GV_IMAGE_API_KEY
    let requestURL = URL(string: requestURLString)
    
    var request = URLRequest(url: requestURL!)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "X-Ios-Bundle-Identifier")
    
    // Build our API request
    let jsonRequest = [
      "requests": [
        "image": [
          "content": imageBase64
        ],
        "features": [
          [
            "type": "LABEL_DETECTION",
            "maxResults": 10
          ]
        ]
      ]
    ]
    
    let jsonObject = JSON(jsonDictionary: jsonRequest)
    
    // Serialize the JSON
    guard let data = try? jsonObject.rawData() else {
      return
    }
    
    request.httpBody = data
    
    // Run the request on a background thread
    DispatchQueue.global().async { self.runRequestOnBackgroundThread(request) }
  }

  func runRequestOnBackgroundThread(_ request: URLRequest) {
    DLog(message: "making request...")
    
    let session = URLSession.shared
    let task: URLSessionDataTask = session.dataTask(with: request) { (data, response, error) in
      guard let data = data, error == nil else {
        print(error?.localizedDescription ?? "")
        DispatchQueue.main.async(execute: {
          self.delegate?.requestCompleted(self, responseStatus: GVImageResponseStatus.RequestFailed, labels: [])
        })
        return
      }
      
      self.analyzeResults(data)
    }
    
    task.resume()
  }

  func analyzeResults(_ dataToParse: Data) {
    DLog(message: "analyzing results...")
    
    DispatchQueue.main.async(execute: {
      
      let json = JSON(data: dataToParse)
      let errorObj: JSON = json["error"]
      
      if (errorObj.dictionaryValue != [:]) {
        self.delegate?.requestCompleted(self, responseStatus: GVImageResponseStatus.RequestFailed, labels: [])
      } else {
        print(json)
        
        let labels = json["responses"][0]["labelAnnotations"]
        let validLabels = NSMutableArray()
        
        for label in labels {
          let labelName = label.1["description"].string
          validLabels.add(labelName!)
        }
        
        if validLabels.count > 0 {
          self.delegate?.requestCompleted(self, responseStatus: GVImageResponseStatus.RequestSucceeded, labels: validLabels)
        }
        else {
          self.delegate?.requestCompleted(self, responseStatus: GVImageResponseStatus.RequestSucceededButUncertainLabels, labels: validLabels)
        }
      }
    })
    
  }
}
