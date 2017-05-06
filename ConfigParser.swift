//
//  ConfigParser.swift
//  kContext
//
//  Created by James Weber on 5/4/17.
//  Copyright © 2017 James Weber. All rights reserved.
//

import Cocoa
import SwiftyJSON

class ConfigParser: NSObject {

    struct ConfigData {
        var currentContext: JSON?
        var contextNames: Array<String>
        
    }
    func parseConfig(config: String) -> ConfigData {
        var configData = ConfigData(currentContext: "", contextNames: [])
        if let dataFromString = config.data(using: .utf8, allowLossyConversion: false) {
            let json = JSON(data: dataFromString)
            configData.currentContext =  json["current-context"]
            print(json["contexts"])
            print("test")
            
            var idx = 0
            for (_, contextBlock) in json["contexts"] {
                print(contextBlock["name"])
                configData.contextNames.append(contextBlock["name"].string!)
                idx += 1
            }
            
        }else{
            print("Problem getting data from json string")
        }
        
        return configData
    }
}
