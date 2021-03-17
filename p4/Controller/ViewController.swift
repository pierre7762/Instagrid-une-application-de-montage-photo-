//
//  ViewController.swift
//  p4
//
//  Created by Pierre Lemère on 24/02/2021.
//
import Foundation
import UIKit

class ViewController: UIViewController {
//MARK: Outlet
    @IBOutlet weak var containerViews: UIView!
    //Layer 1
    @IBOutlet weak var viewLayer1: UIView!
    @IBOutlet weak var imageTopLayer1: UIImageView!
    @IBOutlet weak var imageBottomLeftLayer1: UIImageView!
    @IBOutlet weak var imageBottomRightLayer1: UIImageView!
    
    //Layer 2
    @IBOutlet weak var viewLayer2: UIView!
    @IBOutlet weak var imageTopLeftLayer2: UIImageView!
    @IBOutlet weak var imageTopRightLayer2: UIImageView!
    @IBOutlet weak var imagebottomLayer2: UIImageView!
    
    //Layer 3
    @IBOutlet weak var viewLayer3: UIView!
    @IBOutlet weak var imageTopLeftLayer3: UIImageView!
    @IBOutlet weak var imageTopRightLayer3: UIImageView!
    @IBOutlet weak var imageBottomLeftLayer3: UIImageView!
    @IBOutlet weak var imageBottomRightLayer3: UIImageView!
    
    //Select Layer
    @IBOutlet weak var layer1Button: UIButton!
    @IBOutlet weak var layer2Button: UIButton!
    @IBOutlet weak var layer3Button: UIButton!
    

//MARK: Var
    var picker: UIImagePickerController = UIImagePickerController()
    var imageSelected: UIImageView!
    var imageToShare: UIImage!
    var centerOriginContainerView: CGPoint!
    var initialFrame: CGRect!
    
    enum showLayerEnum {
        case showLayer1
        case showLayer2
        case showLayer3
    }
    
    var layerShow = showLayerEnum.showLayer1


    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        showLayerSelected(layerSelected: .showLayer1)
        
        //Save origin position of containerView-
        centerOriginContainerView = containerViews.center
        
        //Share to swipe up
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(shareAfterSwipeUp(_:)))
        swipeUp.direction = .up
        swipeUp.numberOfTouchesRequired = 1
        view.addGestureRecognizer(swipeUp)

        //Share to swipe left
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(shareAfterSwipeLeft(_:)))
        swipeLeft.direction = .left
        swipeLeft.numberOfTouchesRequired = 1
        view.addGestureRecognizer(swipeLeft)
    }
    
    override func viewDidLayoutSubviews() {
        initialFrame = containerViews.frame
    }
    
//MARK: Fonction
    
    
    @objc func shareAfterSwipeUp(_ gesture: UISwipeGestureRecognizer) {
        if UIApplication.shared.statusBarOrientation.isPortrait {
            swipeAnimated()
        }
    }

    @objc func shareAfterSwipeLeft(_ gesture: UISwipeGestureRecognizer) {
        if UIApplication.shared.statusBarOrientation.isLandscape {
            swipeAnimated()
        }
    }
    
    private func swipeAnimated() {
        switch UIApplication.shared.statusBarOrientation {
        case .portrait:
            UIView.animate(withDuration: 1) {
                self.containerViews.frame.origin.y = -300
            }
        case .landscapeLeft, .landscapeRight, .portraitUpsideDown :
            UIView.animate(withDuration: 1) {
                self.containerViews.frame.origin.x = -300
            }
        default:
            print("orientation unknow")
        }
        takeImageFromView(containerViews)
        shareImage()
    }
    
    //Transform UIView in UIImage
    private func takeImageFromView(_ v: UIView) {
        let renderer = UIGraphicsImageRenderer(size: v.layer.bounds.size)
        let image = renderer.image { ctx in
            v.drawHierarchy(in: v.layer.bounds, afterScreenUpdates: true)
        }
        imageToShare = image
    }
    
    private func shareImage() {
        // image to share
        let image = imageToShare

        // set up activity view controller
        let imageToShare = [ image ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare as [Any], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash

        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.postToFacebook ]
        
        activityViewController.completionWithItemsHandler = { activity, success, items, error in
            
            UIView.animate(withDuration: 0.5) {
                self.containerViews.frame = self.initialFrame
            }
        }

        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    private func selectImage(positionImage: UIImageView) {
        imageSelected = positionImage
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    private func showLayerSelected(layerSelected: showLayerEnum) {
        layerShow = layerSelected
        
        switch layerShow {
        case .showLayer1:
            viewLayer1.isHidden = false
            viewLayer2.isHidden = true
            viewLayer3.isHidden = true
            layer1Button.setBackgroundImage(UIImage(named: "Layout 1 select"), for: .normal)
            layer2Button.setBackgroundImage(UIImage(named: "Layout 2"), for: .normal)
            layer3Button.setBackgroundImage(UIImage(named: "Layout 3"), for: .normal)
            
        case .showLayer2:
            viewLayer1.isHidden = true
            viewLayer2.isHidden = false
            viewLayer3.isHidden = true
            layer1Button.setBackgroundImage(UIImage(named: "Layout 1"), for: .normal)
            layer2Button.setBackgroundImage(UIImage(named: "Layout 2 select"), for: .normal)
            layer3Button.setBackgroundImage(UIImage(named: "Layout 3"), for: .normal)
            
        case .showLayer3:
            viewLayer1.isHidden = true
            viewLayer2.isHidden = true
            viewLayer3.isHidden = false
            layer1Button.setBackgroundImage(UIImage(named: "Layout 1"), for: .normal)
            layer2Button.setBackgroundImage(UIImage(named: "Layout 2"), for: .normal)
            layer3Button.setBackgroundImage(UIImage(named: "Layout 3 select"), for: .normal)
        }
    }
    
//MARK: Action
    //Layer 1
    @IBAction func addPictureLayer1Top(_ sender: Any) {
        selectImage(positionImage: imageTopLayer1)
    }
    @IBAction func addPictureLayer1BottomLeft(_ sender: Any) {
        selectImage(positionImage: imageBottomLeftLayer1)
    }
    @IBAction func addPictureLayer1BottomRight(_ sender: Any) {
        selectImage(positionImage: imageBottomRightLayer1)
    }
    
    //Layer 2
    @IBAction func addPictureLayer2TopLeft(_ sender: Any) {
        selectImage(positionImage: imageTopLeftLayer2)
    }
    @IBAction func addPictureLayer2TopRight(_ sender: Any) {
        selectImage(positionImage: imageTopRightLayer2)
    }
    @IBAction func addPictureLayer2Bottom(_ sender: Any) {
        selectImage(positionImage: imagebottomLayer2)
    }
    
    //Layer 3
    @IBAction func addPictureLayer3TopLeft(_ sender: Any) {
        selectImage(positionImage: imageTopLeftLayer3)
    }
    @IBAction func addPictureLayer3TopRight(_ sender: Any) {
        selectImage(positionImage: imageTopRightLayer3)
    }
    @IBAction func addPicureLayer3BottomLeft(_ sender: Any) {
        selectImage(positionImage: imageBottomLeftLayer3)
    }
    @IBAction func addPictureLayer3BottomRight(_ sender: Any) {
        selectImage(positionImage: imageBottomRightLayer3)
    }
    
    //Choice layer
    @IBAction func layer1Selected(_ sender: Any) {
        showLayerSelected(layerSelected: .showLayer1)
    }
    @IBAction func layer2Selected(_ sender: Any) {
        showLayerSelected(layerSelected: .showLayer2)
    }
    @IBAction func layer3Selected(_ sender: Any) {
        showLayerSelected(layerSelected: .showLayer3)
    }
    

    
}

