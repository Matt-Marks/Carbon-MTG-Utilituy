//
//  UIRect+Extension.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 11/24/18.
//  Copyright © 2018 Matt Marks. All rights reserved.
//

import Foundation
import UIKit

extension CGSize {
    
    func flippedWithAndHeight() -> CGSize {
        return CGSize(width: self.height, height: self.width)
    }
    
}
