//
//  PhotosViewController.swift
//  Flickr23
//
//  Created by Anoop tomar on 11/12/15.
//  Copyright © 2015 Anoop tomar. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {

    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var tableview: UITableView!
    
    var heights = NSMutableDictionary()
 
    // photos
    var photos: [Photo] = []
    // fav photos
    var favPhotos: [Photo] = []
    
    var page = 1
    var pageCount = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen()
        getAllFavPhotos()
        tableview.addInfiniteScrollingWithActionHandler { () -> Void in
            self.page = self.page + 1
            self.downloadPhotoData(self.page, count: self.pageCount)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        FlickrClient.sharedInstance.cancelAll()
    }
    
    func getAllFavPhotos(){
        FlickrClient.sharedInstance.getFavList { (favPhotos: [Photo]) -> Void in
            self.favPhotos = favPhotos
            self.downloadPhotoData(self.page, count:self.pageCount)
        }
    }

    @IBAction func didPressLogout(sender: UIButton) {
        if FlickrClient.sharedInstance.logout(){
            self.presentViewController(self.storyboard?.instantiateViewControllerWithIdentifier("mainVC") as! ViewController, animated: true, completion: nil)
        }
    }
    
    
    func downloadPhotoData(page: Int, count: Int){
        FlickrClient.sharedInstance.getInterestingness(page, count: count) { (interestingPhotos: [Photo]) -> Void in
            self.photos.appendContentsOf(interestingPhotos)
            self.tableview.infiniteScrollingView.stopAnimating()
            if self.favPhotos.count > 0{
                for pic in self.photos{
                    if self.favPhotos.contains({ (photo:Photo) -> Bool in
                        return photo.id == pic.id
                    }){
                        pic.fav = true
                    }
                }
            }
            self.tableview.reloadData()
        }
    }
    
    func setupScreen(){
        // set logout button
        logoutButton.layer.cornerRadius = 10
        logoutButton.clipsToBounds = true
        let originalSize = logoutButton.bounds.size
        logoutButton.bounds.size = CGSizeZero
        // show logout button
        UIView.animateWithDuration(0.5) { () -> Void in
            self.logoutButton.bounds.size = originalSize
        }
        self.automaticallyAdjustsScrollViewInsets = false
        tableview.delegate = self
        tableview.dataSource = self
        tableview.rowHeight = UITableViewAutomaticDimension
        tableview.tableFooterView = UIView(frame: CGRectZero)
    }
}

extension PhotosViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! PhotoCellTableViewCell
        cell.setupCell(photos[indexPath.row])
        cell.indexpath = indexPath
        cell.delegate = self
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let height = heights.objectForKey(indexPath){
            return height as! CGFloat
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let height = cell.frame.size.height
        self.heights.setObject(height, forKey: indexPath)
    }
    
}

extension PhotosViewController: PhotoCellTableViewCellDelegate{
    func didChangedFavStatus(photoCellTableViewCell: PhotoCellTableViewCell, photo: Photo) {
        let picExists = photos.contains { (var pic: Photo) -> Bool in
            if pic.id! == photo.id!{
                pic = photo
            }
            return pic.id! == photo.id!
        }
        if picExists{
            if photo.fav{
                tableview.reloadRowsAtIndexPaths([photoCellTableViewCell.indexpath!], withRowAnimation: UITableViewRowAnimation.Right)
            }else{
                tableview.reloadRowsAtIndexPaths([photoCellTableViewCell.indexpath!], withRowAnimation: UITableViewRowAnimation.Left)
            }
        }
    }
}
