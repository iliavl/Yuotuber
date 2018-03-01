//
//  DataBase.swift
//  Youtuber
//
//  Created by LIV on 2/8/18.
//  Copyright © 2018 LIV. All rights reserved.
//

import Foundation
import RealmSwift

class DataBase: NSObject {
    
    func realmAddToDBFav(id: String, name: String, thumbnailUrl: String, videoUrl: String, publishedAt: String, channelId: String, channelTitle: String, additionally: String) {
        
        do {
            
//            let key = NSMutableData(length: 64)!
//            SecRandomCopyBytes(kSecRandomDefault, key.length, UnsafeMutablePointer<UInt8>(key.mutableBytes))
//            let encriptionConfig = Realm.Configuration(encryptionKey: key as Data)
            

            
            let realm = try Realm()
            
            try realm.write {
                
                let videos = VideoElementRealm(id: id, title: name,thumbnailUrl: thumbnailUrl, videoUrl: videoUrl, publishedAt: publishedAt, channelId: channelId, channelTitle: channelTitle, additionally: additionally)
                realm.add(videos)
                print("Add to elemet to DB - (\(videos))")
            }
            
        } catch let error {
            print(error)
        }
        // path to DB
        print("Path to DB \(Realm.Configuration.defaultConfiguration.fileURL!)")
    }

    func realmLoadFromDBFav() -> [CellVideoAttribute] {
        
        var dataForTable = [CellVideoAttribute]()
        
        do {
            let realm = try Realm()
            let elements = realm.objects(VideoElementRealm.self)

            for item in elements {
                
                let id = item.id
                let title = item.title
                let thumbnailUrl = item.thumbnailUrl
                let videoUrl = item.videoUrl
                let publishedAt = item.publishedAt
                let channelId = item.channelId
                let channelTitle = item.channelTitle
                print("reading from DB // \(item)")
                dataForTable.append(CellVideoAttribute.init(id: id, title: title, thumbnailUrl: thumbnailUrl, videoUrl: videoUrl, publishedAt: publishedAt, channelId: channelId, channelTitle: channelTitle))
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
        
        return dataForTable
    }

    func realmDeleteObjectFromDB(id: String) {
        
        do {
            let realm = try Realm()
            print(Realm.Configuration.defaultConfiguration.fileURL!)
            print("Try delete object in base")
            try realm.write {
                
                let objectcToDelete = realm.objects(VideoElementRealm.self).filter("id = '\(id)'")
                
                for obj in objectcToDelete {
                    
                    realm.delete(obj)
                    print("object with id = \(id) deleting from base")
                }
                
                print("finish, deleted objects from base")
            }
            
        } catch let error {
            print(error)
        }
    }

    func realmChangeObjectFromDB(id: String, nameElement: String, dataElement: String) {
        
        do {
            let realm = try Realm()
            print(Realm.Configuration.defaultConfiguration.fileURL!)
            print("Try change object in base")
            try realm.write {
                
                let objectcToDelete = realm.objects(VideoElementRealm.self).filter("id = '\(id)'")
                
                for obj in objectcToDelete {
                    
                    obj[nameElement] = dataElement
                    print("object with id = \(id) changing in base")
                }
                
                print("finish, changed objects in base")
            }
            
        } catch let error {
            print(error)
        }
    }
    
    func findElementInDB(id: String) -> Bool {
        
        var elementExist = false
        
        do {
            
            let realm = try Realm()
            let arrayOfObjects = realm.objects(VideoElementRealm.self).filter("id = '\(id)'")
            
            elementExist = !arrayOfObjects.isEmpty
            
        } catch let error {
            
            print(error.localizedDescription)
        }
        
        return elementExist
    }
    
    func countElementsInDBTable() -> Int {
        
        var elementsCount = 0
        
        do {
            
            let realm = try Realm()
            let arrayOfObjects = realm.objects(VideoElementRealm.self)
            
            elementsCount = arrayOfObjects.count
            
        } catch let error {
            
            print(error.localizedDescription)
        }
        
        return elementsCount
    }
}
