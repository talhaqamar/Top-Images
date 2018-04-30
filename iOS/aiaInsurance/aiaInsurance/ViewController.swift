//
//  ViewController.swift
//  aiaInsurance
//
//  Created by Local Admin on 29/4/18.
//  Copyright © 2018 Devtalha.com. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift



/*
  This class is actually the main entry point of the project.

 Cocoa Pods in Project
 Realm: This project is using Realm Database for storing the data. Realm Gives us a very easier way to manipulate the data.
 AlamoFire: Used for getting data from api
 AlamoFireImage: Used for lazy loading of images
 SwiftyJSON: Used for JSON Parsing
 
 */
class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate { // Overriding tableview delegates and UISearchBar delegate

    @IBOutlet var toggleSwitch: UISwitch! // Outlet for the switch
    @IBOutlet var searchBar: UISearchBar! // Outlet for search Bar
    @IBOutlet var tableView: UITableView! // Outlet for tableview
    
    var imageModalList:List = List<ImageModal>() //
    var imageObject = ImageModal() // Modal for data required for the project
    let nsMutableArray = NSMutableArray() // Array placing data in the tableview
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        searchBar.delegate = self // Delegate for searchBar
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Mandatory method for rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nsMutableArray.count // TableView total Rows
     }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a new cell if needed or reuse an old one
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell") as! CustomTableViewCell // CustomTableViewCell is the class in group CustomTableViewCell
        let dict = nsMutableArray.object(at: indexPath.row) as! NSDictionary
        cell.loadDataToUI(dataDict: dict)
        // cell.addTarget(self,action:#selector(buttonClicked), for: .touchUpInside)
        //  cell.delegate = self
        return cell
    }
    
    // Switch on/Off toggle button
    @IBAction func switchClicked(_ sender: UISwitch) {
       
        if (sender.isOn) // if its already ON
        {
            print("on")
            if(imageModalList.count > 1) // If the data is present already in the list for all the data
            {
                
                self.nsMutableArray.removeAllObjects() // First clean/clear the array. So there is no data redundancy
                for x in 0...self.imageModalList.count-1 // looping through all the data present in the list
                {
                    
                     self.imageObject = ImageModal() // Initilizing empty object for image Modal which will be used for placing images in CustomTableViewCell
                    self.imageObject = imageModalList[x]//  creating image object
                    
                    var score :Int  = Int(self.imageObject.score!)! // Score
                    var  points : Int = Int(self.imageObject.points!)! // Points
                    var topicid : Int  = Int(self.imageObject.topicId!)! // Topic ID
                    var sum = 0
                    
                    sum =   score + points + topicid // Adding all three values
                    
                    if( sum % 2 == 0 ) // If its even no then reload the list
                    {
                        
                        let dict1 = NSMutableDictionary() // Create Dictionary
                        dict1.setValue(self.imageModalList[x].title, forKey: "title") // title
                        dict1.setValue(self.imageModalList[x].dateOfPost, forKey: "dateOfPost")// datepost
                        let cIndex :String! = self.imageModalList[x].currentIndex// current Index
                        let tNo : String! = self.imageModalList[x].totalNo // Total Images
                        if cIndex != nil && tNo != nil
                        {
                            let val = cIndex! + " of " + tNo!
                            dict1.setValue(val, forKey: "additionalPosts")
                        }
                        
                        let url = self.imageModalList[x].imageArray
                        dict1.setValue(url!, forKey: "imageURL")
                        
                        self.nsMutableArray.add(dict1)
                        //  print(self.imageModalList[x].title)
                        //  print(self.imageModalList[x].dateOfPost)
                        print(self.imageModalList[x].imageArray)
                       }
                    }
                self.tableView.isHidden = false
                self.tableView.reloadData() // REload TableView
            }
            else
            {
                // Alert View
                let alert = UIAlertController(title: "Please search first", message: "", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
        }
        else {
            print("off")
            // If off is selected then reload the list with all the images
            self.nsMutableArray.removeAllObjects()
            if(imageModalList.count > 1)
            {
            for x in 0...self.imageModalList.count-1
            {
                let dict1 = NSMutableDictionary()
                dict1.setValue(self.imageModalList[x].title, forKey: "title")
                dict1.setValue(self.imageModalList[x].dateOfPost, forKey: "dateOfPost")
                let cIndex :String! = self.imageModalList[x].currentIndex
                let tNo : String! = self.imageModalList[x].totalNo
                if cIndex != nil && tNo != nil
                {
                    let val = cIndex! + " of " + tNo!
                    dict1.setValue(val, forKey: "additionalPosts")
                }
                
                let url = self.imageModalList[x].imageArray
                dict1.setValue(url!, forKey: "imageURL")
                
                self.nsMutableArray.add(dict1)
                //  print(self.imageModalList[x].title)
                //  print(self.imageModalList[x].dateOfPost)
                print(self.imageModalList[x].imageArray)
                
                
                
            }
            self.tableView.isHidden = false
            self.tableView.reloadData() // REload TAbleview
        }
        }
    }
    
    
    
    
    
    
   
    // Func when Search button clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        if (searchBar.text?.count)! > 2
        {
            let header : HTTPHeaders = [
                "Authorization" : "Client-ID 6046ae1df183471"
            ]
            self.imageModalList.removeAll()
            if(!realm.isInWriteTransaction){
                //  realmshift = try! Realm()
                
                try! realm.write
                {
                    realm.deleteAll()
                    realm.delete(self.imageModalList)
                }
            }
            imageModalList.removeAll()
            tableView.isHidden = true
            print("68 \(imageModalList.count)")
            Alamofire.request(Constants.startURL + searchBar.text! + Constants.endURL, method: .get, encoding: JSONEncoding.default, headers: header)
                .responseJSON { response in
                    //   print(response.request as Any)  // original URL request
                    //    print(response.response as Any) // URL response
                    // print(response.result.value as Any)   // result of response serialization
                    
                    let json = try! JSON(response.result.value)
                    // If there are items
                    
                    if(json.count > 1){
                        let items = json["data"]["items"]
                        
                        // Loop through all the items
                        for i in 0...(items.count)-1
                        {
                            print("title : \(items[i]["title"] as? String)")
                            self.imageObject = ImageModal()
                            self.imageObject.title = items[i]["title"].string
                            self.imageObject.points = String(describing : items[i]["points"].intValue)
                            self.imageObject.score = String(describing : items[i]["score"].intValue)
                            self.imageObject.topicId = String(describing : items[i]["topic_id"].intValue)
                            self.imageObject.dateOfPost = String(describing : Constants.parseDate(items[i]["datetime"].doubleValue))
                            //print("90 \(items[i]["images"].count)")
                            print("82 \(items[i]["link"])")
                            
                            // If there is exactly one Item in response
                            if(items[i]["images"].count == 1)
                            {
                                self.imageObject.imageArray = "\(items[i]["images"]["link"])"
                                self.imageObject.totalNo = String(items[i]["images"].count)
                                self.imageObject.currentIndex = String(1)
                                self.imageModalList.append(self.imageObject)
                                if(!realm.isInWriteTransaction)
                                {
                                    try! realm.write
                                    {
                                        realm.add(self.imageModalList)
                                    }
                                }
                            }
                                // if there are more than one records in items array
                            else if( items[i]["images"].count >= 1)
                            {
                                print("title : \(items[i]["title"] as? String)")
                                let totalImages = items[i]["images"]
                                for j in 0...(totalImages.count)-1
                                {
                                    self.imageObject = ImageModal()
                                    self.imageObject.title = items[i]["title"].string
                                    self.imageObject.points = String(describing : items[i]["points"].intValue)
                                    self.imageObject.score = String(describing : items[i]["score"].intValue)
                                    self.imageObject.topicId = String(describing : items[i]["topic_id"].intValue)
                                    self.imageObject.dateOfPost = String(describing : Constants.parseDate(items[i]["datetime"].doubleValue))
                                    self.imageObject.imageArray = "\(totalImages[j]["link"])"
                                    self.imageObject.currentIndex = String(j+1)
                                    self.imageObject.totalNo = String(totalImages.count)
                                    self.imageModalList.append(self.imageObject)
                                }
                                if(!realm.isInWriteTransaction){
                                    //  realmshift = try! Realm()
                                    
                                    try! realm.write
                                    {
                                        realm.add(self.imageModalList)
                                    }
                                }
                            }
                             // If there are no images array inside the item then that means we need to collect data from items object
                                // no need to go inside the images array
                            else if(items[i]["images"].count == 0)
                            {
                                self.imageObject = ImageModal()
                                self.imageObject.title = items[i]["title"].string
                                self.imageObject.points = String(describing : items[i]["points"].intValue)
                                self.imageObject.score = String(describing : items[i]["score"].intValue)
                                self.imageObject.topicId = String(describing : items[i]["topic_id"].intValue)
                                self.imageObject.dateOfPost = String(describing : Constants.parseDate(items[i]["datetime"].doubleValue))
                                self.imageObject.currentIndex = String(items[i]["images"].count+1)
                                self.imageObject.totalNo = String(items[i]["images"].count+1)
                                self.imageObject.imageArray = "\(items[i]["link"])"
                                self.imageModalList.append(self.imageObject)
                                
                                // Writing data to Realm File
                                if(!realm.isInWriteTransaction){
                                    //  realmshift = try! Realm()
                                    
                                    try! realm.write
                                    {
                                        realm.add(self.imageModalList)
                                    }
                                }
                            }
                            
                            
                            
                        }
                        print(self.imageModalList.count)
                        
                    }
                    
                    // If data size is greater than|Equal to 1 that means records are present
                    if(self.imageModalList.count >= 1) {
                        // Loop through those records
                    for x in 0...self.imageModalList.count-1
                    {
                        let dict1 = NSMutableDictionary()
                        dict1.setValue(self.imageModalList[x].title, forKey: "title")
                        dict1.setValue(self.imageModalList[x].dateOfPost, forKey: "dateOfPost")
                        let cIndex :String! = self.imageModalList[x].currentIndex
                        let tNo : String! = self.imageModalList[x].totalNo
                        if cIndex != nil && tNo != nil
                        {
                            let val = cIndex! + " of " + tNo!
                            dict1.setValue(val, forKey: "additionalPosts")
                        }
                        
                        let url = self.imageModalList[x].imageArray
                        dict1.setValue(url!, forKey: "imageURL")
                        
                        self.nsMutableArray.add(dict1)
                        //  print(self.imageModalList[x].title)
                        //  print(self.imageModalList[x].dateOfPost)
                        print(self.imageModalList[x].imageArray)
                        
                        
                        
                    }
                     self.tableView.isHidden = false // hide the tableview
                    self.tableView.reloadData() // reload the data
                    
                    }
                    else {
                        // Alert View when API returns no records
                        let alert = UIAlertController(title: "No Record found", message: "", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    
            }
            
        }
    }
    
   


}

