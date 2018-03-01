//
//  VideoListViewControllerUA.swift
//  Youtuber
//
//  Created by LIV on 2/2/18.
//  Copyright © 2018 LIV. All rights reserved.
//

import UIKit

class VideoListViewControllerCA: VideoListViewController {
    
    override var tab: String {return "second"}
    
    override func buttonActionSettings() {
        
        self.performSegue(withIdentifier: "ShowSettingsCA", sender: self)
        print("Settings pressed")
    }
    
    override func configureCell(cell: CellWithVideo, index: Int) {
        
        super.configureCell(cell: cell, index: index)
        
        cell.backgroundColor = cellColorSecondTab
    }
}
