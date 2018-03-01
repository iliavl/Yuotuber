//
//  SettingsViewController.swift
//  Youtuber
//
//  Created by LIV on 2/21/18.
//  Copyright © 2018 LIV. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate: class {
    
    func changeUI()
}

class SettingsViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    weak var delegate: SettingsViewControllerDelegate?
    
    // MARK: - IBOutlets
    @IBOutlet var tableViewSettings: UITableView!
    @IBOutlet weak var labelCountry1: UILabel!
    @IBOutlet weak var labelCountry2: UILabel!
    @IBOutlet weak var labelCountry3: UILabel!
    @IBOutlet weak var labelCellColor1: UILabel!
    @IBOutlet weak var labelCellColor2: UILabel!
    @IBOutlet weak var labelCellColor3: UILabel!
    @IBOutlet weak var textCountry1: UITextField!
    @IBOutlet weak var textCountry2: UITextField!
    @IBOutlet weak var textCountry3: UITextField!
    @IBOutlet weak var textCellColor1: UITextField!
    @IBOutlet weak var textCellColor2: UITextField!
    @IBOutlet weak var textCellColor3: UITextField!
    
    var countryList: [(name: String, code: String)] = [("Belarus", "BY"), ("Canada", "CA"), ("China", "CN"), ("CzechRepublic", "CZ"), ("Finland", "FI"), ("Germany", "DE"), ("India", "IN"), ("Italy", "IT"), ("Japan", "JP"), ("Mexico", "MX"), ("Russia", "RU"), ("Sweden", "SE"), ("Switzerland", "CH"), ("Ukraine", "UA"), ("UnitedStates", "US"), ("UnitedKingdom", "UK")]
    var colorList: [(colorName: String, color: UIColor)] = [("red", .red),("green", .green),("blue", .blue),("yellow", .yellow),("magenta", .magenta),("white", .white),("gray", .lightGray)]
    var textFields = [UITextField]()
    var activeTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFields = [textCountry1,textCountry2,textCountry3,textCellColor1,textCellColor2,textCellColor3]
        loadSettings()
        SetUI()
        createPicker()
        createToolbar()
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - IBActions
    @IBAction func buttonSaveAction(_ sender: UIBarButtonItem) {
        
        let textFieldsCountry = [textCountry1, textCountry2, textCountry3]
        var alertBadTextField = false
        
        for element in textFieldsCountry {
            
            let code = element?.text
            
            let goodTextInTextField = countryList.contains(where: { (item) -> Bool in
                
                item.code == code
            })
            
            if !goodTextInTextField {
                
                alertBadTextField = true
                print("Bad symbols in text fields")
            }
        }
        
        if alertBadTextField {
            
            let alert = UIAlertController(title: "Alert", message: "Bad symbols in text fields", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            print("Bad symbols in text fields")
            
            return
        }
        
        print("Saving Users Defaults")
        
        UserDefaults.standard.set(textCountry1.text, forKey: "countryFirstTabCode")
        UserDefaults.standard.set(textCountry2.text, forKey: "countrySecondTabCode")
        UserDefaults.standard.set(textCountry3.text, forKey: "countryThirdTabCode")
        
        let index1 = countryList.index(where: { (item) -> Bool in
            
            item.code == textCountry1.text
        })
        
        let index2 = countryList.index(where: { (item) -> Bool in
            
            item.code == textCountry2.text
        })
        
        let index3 = countryList.index(where: { (item) -> Bool in
            
            item.code == textCountry3.text
        })
        
        UserDefaults.standard.set(countryList[index1!].name, forKey: "countryFirstTabName")
        UserDefaults.standard.set(countryList[index2!].name, forKey: "countrySecondTabName")
        UserDefaults.standard.set(countryList[index3!].name, forKey: "countryThirdTabName")
        UserDefaults.standard.set(textCellColor1.backgroundColor, forKey: "firstTabColor")
        UserDefaults.standard.set(textCellColor2.backgroundColor, forKey: "secondTabColor")
        UserDefaults.standard.set(textCellColor3.backgroundColor, forKey: "thirdTabColor")
        
        delegate?.changeUI()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonCancelAction(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UI
    func SetUI() {
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        self.tableViewSettings.contentInset = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.white
        tabBarController?.tabBar.tintColor = UIColor.white
    }
    
    func loadSettings() {
        
        let settingsVC = ViewControllerSettings.shared
        
        if let tabName0 = UserDefaults.standard.object(forKey: "countryFirstTabCode") as? String {
            
            textCountry1.text = tabName0
            textCellColor1.backgroundColor = UserDefaults.standard.color(forKey: "firstTabColor")
            
        } else {
            
            let tabName0 = settingsVC.countryFirstTabName
            textCountry1.text = tabName0
        }
        
        if let tabName1 = UserDefaults.standard.object(forKey: "countrySecondTabCode") as? String {
            
            textCountry2.text = tabName1
            textCellColor2.backgroundColor = UserDefaults.standard.color(forKey: "secondTabColor")
            
        } else {
            
            let tabName1 = settingsVC.countrySecondTabName
            textCountry2.text = tabName1
        }
        
        if let tabName2 = UserDefaults.standard.object(forKey: "countryThirdTabCode") as? String {
            
            textCountry3.text = tabName2
            textCellColor3.backgroundColor = UserDefaults.standard.color(forKey: "thirdTabColor")
            
        } else {
            
            let tabName2 = settingsVC.countryThirdTabName
            textCountry3.text = tabName2
        }
    }
    
    func setTabAtributes(name: String, index: Int) {
        
        tabBarController?.tabBar.items?[index].title = name
    }
    
    // MARK: -- pickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if activeTextField.tag == 1 {
            
            return colorList.count
            
        } else {
            
            return countryList.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        if activeTextField.tag == 1 {
            
            return colorList[row].colorName
            
        } else {
            
            return countryList[row].name
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        setDataInTextField(textField: activeTextField, index: row)
        pickerView.reloadAllComponents()
    }
    
    func createPicker() {
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        textCountry1.delegate = self
        textCountry2.delegate = self
        textCountry3.delegate = self
        textCellColor1.tag = 1
        textCellColor2.tag = 1
        textCellColor3.tag = 1
        textCellColor1.delegate = self
        textCellColor2.delegate = self
        textCellColor3.delegate = self
        textCountry1.inputView = pickerView
        textCountry2.inputView = pickerView
        textCountry3.inputView = pickerView
        textCellColor1.inputView = pickerView
        textCellColor2.inputView = pickerView
        textCellColor3.inputView = pickerView
    }
    
    func createToolbar(){
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let buttonDone = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKeyboard))
        
        toolBar.setItems([buttonDone], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        textCountry1.inputAccessoryView = toolBar
        textCountry2.inputAccessoryView = toolBar
        textCountry3.inputAccessoryView = toolBar
        textCellColor1.inputAccessoryView = toolBar
        textCellColor2.inputAccessoryView = toolBar
        textCellColor3.inputAccessoryView = toolBar
    }
    
    func dismissKeyboard() {
        
        view.endEditing(true)
        
        for textFieldElement in textFields {
            
            textFieldElement.isUserInteractionEnabled = true
        }

    }
    
    func setDataInTextField(textField: UITextField, index: Int) {
        
        if textField.tag == 1 {
            
            textField.backgroundColor = colorList[index].color
            
        } else {
            
            textField.text = countryList[index].code
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {

        if textField != activeTextField {
            
            dismissKeyboard()
            
            for textFieldElement in textFields {
                
                if textField != textFieldElement {
                    
                    textFieldElement.isUserInteractionEnabled = false
                }
            }
        }
        activeTextField = textField
    }
}

extension UserDefaults {
    
    func color(forKey defaultName: String) -> UIColor? {
        
        var color: UIColor?
        
        if let colorData = data(forKey: defaultName) {
            
            color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor
        }
        
        return color
    }
    
    func set(_ value: UIColor?, forKey defaultName: String) {
        
        var colorData: NSData?
        
        if let color = value {
            
            colorData = NSKeyedArchiver.archivedData(withRootObject: color) as NSData?
        }
        
        set(colorData, forKey: defaultName)
    }
}
