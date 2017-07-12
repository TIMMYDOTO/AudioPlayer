//
//  AudioRecord.swift
//  Audio
//
//  Created by User1 on 7/10/17.
//  Copyright © 2017 User1. All rights reserved.
//

import UIKit

class AudioRecord: NSObject {
    var time:String
    var date:String
    
    let duration:String
    let filePath:String
    var name:String
    
    init(duration:String, filePath:String, fileName:String, time:String, date:String) {
        self.time = time
        self.date = date
        
        self.duration = duration
        self.filePath = filePath
        self.name = fileName
    }
 
    
    
}
