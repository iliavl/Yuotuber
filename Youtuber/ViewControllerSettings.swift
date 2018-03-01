//
//  ViewControllerSettings.swift
//  Youtuber
//
//  Created by LIV on 2/26/18.
//  Copyright © 2018 LIV. All rights reserved.
//
import UIKit

final class ViewControllerSettings: NSObject {

    static let shared = ViewControllerSettings()
    
    var countryFirstTabName = "Belarus"
    var countryFirstTabCode = "BY"
    var firstTabColor = UIColor.purple
    var countrySecondTabName = "UnitedStates"
    var countrySecondTabCode = "US"
    var SecondTabColor = UIColor.purple
    var countryThirdTabName = "China"
    var countryThirdTabCode = "CN"
    var thirdTabColor = UIColor.purple
}
