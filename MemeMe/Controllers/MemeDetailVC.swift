//
//  MemeDetailVC.swift
//  MemeMe
//
//  Created by Oscar Martínez Germán on 19/1/22.
//

import UIKit

class MemeDetailVC: UIViewController {
    
    //MARK: - Properties
    static let identifier = "MemeDetailVC"
    
    var meme: Meme!
    let defaultImageViewHeight: CGFloat = 380
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setMemedImage()
        self.adaptImageView()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.adaptImageView()
     }
    

    //MARK: - Set Memed Image
    func setMemedImage () {
        DispatchQueue.main.async {
            self.imageView.image = self.meme.memedImage
        }
    }

    //MARK: - Adapt ImageView Height
    func adaptImageView() {
        DispatchQueue.main.async {
            self.imageView.contentMode = self.isLandscape() ? .scaleAspectFit : .scaleAspectFill
            self.imageViewHeightConstraint.constant = self.isLandscape() ? self.view.frame.size.height : self.defaultImageViewHeight
        }
    }
    
    func isLandscape() -> Bool {
        var isLandscape = false
        switch UIDevice.current.orientation {
        case .landscapeRight, .landscapeLeft: isLandscape = true
        case .portrait: isLandscape = false
        default: isLandscape = true
        }
        return isLandscape
    }
}
