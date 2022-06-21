//
//  ImagePicker.swift
//  Bryte
//
//  Created by Navroz Huda on 30/07/19.
//  Copyright © 2019 Bryte. All rights reserved.
//

import Foundation
import UIKit
import Photos
import MobileCoreServices

class ImagePicker: NSObject, UINavigationControllerDelegate {
    
    // MARK: - Shared Instance
    
    /// Shared instance of the ImagePicker class
    public static let shared = ImagePicker()
    
    // MARK: - Private Properties
    
    /// typealias block of the conpletion. which has the param of UIImagePickerController and selected info dictionary which can be null.
    typealias ImagePickerCompletionBlock = (UIImagePickerController, [UIImagePickerController.InfoKey: Any]?) -> Void
    
    /// Property of the Completion Block
    fileprivate var didCompletePicking: ImagePickerCompletionBlock?
    
    /// Object of the ImagePicker Controller
    fileprivate var imagePicker: UIImagePickerController
    var image = kUTTypeImage as String
    var video = kUTTypeMovie as String
    override init() {
        imagePicker = UIImagePickerController()
        super.init()
        imagePicker.modalPresentationStyle = UIModalPresentationStyle.currentContext
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.videoQuality = .type640x480
        imagePicker.videoMaximumDuration = TimeInterval(90.0)
        if #available(iOS 11.0, *) {
            imagePicker.videoExportPreset = AVAssetExportPreset640x480
        }
        imagePicker.videoMaximumDuration = (60 * 30) // Max duration = 30 mins
    }
    
    // MARK: - Public Method
    
    /// This method will use to select image form native gallery or to capture using camera. ActionSheet will be displayed with these two options and further operation will be execured based on user's selection.
    ///
    /// - Parameters:
    ///   - controller: Object of controller from which you need to display Image Picker
    ///   - completion: Completion block will be called when user has selected image or operation will be completed.
    public func showImagePicker(_ controller: UIViewController, sender: UIView? = nil, type: [String], isEditing: Bool = true ,openGallary:Bool = false, completion : @escaping ImagePickerCompletionBlock) {

        
        if openGallary{
            self.usePhotoLibrary(controller, type: type, isEditing: isEditing)
            didCompletePicking = completion
            return
        }
        // Assign the Block
       
        didCompletePicking = completion
        // Set Message
        let strMessage = ""//Localizable.AlertMsg.selectOptions
        
        // Create Objectc of the UIAlertController

        let alert = UIAlertController(title: nil, message: strMessage, preferredStyle: .actionSheet)
        alert.view.tintColor = UIColor.Color.blue
                // Add Cancel Action
        alert.addAction(UIAlertAction(title: Localizable.AlertBtns.cancel, style: .cancel, handler: nil))
        
        // Add Use Camera Option
        alert.addAction(UIAlertAction(title: Localizable.AlertBtns.camera, style: .default, handler: { (_) in
            
            self.useCamera(controller, type: type, isEditing: isEditing)
            
        }))
        
        alert.addAction(UIAlertAction(title: Localizable.AlertBtns.gallery, style: .default, handler: { (_) in
            
            self.usePhotoLibrary(controller, type: type, isEditing: isEditing)
            
        }))
        
        // Display Action Sheet
        DispatchQueue.main.async {
            // This will display in PopOver.
            if let popoverController = alert.popoverPresentationController, let view = sender {
                popoverController.sourceView = view.superview
                popoverController.sourceRect = view.frame
                popoverController.permittedArrowDirections = .any
            }
            controller.present(alert, animated: true, completion: nil)
        }
        
    }
    
}

// MARK: - Private Methods

extension ImagePicker {
    
    /// This method will display an Alert on the Screen.
    ///
    /// - Parameters:
    ///   - controller: Object of the controller form which you need to show alert.
    ///   - message: Message which you need to display.
    fileprivate func showAlert(_ controller: UIViewController, message: String) {
        UIAlertController.showAlertWithOkButton(controller: controller, message: message, completion: nil)
    }
    
    /// This method will use to display an Alert related to Access permission.
    ///
    /// - Parameters:
    ///   - controller: Object of the controller
    ///   - message: Message which you need to display
    fileprivate func showAlertForEnableAccessPermission(_ controller: UIViewController, message: String) {
        
        UIAlertController.showAlert(controller: controller, message: message, cancelButton: Localizable.AlertBtns.cancel, otherButtons: [Localizable.AlertBtns.settings]) { (index, _) in
            if index == 0 {
                // Settings button click
                if let appSettings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettings) {
                    UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                }
            }
        }
        
    }
    
    /// This method will use to check Photo Library Access permission and display Photos
    ///
    /// - Parameter controller: Object of the controller
    public func usePhotoLibrary(_ controller: UIViewController, type: [String], isEditing: Bool) {

        self.handlePhotoLibraryStatus(PHPhotoLibrary.authorizationStatus(), controller: controller, type: type, isEditing: isEditing)

    }
    
    /// This method will handle the Photo Library's "PHAuthorizationStatus" and displa
    ///
    /// - Parameters:
    ///   - status: PHAuthorizationStatus
    ///   - controller: Object of the controller on which you wanted to display ImagePicker
    fileprivate func handlePhotoLibraryStatus(_ status: PHAuthorizationStatus, controller: UIViewController, type: [String], isEditing: Bool) {

        if #available(iOS 14.0, *) {
            DispatchQueue.main.async {
                self.imagePicker.delegate = self
                self.imagePicker.allowsEditing = isEditing
                //self.imagePicker.videoQuality = .type640x480
                self.imagePicker.videoMaximumDuration = 60
                self.imagePicker.mediaTypes = type // Pass this value  // kUTTypeImage // kUTTypeMovie
                self.imagePicker.sourceType = .photoLibrary

                controller.present(self.imagePicker, animated: true, completion: nil)

            }
        } else {
            switch status {
            case .authorized:
                print("Photos Authorized")
                DispatchQueue.main.async {
                    self.imagePicker.delegate = self
                    self.imagePicker.allowsEditing = isEditing
                    //self.imagePicker.videoQuality = .type640x480
                    self.imagePicker.videoMaximumDuration = 60
                    self.imagePicker.mediaTypes = type // Pass this value  // kUTTypeImage // kUTTypeMovie
                    self.imagePicker.sourceType = .photoLibrary

                    controller.present(self.imagePicker, animated: true, completion: nil)

                }

            case .denied:
                print("Photos Denied")
                DispatchQueue.main.async {
                    self.showAlertForEnableAccessPermission(controller, message: "You need to enable Photos access from the settings.")
                    self.didCompletePicking?(self.imagePicker, nil)
                }
            case .restricted:
                print("Photos restricted")
                DispatchQueue.main.async {
                    self.didCompletePicking?(self.imagePicker, nil)
                }
            case .notDetermined:
                print("Photos notDetermined")
                DispatchQueue.main.async {
                    PHPhotoLibrary.requestAuthorization({ (status) in
                        self.handlePhotoLibraryStatus(status, controller: controller, type: type, isEditing: isEditing)
                    })
                }
            @unknown default: break

            }
        }
    }
    
    /// This method will check if Camera is available or not and is the permission is granted to access it or not and then display the Camera for capturing video or photos.
    ///
    /// - Parameter controller: Object of the controller
    public func useCamera(_ controller: UIViewController, type: [String], isEditing: Bool) {
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
//            AlertMesage.show(.error, message: "Camera is not supported in this device.")
            UIAlertController.showAlertWithOkButton(controller: controller, message: "Camera is not supported in this device.".localized, completion: nil)
            self.didCompletePicking?(self.imagePicker, nil)
            return
        }
        
        // Check for the authorisation status.
        if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
            // Already authorized
            self.openNativeCamera(controller, type: type, isEditing: isEditing)
        } else {
            
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    // Access allowed
                    self.openNativeCamera(controller, type: type, isEditing: isEditing)
                } else {
                    // Access denied
                    self.showAlertForEnableAccessPermission(controller, message: Localizable.AlertMsg.needCameraAccess)
                    self.didCompletePicking?(self.imagePicker, nil)
                }
            })
            
        }
        
    }
    
    /// This method will open a Native Camera.
    ///
    /// - Parameter controller: Object of the controller
    fileprivate func openNativeCamera(_ controller: UIViewController, type: [String], isEditing: Bool) {
        DispatchQueue.main.async {
            self.imagePicker.allowsEditing = isEditing
            //            self.imagePicker.videoQuality = .type640x480
            self.imagePicker.videoMaximumDuration =  60
            self.imagePicker.mediaTypes = type
            self.imagePicker.sourceType = .camera
            self.imagePicker.delegate = self
            controller.present(self.imagePicker, animated: true, completion: nil)
        }
    }
    
}

// MARK: - UIImagePickerControllerDelegate Methods

extension ImagePicker: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        self.imagePicker.dismiss(animated: true) {
            self.didCompletePicking?(picker, info)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        self.imagePicker.dismiss(animated: true) {
            self.didCompletePicking?(self.imagePicker, nil)
        }
    }
    
}
