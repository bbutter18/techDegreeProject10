//
//  PostcardMakerController.swift
//  iOS NASA App
//
//  Created by Woodchuck on 3/19/19.
//  Copyright © 2019 Treehouse Island. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

//class for handling creating a postcard using a Mars Rover Photo
class PostcardMakerController: UIViewController {

    //MARK: - Properties
    
    var savedImage: [UIImage] = []
    static let testEmail = "cookstarterapp@gmail.com"
    var postcardString = String()
    var postcardImage = UIImage()
    
    //MARK: - Outlets

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var messageTextField: UITextField!
    
    @IBOutlet weak var postcardTitleLabel: UILabel!
    @IBOutlet weak var postcardMessageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = postcardImage
        
    }
   
    
    func sendEmail(image: UIImage) {
        guard MFMailComposeViewController.canSendMail() else {
            let ac = UIAlertController(title: "Email error", message: "Unable to send email, check phone settings. Simulator cannot send email", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            
            return
        }
        
        guard let imageData = image.PNGData else {
            return
            
        }
        
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self as? MFMailComposeViewControllerDelegate
        mail.setToRecipients([PostcardMakerController.testEmail])
        mail.setSubject("A Postcard From Mars")
        mail.setMessageBody("Kicking up some red dust up here, come check it out!", isHTML: false)
        mail.addAttachmentData(imageData, mimeType: "image/png", fileName: "postcard.png")
        present(mail, animated: true, completion: nil)
    }
    
    

    
    @IBAction func marsRoverController(_ sender: Any) {
        dismiss(animated: true, completion: nil)

    }
    
    
    @IBAction func titleTextFieldEditingChanged(_ sender: Any) {
        postcardTitleLabel.text = titleTextField.text
    }
    
    
    @IBAction func messageTextFieldEditingChanged(_ sender: Any) {
        postcardMessageLabel.text = messageTextField.text 
    }
    
    
    @IBAction func redColorButton(_ sender: Any) {
        postcardMessageLabel.textColor = UIColor.red
        postcardTitleLabel.textColor = UIColor.red
    }
 
    //check this color 
    @IBAction func purpleColorButton(_ sender: Any) {
        postcardMessageLabel.textColor = UIColor.purple
        postcardTitleLabel.textColor = UIColor.purple
    }
    
    //check this color
    @IBAction func lightBlueColorButton(_ sender: Any) {
        postcardMessageLabel.textColor = UIColor.cyan
        postcardTitleLabel.textColor = UIColor.cyan
    }
    
    
    //check this color
    @IBAction func darkPurpleColorButton(_ sender: Any) {
        postcardMessageLabel.textColor = UIColor.magenta
        postcardTitleLabel.textColor = UIColor.magenta
    }
    
    
    @IBAction func plainText(_ sender: Any) {
        postcardMessageLabel.font = UIFont(name: "GillSans-Italic", size: 25.0)
        postcardTitleLabel.font = UIFont(name: "Zapfino", size: 20.0)
        
    }
    
    
    @IBAction func boldText(_ sender: Any) {
        postcardMessageLabel.font = UIFont(name: "GillSans-BoldItalic", size: 25.0)
        postcardTitleLabel.font = UIFont(name: "Zapfino", size: 20.0)
        
    }
    
    @IBAction func defaultTextSize(_ sender: Any) {
        postcardMessageLabel.font = postcardMessageLabel.font.withSize(25)
        postcardTitleLabel.font = postcardTitleLabel.font.withSize(20)
    }
    
    
    @IBAction func largeTextSize(_ sender: Any) {
        postcardMessageLabel.font = postcardMessageLabel.font.withSize(32)
        postcardTitleLabel.font = postcardTitleLabel.font.withSize(24)
    }
    
    
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your postcard image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            
        }
    }
    
    
    
    @IBAction func saveButton(_ sender: Any) {
        
        let renderer = UIGraphicsImageRenderer(bounds: imageView.bounds)
        let newImage = renderer.image { (context) in
            imageView.drawHierarchy(in: imageView.bounds, afterScreenUpdates: true)
        }
        
        UIImageWriteToSavedPhotosAlbum(newImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        
        self.savedImage.append(newImage)
        print("\(savedImage.count)")
        
        sendEmail(image: newImage)
        
    }
    
    
} //END

extension UIImage {
    var PNGData: Data? {
        return self.pngData()
    }
    
}



