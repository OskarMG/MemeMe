//
//  MemeEditorVC.swift
//  MemeMe
//
//  Created by Oscar Martínez Germán on 11/1/22.
//

import UIKit

class MemeEditorVC: UIViewController {
    
    //MARK: - Properties
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.adaptMemeImageView()
     }
    
    func configureVC() {
        self.tabBarController?.tabBar.isHidden = true
        self.setupTextField(self.topTextField, text: "TOP")
        self.setupTextField(self.bottomTextField, text: "BOTTOM")
        self.cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        self.resetMeme()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func adaptMemeImageView() {
        DispatchQueue.main.async {
            self.imageView.contentMode = .scaleAspectFit
            self.imageViewHeightConstraint.constant = self.isLandscape() ? self.view.frame.size.height - self.toolBar.frame.size.height : 300
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
    
    func canShare() {
        DispatchQueue.main.async { self.shareButton.isEnabled = self.imageView.image != nil }
    }
    
    func dismissKeyboard() {
        DispatchQueue.main.async {
            self.topTextField.resignFirstResponder()
            self.bottomTextField.resignFirstResponder()
        }
    }
    
    func save() {
        if let memedImage = self.generateMemedImage(), let topText = topTextField.text, let bottomText = bottomTextField.text {
            let meme = Meme(topText: topText,
                            bottomText: bottomText,
                            originalImage: imageView.image,
                            memedImage: memedImage)
            (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
            UIImageWriteToSavedPhotosAlbum(memedImage, nil, nil, nil);
        }
    }
        
    func resetMeme() {
        DispatchQueue.main.async {
            self.imageView.image = nil
            self.setupTextField(self.topTextField, text: "TOP")
            self.setupTextField(self.bottomTextField, text: "BOTTOM")
            self.canShare()
        }
    }
    
    func setupTextField(_ textField: UITextField, text: String) {
        textField.text     = text
        textField.delegate = self
        
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.black,
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            .strokeWidth: -6.5
        ]
    
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
    }
    
    func hideAndShowBars(_ value: Bool) {
        self.toolBar.isHidden = value
        self.navigationController?.navigationBar.isHidden = value
    }
    
    //MARK: Get Current UITextField
    func getFirstResponder(in view: UIView) -> UIView? {
        for subView in view.subviews {
            if subView.isFirstResponder { return subView }
            if let recursiveSubView = self.getFirstResponder(in: subView) { return recursiveSubView }
        }
        return nil
    }
    
    func generateMemedImage() -> UIImage? {
        self.hideAndShowBars(true)
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.hideAndShowBars(false)
        return memedImage
    }
    
    
    //MARK: - NOTIFICATION OBSERVER METHODS
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let textField = self.getFirstResponder(in: self.view) {
            if textField.tag == 1 { view.frame.origin.y -= getKeyboardHeight(notification) }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) { view.frame.origin.y = 0 }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return self.isLandscape() ? keyboardSize.cgRectValue.height : keyboardSize.cgRectValue.height / 2
    }

    
    //MARK: - EVENTS FOR MemeMe EDITOR BUTTONS
    @IBAction func onPhotoCameraButtonsTap(_ sender: UIBarButtonItem) {
        self.dismissKeyboard()
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate   = self
        imagePickerVC.sourceType = sender.tag == 0 ? .photoLibrary : .camera
        DispatchQueue.main.async {
            self.present(imagePickerVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func onShareButtonTap(_ sender: UIBarButtonItem) {
        self.dismissKeyboard()
        DispatchQueue.main.async {
            if let memedImage = self.generateMemedImage() {
                let activityVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
                activityVC.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
                    if completed { self.save() }
                }
                self.present(activityVC, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func onCancelButtonTap(_ sender: UIBarButtonItem) {
        self.resetMeme()
        self.dismissKeyboard()
    }
}

//MARK: - UITextFieldDelegate Methods
extension MemeEditorVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        DispatchQueue.main.async { textField.text = "" }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        DispatchQueue.main.async {
            if let text = textField.text, text.isEmpty {
                self.setupTextField(textField, text: textField.tag == 0 ? "TOP" : "BOTTOM")
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.dismissKeyboard()
        return true
    }
}

//MARK: - UIImagePickerControllerDelegate and UINavigationControllerDelegate methods
extension MemeEditorVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        DispatchQueue.main.async {
            if let image = info[.originalImage] as? UIImage { self.imageView.image = image }
            self.dismiss(animated: true, completion: { self.canShare() })
        }
    }
    
}
