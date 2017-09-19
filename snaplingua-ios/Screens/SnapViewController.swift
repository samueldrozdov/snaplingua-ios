//
//  SnapViewController.swift
//  snaplingua-ios
//
//  Created by Samuel Drozdov on 9/9/17.
//  Copyright © 2017 SnapLingua. All rights reserved.
//

import UIKit
import AVFoundation
import Hero

class SnapViewController: UIViewController, AVCapturePhotoCaptureDelegate, GCImageRequestManagerDelegate, UITableViewDelegate {
  
  @IBOutlet weak var captureButton: UIButton!
  @IBOutlet weak var previewView: UIView!
  @IBOutlet weak var captureActivityIndicatorBackground: UIView!
  @IBOutlet weak var captureActivityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var selectObjectViewContainer: UIView!
  @IBOutlet weak var selectObjectViewControllerBottom: NSLayoutConstraint!
  @IBOutlet weak var selectObjectTableView: SelectObjectTableView!
  
  var captureSession: AVCaptureSession?
  var videoPreviewLayer: AVCaptureVideoPreviewLayer?
  var capturePhotoOutput: AVCapturePhotoOutput?
  
  var imageRequestManager: GVImageRequestManager?
  var capturedImage: UIImage?
  var capturedLabels: NSArray?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    previewView.heroID = "snapButton"
    isHeroEnabled = true
    
    imageRequestManager = GVImageRequestManager()
    imageRequestManager?.delegate = self
    
    captureButton.clipsToBounds = true
    captureButton.backgroundColor = UIColor.init(white: 1.0, alpha: 0.3)
    captureButton.layer.cornerRadius = captureButton.bounds.width / 2
    captureButton.layer.borderWidth = 4
    captureButton.layer.borderColor = UIColor.white.cgColor

    selectObjectViewContainer.layer.cornerRadius = 8
    selectObjectViewControllerBottom.constant = -selectObjectViewContainer.bounds.height
    
    captureActivityIndicatorBackground.layer.cornerRadius = 8;
    
    self.selectObjectTableView.delegate = self
    
    self.checkCamera()
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let cell = selectObjectTableView.cellForRow(at: indexPath)!
    let word = cell.textLabel?.text!
    SLUserDefaultsManager.shared.addImageWithWord(word: word!, image: capturedImage!)
    self.dismiss(animated: true, completion: nil)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 63
  }
  
  func hideSelectObjectView() {
    self.selectObjectViewControllerBottom.constant = -self.selectObjectViewContainer.bounds.height
    UIView.animate(withDuration: 0.3, animations: {
      self.selectObjectViewContainer.layoutIfNeeded()
    })
  }
  
  func showSelectObjectView() {
    self.selectObjectViewControllerBottom.constant = -8
    UIView.animate(withDuration: 0.3, animations: {
      self.selectObjectViewContainer.layoutIfNeeded()
    })
  }
  
  func startCaptureAnimation() {
    UIView.animate(withDuration: 0.3, animations: {
      self.captureButton.layer.opacity = 0
      self.captureActivityIndicatorBackground.layer.opacity = 1
      self.captureActivityIndicator.startAnimating()
    })
  }
  
  func endCaptureAnimation() {
    UIView.animate(withDuration: 0.3, animations: {
      self.captureButton.layer.opacity = 1
      self.captureActivityIndicatorBackground.layer.opacity = 0
      self.captureActivityIndicator.stopAnimating()
    })
  }
  
  @IBAction func pressedCancelButton(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func pressedCaptureButton(_ sender: UIButton) {
    guard let capturePhotoOutput = self.capturePhotoOutput else { return }
    
    let photoSettings = AVCapturePhotoSettings()
    photoSettings.isAutoStillImageStabilizationEnabled = true
    photoSettings.isHighResolutionPhotoEnabled = true
    photoSettings.flashMode = .auto
    
    capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)
  }
  
  func requestCompleted(_ manager: GVImageRequestManager, responseStatus: String, labels: NSArray) {
    self.endCaptureAnimation()
    
    if responseStatus == GVImageResponseStatus.RequestSucceededButUncertainLabels {
      let alert = UIAlertController(title: "Couldn't Identify Object", message: "Please take another photo.", preferredStyle: UIAlertControllerStyle.alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default))
      self.present(alert, animated: true, completion: nil)
    }
    else if responseStatus == GVImageResponseStatus.RequestFailed {
      let alert = UIAlertController(title: "Request Failed", message: "Please check you internet connection and try again.", preferredStyle: UIAlertControllerStyle.alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default))
      self.present(alert, animated: true, completion: nil)
    }
    else if responseStatus == GVImageResponseStatus.RequestSucceeded {
      capturedLabels = labels
      selectObjectTableView.reloadWithItems(items: capturedLabels!)
      self.showSelectObjectView()
    }
  }
  
  func capturedImage(image: UIImage) {
    self.startCaptureAnimation()
    
    captureSession?.stopRunning()
    
    capturedImage = image
    
    let binaryImageData = imageRequestManager?.base64EncodeImage(image)
    imageRequestManager?.createRequest(with: binaryImageData!)

    DLog(message: "capturedImage")
  }
  
  func capture(_ captureOutput: AVCapturePhotoOutput,
               didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?,
               previewPhotoSampleBuffer: CMSampleBuffer?,
               resolvedSettings: AVCaptureResolvedPhotoSettings,
               bracketSettings: AVCaptureBracketedStillImageSettings?,
               error: Error?) {
    
    guard error == nil, let photoSampleBuffer = photoSampleBuffer else {
      print("Error capturing photo: \(String(describing: error))")
      return
    }
    
    guard let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) else {
      return
    }
    
    let image = UIImage.init(data: imageData, scale: 1.0)
    self.capturedImage(image: image!)
  }
  
  func checkCamera() {
    SLCameraManager.shared.didUserGrantCameraPermission(completion: { (granted) in
      DispatchQueue.main.async {
        if granted {
          self.enableCamera()
        } else {
          let alert = SLCameraManager.shared.getCameraDeniedAlert()
          self.present(alert, animated: true, completion: nil)
        }
      }
    })
  }
  
  func enableCamera() {
    let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
    
    do {
      let captureInput = try AVCaptureDeviceInput(device: captureDevice)
      
      captureSession = AVCaptureSession()
      captureSession?.addInput(captureInput)
      
      capturePhotoOutput = AVCapturePhotoOutput()
      capturePhotoOutput?.isHighResolutionCaptureEnabled = true
      
      captureSession?.addOutput(capturePhotoOutput)
      
      videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
      videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
      videoPreviewLayer?.frame = previewView.layer.bounds
      previewView.layer.insertSublayer(videoPreviewLayer!, at: 0)
      
      captureSession?.startRunning()
    } catch {
      print(error)
    }
  }
}

class SelectObjectTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
  
  var items: NSArray = []
  var selectedLabel: String  = ""
  
  override func awakeFromNib() {
    super.awakeFromNib()
    items = NSArray()
    
    self.delegate = self
    self.dataSource = self

    self.tableFooterView = UIView()
  }
  
  public func reloadWithItems(items: NSArray) {
    self.items = items
    self.reloadData()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = self.dequeueReusableCell(withIdentifier: "SelectObjectCell", for:indexPath)
    
    cell.textLabel?.text = items[indexPath.row] as? String
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }
}


