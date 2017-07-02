//
//  CarregadorJSON.swift
//  AbouTVGuide
//
//  Created by Luis Felipe Sobral on 21/06/17.
//  Copyright © 2017 AbouTV. All rights reserved.
//

import UIKit

class CarregadorJSON {
    
    func carregaTodasSeries (callback: @escaping ((_ series: NSArray)->())) {
        let url = NSURL(string: "http://api.tvmaze.com/shows")
        
        var downloadTask = URLRequest(url: (url as URL?)!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 20)
        
        downloadTask.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: downloadTask, completionHandler: {(data, response, error) -> Void in
            if let jsonData = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSArray {
                callback(jsonData)
            }        
        }).resume()
    }
    
    func carregaBusca(show: String, callback: @escaping ((_ series: NSArray) -> ())) {
        let url = NSURL(string: "http://api.tvmaze.com/search/shows?q=" + show)
        
        var downloadTask = URLRequest(url: (url as URL?)!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 20)
        
        downloadTask.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: downloadTask, completionHandler: {(data, response, error) -> Void in
            if let jsonData = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSArray {
                callback(jsonData)
            }
        }).resume()
    }
}
