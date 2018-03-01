//
//  VideoListViewControllerUA.swift
//  Youtuber
//
//  Created by LIV on 2/2/18.
//  Copyright © 2018 LIV. All rights reserved.
//

import UIKit

class VideoListViewControllerFavorites: VideoListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadFromDB()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        loadFromDB()
    }

    override func buttonActionSettings() {
        
        self.performSegue(withIdentifier: "ShowSettingsFav", sender: self)
        print("Settings pressed")
    }
    
    // MARK: TableView operation
    
    override func configureCell(cell: CellWithVideo, index: Int) {
        super.configureCell(cell: cell, index: index)
        
        let labelWatched = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        labelWatched.center = CGPoint(x: 110, y: 70)
        labelWatched.textAlignment = .center
        labelWatched.text = "WATCHED"
        labelWatched.textColor = UIColor.magenta
        labelWatched.font = UIFont.boldSystemFont(ofSize: 30)
        labelWatched.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 4)
        labelWatched.layer.zPosition = 1
        cell.addSubview(labelWatched)
        cell.backgroundColor = .yellow
    }

    // MARK: - UI
    override func SetUI() {
        
        super.SetUI()
        
        tableViewVideoList.backgroundColor = .yellow
    }
    
    // MARK: DataBase
    func loadFromDB() {
        
        let dB = DataBase()
        let dataForTable = dB.realmLoadFromDBFav()
        
        DispatchQueue.main.async {
        
            self.videosArray = dataForTable.reversed()
            self.tableViewVideoList.reloadData()
        }
    }
}
