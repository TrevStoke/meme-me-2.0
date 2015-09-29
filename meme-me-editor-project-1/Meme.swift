//
//  Meme.swift
//  meme-me-editor-project-1
//
//  Created by Trevor Adams on 28/09/2015.
//  Copyright © 2015 Trevor Adams. All rights reserved.
//

import Foundation
import UIKit

struct Meme: CustomStringConvertible {
    var originalImage:UIImage!
    var memedImage:UIImage!
    var topText:String!
    var bottomText:String!
    var description: String {
        return "Meme Image - top: " + topText + " / bottom: " + bottomText
    }
}