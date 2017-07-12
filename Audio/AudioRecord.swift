//
//  AudioRecord.swift
//  Audio
//
//  Created by User1 on 7/10/17.
//  Copyright © 2017 User1. All rights reserved.
//

import UIKit

class AudioRecord: NSObject {
    let duration:String
    let filePath:String
    var name:String
    
    init(duration:String, filePath:String, fileName:String) {
        self.duration = duration
        self.filePath = filePath
        self.name = fileName
    }
 
    
    
}
