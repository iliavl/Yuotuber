//
//  VideoListView.swift
//  Youtuber
//
//  Created by LIV on 1/30/18.
//  Copyright © 2018 LIV. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer
import XCDYouTubeKit
import UserNotifications

class VideoListViewController: UITableViewController, SettingsViewControllerDelegate {
    
    var videosArray = [CellVideoAttribute]()
    var jsonLoader = JsonOperation()
    var tab: String {return "first"}
    var cellColorFirstTab = UIColor.white
    var cellColorSecondTab = UIColor.white
    var cellColorThirdTab = UIColor.white
    
    @IBOutlet var tableViewVideoList: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let regionCode = getRegionCode()
        
        if regionCode != "" {
         
            loadFromJsonInTable(urlString: "https://www.googleapis.com/youtube/v3/videos?part=contentDetails&chart=mostPopular&regionCode=\(regionCode)&maxResults=25&key=AIzaSyCpgNZjnS3ywS8nfVFm_UEY7Ewf87_PCiE")
        }
        SetUI()
    }
    
    func getRegionCode() -> String {
        
        var regionCode = ""
        var regionCodeSettings = ""
        
        if tab == "first" {
            
            regionCodeSettings = ViewControllerSettings.shared.countryFirstTabCode
            
            if let regionCodeUserDefaults = UserDefaults.standard.object(forKey: "countryFirstTabCode") as? String {
                
                regionCode = regionCodeUserDefaults
                
            } else {
                
                regionCode = regionCodeSettings
            }
            
        } else if tab == "second" {
            
            regionCodeSettings = ViewControllerSettings.shared.countrySecondTabCode
            
            if let regionCodeUserDefaults = UserDefaults.standard.object(forKey: "countrySecondTabCode") as? String {
                
                regionCode = regionCodeUserDefaults
                
            } else {
                
                regionCode = regionCodeSettings
            }
            
        } else if tab == "third" {
            
            regionCodeSettings = ViewControllerSettings.shared.countryThirdTabCode
            
            if let regionCodeUserDefaults = UserDefaults.standard.object(forKey: "countryThirdTabCode") as? String {
                
                regionCode = regionCodeUserDefaults
                
            } else {
                
                regionCode = regionCodeSettings
            }
        }
       
        return regionCode
    }
    
    // MARK: - TableView operation
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("CellWithVideo", owner: self, options: nil)?.first as! CellWithVideo
        let index = indexPath.row
        
        configureCell(cell: cell, index: index)
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return videosArray.count
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath){
        
    }
   
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        let videoIdentifier = videosArray[indexPath.row].id
        playerStream(videoIdentifier: videoIdentifier)
        
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 140
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let degree: Double = 90
        let rotationAngle = CGFloat(degree * M_PI / 180)
        let rotationTransform = CATransform3DMakeRotation(rotationAngle, 0, 1, 0)
        cell.layer.transform = rotationTransform
        
        UIView.animate(withDuration: 0.8, delay: 0.2, options: .curveEaseInOut, animations: { cell.layer.transform = CATransform3DIdentity })
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 40
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor(displayP3Red: 255/255, green: 166/255, blue: 201/255, alpha: 1)
        buttonSettingsUI(headerView: headerView)
        
        return headerView
    }
    
    // MARK: - UI
    func SetUI() {
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        self.tableViewVideoList.contentInset = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.white
        tabBarController?.tabBar.tintColor = UIColor.white
        tableViewVideoList.backgroundColor = UIColor(displayP3Red: 0.9, green: 1, blue: 0.8, alpha: 1)
        loadUserDefaults()
    }
 
    func loadUserDefaults() {
        
        let settingsVC = ViewControllerSettings.shared
        var useSettings = false
        
        if let tabName0 = UserDefaults.standard.object(forKey: "countryFirstTabName") as? String {
            
            setTabAtributes(name: tabName0, index: 0)
            let colorTab = UserDefaults.standard.color(forKey: "firstTabColor")
            if colorTab != nil {
                
                cellColorFirstTab = colorTab!
            }
            
        } else {
            
            let tabName0 = settingsVC.countryFirstTabName
            setTabAtributes(name: tabName0, index: 0)
            useSettings = true
        }
        
        if let tabName1 = UserDefaults.standard.object(forKey: "countrySecondTabName") as? String {
            
            setTabAtributes(name: tabName1, index: 1)
            let colorTab = UserDefaults.standard.color(forKey: "secondTabColor")
            if colorTab != nil {
                
                cellColorSecondTab = colorTab!
            }
            
        } else {
            
            let tabName1 = settingsVC.countrySecondTabName
            setTabAtributes(name: tabName1, index: 1)
            useSettings = true
        }
        
        if let tabName2 = UserDefaults.standard.object(forKey: "countryThirdTabName") as? String {
            
            setTabAtributes(name: tabName2, index: 2)
            let colorTab = UserDefaults.standard.color(forKey: "thirdTabColor")
            if colorTab != nil {
                
                cellColorThirdTab = colorTab!
            }
            
        } else {
            
            let tabName2 = settingsVC.countryThirdTabName
            setTabAtributes(name: tabName2, index: 2)
            useSettings = true
        }
        
        if useSettings {
            
            let alert = UIAlertController(title: "Help", message: "you can customize the tabs in the application", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            print("Using standart setings")
        }
    }
    
    func setTabAtributes(name: String, index: Int) {
        
        tabBarController?.tabBar.items?[index].title = name
        let image = UIImage(named: name) as UIImage?
        tabBarController?.tabBar.items?[index].image = image
        tabBarController?.tabBar.items?[index].selectedImage = image
    }

    func buttonSettingsUI(headerView: UIView) {
        
        let buttonSettings = UIButton(frame: CGRect(x: tableViewVideoList.frame.width - 40, y: 0, width: 40, height: 40))
        let image = UIImage(named: "Settings") as UIImage?
        buttonSettings.setBackgroundImage(image, for: UIControlState.normal)
        buttonSettings.addTarget(self, action: #selector(buttonActionSettings), for: .touchUpInside)
        headerView.addSubview(buttonSettings)
        let labelLogo = UILabel(frame: CGRect(x: tableViewVideoList.frame.width/2 - 50, y: 0, width: 100, height: 40))
        labelLogo.text = "YOUTUBER"
        headerView.addSubview(labelLogo)
    }
    
    func buttonActionSettings() {
        
    }
    
    func configureCell(cell: CellWithVideo, index: Int) {
        
        let imageThumbnail = cell.imageThumbnail
        imageThumbnail?.layer.cornerRadius = 10
        imageThumbnail?.clipsToBounds = true
        
        let title = videosArray[index].title
        cell.labelTitle.text = title
        
        if let thumbnailUrl = URL(string: videosArray[index].thumbnailUrl) {
            
            let activityIndicator = UIActivityIndicatorView()
            activityIndicator.frame = cell.imageThumbnail.bounds
            cell.imageThumbnail.addSubview(activityIndicator)
            activityIndicator.center = cell.imageThumbnail.center
            activityIndicator.activityIndicatorViewStyle = .whiteLarge
            activityIndicator.color = .magenta
            activityIndicator.startAnimating()
            
            HttpOperations.shared.downloadImage(url: thumbnailUrl) {(image) in
                DispatchQueue.main.async{
                    
                    cell.imageThumbnail.image = image
                    activityIndicator.stopAnimating()
                    activityIndicator.removeFromSuperview()
                }
            }
        }
        
        cell.buttonSaveToDB.tag = index
        cell.buttonSaveToDB.addTarget(self, action: #selector(buttonClickSaveAsFavoriteToDB(sender: )), for: UIControlEvents.touchUpInside)
        
        if checkFavorite(id: videosArray[index].id) {
            
            let image = UIImage(named: "star-png") as UIImage?
            cell.buttonSaveToDB.setBackgroundImage(image, for: UIControlState.normal)
        }         
    }
    
    // MARK: - DataBase
    func buttonClickSaveAsFavoriteToDB(sender: UIButton) {
        
        let dB = DataBase()
        let index = sender.tag
        let data = videosArray[index]
        let id = data.id
        
        if checkFavorite(id: id) {
            
            print("Video with id = \(id) is exist in favorites")
            dB.realmDeleteObjectFromDB(id: id)
            
            self.tableViewVideoList.reloadData()
            
            scheduleNotification(inSeconds: 5) { (success) in
                
                if success {
                    
                    print("Send notofication")
                    
                } else {
                    
                    print("Notification not sended")
                }
            }
            
        } else {
            
            
            dB.realmAddToDBFav(id: data.id, name: data.title, thumbnailUrl: data.thumbnailUrl, videoUrl: data.videoUrl, publishedAt: data.publishedAt, channelId: data.channelId, channelTitle: data.channelTitle, additionally: "")
            
            self.tableViewVideoList.reloadData()
            
            scheduleNotification(inSeconds: 5) { (success) in
                
                if success {
                    
                    print("Send notofication")
                    
                } else {
                    
                    print("Notification not sended")
                }
            }
        }
    }
    
    func checkFavorite(id: String) -> Bool {
        
        var favoriteVideo = false
        
        let dB = DataBase()
        favoriteVideo = dB.findElementInDB(id: id)
        
        return favoriteVideo
    }
    
    func countOfFavorites() -> Int {
        
        let dB = DataBase()
        let countOfVideosInFavorites = dB.countElementsInDBTable()
        
        return countOfVideosInFavorites
    }

    // MARK: - Internet
    func loadFromJsonInTable(urlString: String) {
        
        JsonOperation.sharedInstance.loadDataJsonForVideoListArray(urlString: urlString) {[weak self] (dataForTable) in
            
            guard let `self` = self else { return }
            
            let countOfDatatable = dataForTable.count
            
            if countOfDatatable > 0 {
                
                var newDataForTable = [CellVideoAttribute]()
                for item in dataForTable {
                    
                    JsonOperation.sharedInstance.loadDataJsonForVideoListArrayElement(Element: item) {[weak self] (dataElementTable) in
                        
                        guard let `self` = self else { return }
                        
                        newDataForTable.append(dataElementTable)
                        
                        DispatchQueue.main.async {
                            
                            self.videosArray = newDataForTable
                            self.tableViewVideoList.reloadData()
                        }
                    }
                }
            }
        }
    }
    // MARK: - Player
    struct YouTubeVideoQuality {
        
        static let hd720 = NSNumber(value: XCDYouTubeVideoQuality.HD720.rawValue)
        static let medium360 = NSNumber(value: XCDYouTubeVideoQuality.medium360.rawValue)
        static let small240 = NSNumber(value: XCDYouTubeVideoQuality.small240.rawValue)
    }
    
    func playerStream(videoIdentifier: String) {
        
        let playerViewController = AVPlayerViewController()
        self.present(playerViewController, animated: true, completion: nil)
        
        XCDYouTubeClient.default().getVideoWithIdentifier(videoIdentifier) { [weak playerViewController] (video: XCDYouTubeVideo?, error: Error?) in
            if let streamURLs = video?.streamURLs, let streamURL = (streamURLs[XCDYouTubeVideoQualityHTTPLiveStreaming] ?? streamURLs[YouTubeVideoQuality.hd720] ?? streamURLs[YouTubeVideoQuality.medium360] ?? streamURLs[YouTubeVideoQuality.small240]) {
                playerViewController?.player = AVPlayer(url: streamURL)
                let dB = DataBase()
                dB.realmChangeObjectFromDB(id: videoIdentifier, nameElement: "additionally", dataElement: "yes")
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Notification
    
    func scheduleNotification(inSeconds seconds: TimeInterval, completion: (Bool) -> ()) {
        
        removeNotifications(withIdentifiers: ["DataBase"])
        
        let date = Date(timeIntervalSinceNow: seconds)
        print(Date())
        print(date)
        
        let content = UNMutableNotificationContent()
        content.title = "This is Youtuber notification"
        let countFavoritesVideos = countOfFavorites()
        content.body = "Count of favorites videos is \(countFavoritesVideos)"
        content.sound = UNNotificationSound.default()
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: "DataBase", content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: nil)
    }
    
    func removeNotifications(withIdentifiers identifiers: [String]) {
        
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    
    //MARK: - Delegate

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowSettingsBY" {
            
            let vc = segue.destination as! SettingsViewController
            vc.delegate = self
        }
        
        if segue.identifier == "ShowSettingsCA" {
            
            let vc = segue.destination as! SettingsViewController
            vc.delegate = self
        }

        if segue.identifier == "ShowSettingsJP" {
            
            let vc = segue.destination as! SettingsViewController
            vc.delegate = self
        }

        if segue.identifier == "ShowSettingsFav" {
            
            let vc = segue.destination as! SettingsViewController
            vc.delegate = self
        }
    }
    func changeUI() {
    
        viewDidLoad()
    }
}

// MARK: - Extensions
extension UIApplication {
    
    var statusBarView: UIView? {
        
        return value(forKey: "statusBar") as? UIView
    }
}
