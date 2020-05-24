//
//  File.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 1/9/19.
//  Copyright © 2019 Matt Marks. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {
    
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
    
}
