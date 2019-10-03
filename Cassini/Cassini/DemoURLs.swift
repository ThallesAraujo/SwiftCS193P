//
//  DemoURLs.swift
//  Cassini
//
//  Created by Thalles Araújo on 30/09/19.
//  Copyright © 2019 Thalles Araújo. All rights reserved.
//

import Foundation

struct DemoURLs{
    
    static let placebo = Bundle.main.url(forResource: "landscape", withExtension: "jpg")
    
    static var NASA: Dictionary<String, URL> = {
        let NASAURLStrings = [
            "Cassini" : "https://photojournal.jpl.nasa.gov/jpeg/PIA23172.jpg",
            "Earth": "https://photojournal.jpl.nasa.gov/jpeg/PIA23018.jpg",
            "Saturn": "https://photojournal.jpl.nasa.gov/jpeg/PIA22418.jpg"
        ]
        
        var urls = Dictionary<String, URL>()
        for(key, value) in NASAURLStrings{
            urls[key] = URL(string: value)
        }
        
        return urls
    }()
    
}
