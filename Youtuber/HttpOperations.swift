//
//  HttpOperation.swift
//  Youtuber
//
//  Created by LIV on 2/5/18.
//  Copyright © 2018 LIV. All rights reserved.
//

import UIKit

class HttpOperations: NSObject {
    
    static let shared = HttpOperations()
 
    func downloadImage(url: URL, completion: @escaping (_ image: UIImage)-> Void) {
        
        print("Download image Started \(url)")
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download image Finished")
            completion(UIImage(data: data)!)
        }
        
        return
    }

    private func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
}

