//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Jared Zenk on 04/27/15.
//  Copyright (c) 2015 Jared Zenk. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    var filePathURL: NSURL!
    var title: String!
    
    init(filePathURL: NSURL!, title: String!) {
        self.filePathURL = filePathURL
        self.title = title
    }
}