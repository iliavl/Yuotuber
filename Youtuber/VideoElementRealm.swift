//
//  videoElementRealm.swift
//  Youtuber
//
//  Created by LIV on 2/8/18.
//  Copyright © 2018 LIV. All rights reserved.
//

import Foundation
import RealmSwift

class VideoElementRealm: Object {
    
    dynamic var id: String = ""
    dynamic var title: String = ""
    dynamic var thumbnailUrl: String = ""
    dynamic var videoUrl: String = ""
    dynamic var publishedAt: String = ""
    dynamic var channelId: String = ""
    dynamic var channelTitle: String = ""
    dynamic var additionally: String = ""
    
    convenience init(id: String, title: String, thumbnailUrl: String, videoUrl: String, publishedAt: String, channelId: String, channelTitle: String, additionally: String) {
        
        self.init()
        self.id = id
        self.title = title
        self.thumbnailUrl = thumbnailUrl
        self.videoUrl = videoUrl
        self.publishedAt = publishedAt
        self.channelId = channelId
        self.channelTitle = channelTitle
        self.additionally = additionally
    }
}
