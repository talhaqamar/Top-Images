//
//  CustomTableViewCell.swift
//  aiaInsurance
//
//  Created by Talha Qamar on 29/4/18.
//  Copyright © 2018 Devtalha.com. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

// Custom TableCell
class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet var image1: UIImageView! // For image
    @IBOutlet var title: UILabel! // title of image
    @IBOutlet var dateOfPost: UILabel! // date of Post
    @IBOutlet var additionalPosts: UILabel! // additional Posts
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // This method actually loads the data into the respective cell's view elements
    func loadDataToUI(dataDict:NSDictionary)
    {
       // image.text = dataDict.value(forKey: "url") as? String
        title.text = dataDict.value(forKey: "title") as? String // Title
        dateOfPost.text = dataDict.value(forKey: "dateOfPost") as? String // Date of Post
        additionalPosts.text = dataDict.value(forKey: "additionalPosts") as? String // Additional posts
        let url = URL.init(string: dataDict.value(forKey: "imageURL") as! String) // URL
        image1.animationDuration = 2
        image1.af_setImage(withURL: url!)
    }
    
}
