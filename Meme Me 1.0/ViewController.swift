//
//  ViewController.swift
//  Meme Me 1.0
//
//  Created by Sushma Adiga on 03/05/21.
//

import UIKit



class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topViewTextField: UITextField!
    @IBOutlet weak var bottomViewTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
           NSAttributedString.Key.strokeColor: UIColor.black,
           NSAttributedString.Key.foregroundColor: UIColor.black,
           NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth:  3.0
       ]
    
    var activeTextField = UITextField()
    let topDelegate = TopViewTextFieldDelegate()
    let bottomDelegate = BottomViewTextFieldDelegate()
    
    struct Meme {
            var topText : String
            var bottomText : String
            var originalImage : UIImage
            var memedImage : UIImage
        }
    
    var cameraEligibleDevice = UIImagePickerController.isSourceTypeAvailable(.camera)
        var cameraAllowed = false
        var photoAllowed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.topViewTextField.delegate = self
        self.bottomViewTextField.delegate = self
        topViewTextField.textAlignment = .center
        bottomViewTextField.textAlignment = .center
         
        topViewTextField.defaultTextAttributes = memeTextAttributes
        bottomViewTextField.defaultTextAttributes = memeTextAttributes
        
        }
    
    
    @IBAction func pickAnImage(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = .photoLibrary
        pickerController.delegate = self
        pickerController.allowsEditing = true
        
        present(pickerController, animated: true, completion: nil)
        
        shareButton.isEnabled = true
    }
    
    func camera() {
               let myPickerControllerCamera = UIImagePickerController()
               myPickerControllerCamera.delegate = self
               myPickerControllerCamera.sourceType = UIImagePickerController.SourceType.camera
               myPickerControllerCamera.allowsEditing = true
               self.present(myPickerControllerCamera, animated: true, completion: nil)
           }
    
    func gallery() {
           let myPickerControllerGallery = UIImagePickerController()
           myPickerControllerGallery.delegate = self
           myPickerControllerGallery.sourceType = UIImagePickerController.SourceType.photoLibrary
           myPickerControllerGallery.allowsEditing = true
           self.present(myPickerControllerGallery, animated: true, completion: nil)
       }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.editedImage] as? UIImage  {
                imagePickerView.image = image
            }
           
        picker.dismiss(animated: true)
        }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
     func pickAnImageFromAlbum(_ sender: Any) {

           let imagePicker = UIImagePickerController()
           imagePicker.delegate = self
          imagePicker.sourceType = .photoLibrary
           present(imagePicker, animated: true, completion: nil)
       }
    
     func pickAnImageFromCamera(_ sender: Any) {

           let imagePicker = UIImagePickerController()
           imagePicker.delegate = self
           imagePicker.sourceType = .camera
           present(imagePicker, animated: true, completion: nil)
        
            shareButton.isEnabled = true
       }
    
    override func viewWillAppear(_ animated: Bool) {
            cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
            super.viewWillAppear(animated)
            subscribeToKeyboardNotifications()
            shareButton.isEnabled = false
        }
  
    func textFieldDidBeginEditing(_ textField: UITextField) {
           textField.text = ""
           self.activeTextField = textField
           
       }
       
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.resignFirstResponder()
           
           return true;
       }
    
    override func viewWillDisappear(_ animated: Bool) {

           super.viewWillDisappear(animated)
           unsubscribeFromKeyboardNotifications()
       }
       
       func subscribeToKeyboardNotifications() {

           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
           
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

       }

       func unsubscribeFromKeyboardNotifications() {

           NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
           
           NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
       }
       
      @objc func keyboardWillShow(_ notification:Notification) {
           
           if (self.activeTextField == topViewTextField) {
               view.frame.origin.y -= 0
           }
           else {
                view.frame.origin.y -= getKeyboardHeight(notification)
           }
       }
       
       @objc func keyboardWillHide(_ notification:Notification) {

             view.frame.origin.y = 0
       }

       func getKeyboardHeight(_ notification:Notification) -> CGFloat {

           let userInfo = notification.userInfo
           let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
           return keyboardSize.cgRectValue.height
       }
    
    func presentActionAlert() {
        
        let actionSheetController: UIAlertController = UIAlertController(title: NSLocalizedString("Upload Image", comment: ""), message: nil, preferredStyle: .actionSheet)
        actionSheetController.view.tintColor = UIColor.black
        
        let cancelActionButton: UIAlertAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { action -> Void in
        }
        
        let cameraActionButton: UIAlertAction = UIAlertAction(title: NSLocalizedString("Take Photo", comment: ""), style: .default)
            { action -> Void in self.camera()
            }
        
        let galleryActionButton: UIAlertAction = UIAlertAction(title: NSLocalizedString("Choose From Gallery", comment: ""), style: .default)
            { action -> Void in self.gallery()
            }
        
        actionSheetController.addAction(cancelActionButton)
        actionSheetController.addAction(galleryActionButton)
            
            if cameraEligibleDevice {
                actionSheetController.addAction(cameraActionButton)
            }
        
        self.present(actionSheetController, animated: true, completion: nil)
        }
       
    func save() {
                
        let _ = Meme(topText: topViewTextField.text!, bottomText: bottomViewTextField.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
        }
    
    func generateMemedImage() -> UIImage {
           
          
           self.navigationController?.toolbar.isHidden = true
           self.navigationController?.navigationBar.isHidden = true
           
           
           UIGraphicsBeginImageContext(self.view.frame.size)
           view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
           let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
           UIGraphicsEndImageContext()
           
          
           self.navigationController?.toolbar.isHidden = false
           self.navigationController?.navigationBar.isHidden = false

           return memedImage
       }
    
    @IBAction func shareMeme(_ sender: Any) {
           let image = generateMemedImage()
           let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
           present(controller, animated: true, completion: nil)
           
           controller.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed:
           Bool, arrayReturnedItems: [Any]?, error: Error?) in
               if completed {
                   self.save()
                   print("saved")
                   return
               } else {
                   print("cancel")
               }
               if let shareError = error {
                   print("error while sharing: \(shareError.localizedDescription)")
               }
           }
    
    }
    
}





