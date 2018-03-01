//
//  CellVideoAttribute.swift
//  Youtuber
//
//  Created by LIV on 1/31/18.
//  Copyright © 2018 LIV. All rights reserved.
//

import Foundation

struct CellVideoAttribute {
    
    let id: String
    let title: String
    let thumbnailUrl: String
    let videoUrl: String
    let publishedAt: String
    let channelId: String
    let channelTitle: String
    
    init(id: String, title: String, thumbnailUrl: String, videoUrl: String, publishedAt: String, channelId: String, channelTitle: String) {
    
        self.id = id
        self.title = title
        self.thumbnailUrl = thumbnailUrl
        self.videoUrl = videoUrl
        self.publishedAt = publishedAt
        self.channelId = channelId
        self.channelTitle = channelTitle
        print("init: \(id)_\(title)_\(thumbnailUrl)_\(videoUrl)_\(publishedAt)_\(channelId)_\(channelTitle)")
    }
}
