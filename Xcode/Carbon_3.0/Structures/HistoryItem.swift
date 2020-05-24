//
//  HistoryItem.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 11/28/18.
//  Copyright © 2018 Matt Marks. All rights reserved.
//

import Foundation
import UIKit

struct HistoryItem {
    
    // Required
    var time: TimeInterval!
    
    // Only should have one of these two. No more no less.
    var value: Int?
    var image: UIImage?
    
    // May or may not have this.
    var icon: UIImage?
    
    init(time: TimeInterval, value: Int, icon: UIImage? = nil) {
        self.time  = time
        self.value = value
        self.icon  = icon
    }
    
    init(time: TimeInterval, image: UIImage, icon: UIImage? = nil) {
        self.time  = time
        self.image = image
        self.icon  = icon
    }
    
}
