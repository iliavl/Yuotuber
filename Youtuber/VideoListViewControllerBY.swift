//
//  VideoListViewControllerUA.swift
//  Youtuber
//
//  Created by LIV on 2/2/18.
//  Copyright © 2018 LIV. All rights reserved.
//

import UIKit

class VideoListViewControllerBY: VideoListViewController {
        
    override var tab: String {return "first"}
    
    override func buttonActionSettings() {
        
        self.performSegue(withIdentifier: "ShowSettingsBY", sender: self)
        print("Settings pressed")
    }
    
    override func configureCell(cell: CellWithVideo, index: Int) {
        
        super.configureCell(cell: cell, index: index)
        
        cell.backgroundColor = cellColorFirstTab
    }
}
