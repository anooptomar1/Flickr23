//
//  PhotoCellTableViewCell.swift
//  Flickr23
//
//  Created by Anoop tomar on 11/12/15.
//  Copyright © 2015 Anoop tomar. All rights reserved.
//

import UIKit

protocol PhotoCellTableViewCellDelegate: class{
    func didChangedFavStatus(photoCellTableViewCell:PhotoCellTableViewCell, photo: Photo)
}

class PhotoCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var blurLabel: UIVisualEffectView!
    
    var indexpath: NSIndexPath?
    var photo: Photo?
    
   weak var delegate: PhotoCellTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(photo: Photo){
        self.photo = photo
        img.setImageWithURL(NSURL(string: ImageBuilder.buildImageUrl(photo, size: ImageSize.medium640LongSide)), placeholderImage: nil)
        self.titleLabel.text = photo.title!
        self.blurLabel.hidden = false
        img.clipsToBounds = true
        img.contentMode = UIViewContentMode.ScaleAspectFill
        if self.photo!.fav == true{
            self.toggleFav(true)
        }else{
            self.toggleFav(false)
        }
    }
    
    
    @IBAction func didChangeFavStatus(sender: UIButton) {
        if self.photo!.fav == true{
            FlickrClient.sharedInstance.setFavoriteOff(photo!.id!, completion: { (success:Bool) -> Void in
                self.toggleFav(false)
                self.delegate?.didChangedFavStatus(self, photo: self.photo!)
            })
        }else{
            FlickrClient.sharedInstance.setFavoriteOn(photo!.id!, completionHandler: { (success:Bool) -> Void in
                self.toggleFav(true)
                self.delegate?.didChangedFavStatus(self, photo: self.photo!)
            })
        }
    }
    
    private func toggleFav(on: Bool){
        if on == true{
            favButton.setImage(UIImage(named: "favoriteOn"), forState: UIControlState.Normal)
            photo!.fav = true
        }else{
            favButton.setImage(UIImage(named: "favoriteOff"), forState: UIControlState.Normal)
            photo!.fav = false
        }
    }
   
}
