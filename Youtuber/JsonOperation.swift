//
//  JsonOperation.swift
//  Youtuber
//
//  Created by LIV on 1/31/18.
//  Copyright © 2018 LIV. All rights reserved.
//

import UIKit

class JsonOperation: NSObject {
    
    static let sharedInstance = JsonOperation()
    
    func loadDataJsonForVideoListArray(urlString: String, completion: @escaping (_ dataForTable: [CellVideoAttribute]) -> Void) {
        
        var dataForTable = [CellVideoAttribute]()
        
        if let url = URL(string: urlString) {
            
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                print("request to video list for table is done")
                
                if let jsonData = data {
                    
                    do {
                        
                        if let json = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any] {
                            
                            if let videosArray = json["items"] as? [[String: Any]] {
                                
                                for video in videosArray {
                                    
                                    let id = video["id"] as! String
                                    
                                    let title = ""
                                    let thumbnailUrl = "https://img.youtube.com/vi/\(id)/default.jpg"
                                    let videoUrl = "https://www.youtube.com/watch?v=\(id)"
                                    let publishedAt = ""
                                    let channelId = ""
                                    let channelTitle = ""
                                    
                                    dataForTable.append(CellVideoAttribute.init(id: id, title: title, thumbnailUrl: thumbnailUrl, videoUrl: videoUrl, publishedAt: publishedAt, channelId: channelId, channelTitle: channelTitle))
                                }
                                
                                completion(dataForTable)
                            }
                        }
                            
                        else {
                            print("error video list for table data")
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                } else {
                    print("video list for table data is nil")
                }
            }
            
            task.resume()
            print("request video list for table is started")
        }
    }
  
    func loadDataJsonForVideoListArrayElement(Element: CellVideoAttribute, completion: @escaping (_ dataForTable: CellVideoAttribute) -> Void) {
        
        var dataForTable = CellVideoAttribute(id: "", title: "", thumbnailUrl: "", videoUrl: "", publishedAt: "", channelId: "", channelTitle: "")
        let id = Element.id
        let urlString = "https://www.googleapis.com/youtube/v3/videos?part=snippet&id=\(id)&key=AIzaSyCpgNZjnS3ywS8nfVFm_UEY7Ewf87_PCiE"
        if let url = URL(string: urlString) {
            
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                print("request to video list for table is done")
                
                if let jsonData = data {
                    
                    do {
                        
                        if let json = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any] {
                            
                            if let videosArray = json["items"] as? [[String: Any]] {
                                
                                if videosArray.count > 0 {
                                    
                                    if let videoElements = videosArray[0]["snippet"] as? [String: Any] {
                                        
                                        let title = videoElements["title"] as! String
                                        //let publishedAt = videoElements["publishedAt"] as! Date
                                        let publishedAt = ""
                                        let channelId = videoElements["channelId"]  as! String
                                        let channelTitle = videoElements["channelTitle"] as! String
                                        let videoUrl = "https://www.youtube.com/watch?v=\(id)"
                                        let thumbnailUrl = "https://img.youtube.com/vi/\(id)/default.jpg"
                                        
//                                        if let thumbnails = videoElements["thumbnails"] as? [String: Any]{
//                                        
//                                            thumbnailUrl = thumbnails["Standart"] as! String
//                                        }
                                        
                                        dataForTable = CellVideoAttribute.init(id: id, title: title, thumbnailUrl: thumbnailUrl, videoUrl: videoUrl, publishedAt: publishedAt, channelId: channelId, channelTitle: channelTitle)
                                    }
                                }
                                completion(dataForTable)
                            }
                        }
                            
                        else {
                            print("error video list for table data")
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                } else {
                    print("video list for table data is nil")
                }
            }
            
            task.resume()
            print("request video list for table is started")
        }
    }
    
}
