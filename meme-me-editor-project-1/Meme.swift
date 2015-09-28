//
//  Meme.swift
//  meme-me-editor-project-1
//
//  Created by Trevor Adams on 28/09/2015.
//  Copyright © 2015 Trevor Adams. All rights reserved.
//

import Foundation
import UIKit

class Meme: CustomStringConvertible {
    var originalImage:UIImage!
    var memedImage:UIImage!
    var topText:String!
    var bottomText:String!
    
    init(originalImage:UIImage, memedImage:UIImage, topText:String, bottomText:String) {
        self.originalImage = originalImage
        self.memedImage = memedImage
        self.topText = topText
        self.bottomText = bottomText
    }
    
    var description: String {
        return "Meme Image - top: " + topText + " / bottom: " + bottomText
    }
}