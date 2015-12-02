//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Richard Howes on 2015/12/01.
//  Copyright © 2015 workflow. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePathURL: NSURL!
    var title: String!
    
    // Initialiser to set the parameters of the object
    init(pathParm: NSURL, titleParm: String){
        filePathURL = pathParm
        title = titleParm
    }
}