//
//  ImageModal.swift
//  aiaInsurance
//
//  Created by Talha Qamar on 29/4/18.
//  Copyright © 2018 Devtalha.com. All rights reserved.
//

import Foundation
import RealmSwift

class ImageModal: Object {
    
    @objc dynamic var title : String? = nil // use to store the title of row
    @objc dynamic var dateOfPost : String? = nil // date of Post
    @objc dynamic var imageArray : String? = nil // Image urls
    @objc dynamic var points : String? = nil // points from api
    @objc dynamic var score : String? = nil // score for image
    @objc dynamic var topicId : String? = nil // topic id for image
    @objc dynamic var totalNo : String? = nil // total no of images
    @objc dynamic var currentIndex : String? = nil // current Index
    
    
    
    /*    override init(value: Any)
     {
     self.employeePositionKey = ""
     self.employeePosition = ""
     
     super.init()
     }
     */
}

// This extension is writing the data into Realm Database 
extension ImageModal
{
    func writeToRealm()
    {
        try! realm?.write {
            realm?.add(self)
        }
    }
    
}
