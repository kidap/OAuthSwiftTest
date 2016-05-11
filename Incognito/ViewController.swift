//
//  ViewController.swift
//  Incognito
//
//  Created by Corinne Krych on 28/02/15.
//  Copyright (c) 2015 raywenderlich. All rights reserved.
//

import UIKit
import MobileCoreServices
import AssetsLibrary

// TODO add import OAuthSwift
import OAuthSwift

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
  var imagePicker = UIImagePickerController()
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var hatImage: UIImageView!
  @IBOutlet weak var glassesImage: UIImageView!
  @IBOutlet weak var moustacheImage: UIImageView!
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  // MARK: - Gesture Action
  
  @IBAction func move(recognizer: UIPanGestureRecognizer) {
    //return
    let translation = recognizer.translationInView(self.view)
    recognizer.view!.center = CGPoint(x:recognizer.view!.center.x + translation.x,
      y:recognizer.view!.center.y + translation.y)
    recognizer.setTranslation(CGPointZero, inView: self.view)
  }
  
  @IBAction func pinch(recognizer: UIPinchGestureRecognizer) {
    recognizer.view!.transform = CGAffineTransformScale(recognizer.view!.transform,
      recognizer.scale, recognizer.scale)
    recognizer.scale = 1
  }
  
  @IBAction func rotate(recognizer: UIRotationGestureRecognizer) {
    recognizer.view!.transform = CGAffineTransformRotate(recognizer.view!.transform, recognizer.rotation)
    recognizer.rotation = 0
    
  }
  
  // MARK: - Menu Action
  
  @IBAction func openCamera(sender: AnyObject) {
    openPhoto()
  }
  
  @IBAction func hideShowHat(sender: AnyObject) {
    hatImage.hidden = !hatImage.hidden
  }
  
  @IBAction func hideShowGlasses(sender: AnyObject) {
    glassesImage.hidden = !glassesImage.hidden
  }
  
  @IBAction func hideShowMoustache(sender: AnyObject) {
    moustacheImage.hidden = !moustacheImage.hidden
  }
  
  @IBAction func share(sender: AnyObject) {
    // TODO implement share method
    let oauthswift = OAuth2Swift(consumerKey: "527780956271-uilmvmkbmed5s4hn1r4icis2e6iskpkk.apps.googleusercontent.com",
                                 consumerSecret: "1ympZ7yzrdEW_apPyllZPeqS",
                                 authorizeUrl: "https://accounts.google.com/o/oauth2/auth",
                                 accessTokenUrl: "https://accounts.google.com/o/oauth2/token",
                                 responseType: "code")
    
    
    oauthswift.authorizeWithCallbackURL(NSURL(string: "com.access.IncognitoTwo:/oauth2Callback")!,
                                        scope: "https://www.googleapis.com/auth/drive",
                                        state: "",
                                        success: { (data, response, parameters) in
                                          //do{
                                          //let jsonObject: AnyObject =  try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)
                                            self.presentAlert("Success", message: "Successfully uploaded!")
                                          //} catch {
                                          //  self.presentAlert("Error", message: "Error while parsing JSON")
                                          //}
      }) { (error) in
        self.presentAlert("Error", message: error.localizedDescription)
    }
    
    
  }
  
  // MARK: - UIImagePickerControllerDelegate
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    imagePicker.dismissViewControllerAnimated(true, completion: nil)
    imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
  }
  
//  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
//
//  }
  
  // MARK: - UIGestureRecognizerDelegate
  
  func gestureRecognizer(gesture: UIGestureRecognizer,
    shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
      return true
  }
  
  // MARK: - Private functions
  
  private func openPhoto() {
    imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
    imagePicker.delegate = self
    presentViewController(imagePicker, animated: true, completion: nil)
  }
  
  func presentAlert(title: String, message: String) {
    var alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
    self.presentViewController(alert, animated: true, completion: nil)
  }
  
  func snapshot() -> NSData {
    UIGraphicsBeginImageContext(self.view.frame.size)
    self.view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
    let fullScreenshot = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    UIImageWriteToSavedPhotosAlbum(fullScreenshot, nil, nil, nil)
    return UIImageJPEGRepresentation(fullScreenshot, 0.5)!
  }
  
}

