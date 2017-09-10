//
//  ObjectDetailViewController.swift
//  snaplingua-ios
//
//  Created by Samuel Drozdov on 9/10/17.
//  Copyright © 2017 SnapLingua. All rights reserved.
//

import UIKit

class ObjectDetailViewController: UIViewController {
  
  @IBOutlet weak var wordImageView: UIImageView!
  var wordImage: UIImage = UIImage()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.wordImageView.image = wordImage
  }
  
}
