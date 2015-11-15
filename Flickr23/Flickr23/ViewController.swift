//
//  ViewController.swift
//  Flickr23
//
//  Created by Anoop tomar on 11/10/15.
//  Copyright © 2015 Anoop tomar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginButton.clipsToBounds = true
        BackgroundImageHelper.getBackgroundImage(10, pageNumber: 1){ (im: UIImage?) -> Void in
            guard let image = im else{
                print("no image found")
                return
            }
            self.backgroundImage.image = image
            UIView.animateWithDuration(1.0) { () -> Void in
                self.loginButton.alpha = 1.0
                self.loginButton.layer.cornerRadius = 10
            }
        }
    }
    
    @IBAction func didPressLoginButton(sender: UIButton) {
        FlickrClient.sharedInstance.login { (user) -> Void in
            // auth success move user to next screen
            let userData = NSKeyedArchiver.archivedDataWithRootObject(user!)
            NSUserDefaults.standardUserDefaults().setObject(userData, forKey: SharedSettings.kUserKey)
            NSUserDefaults.standardUserDefaults().synchronize()
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("photoVC") as! PhotosViewController
            self.presentViewController(vc, animated: true, completion: nil)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

