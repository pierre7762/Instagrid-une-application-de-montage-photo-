//
//  ExtensionImageViewController.swift
//  p4
//
//  Created by Pierre Lemère on 24/02/2021.
//

import UIKit

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let photo = info[.originalImage] as? UIImage {
            imageSelected.image = photo
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
