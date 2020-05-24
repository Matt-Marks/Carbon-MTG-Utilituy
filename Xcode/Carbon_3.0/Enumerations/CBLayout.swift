//
//  UILayout.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 11/3/18.
//  Copyright © 2018 Matt Marks. All rights reserved.
//

import Foundation

enum CBLayout {
    case one, twoA, twoB, three, fourA, fourB, fiveA, fiveB, sixA, sixB
    
    var parameters: [CBParameters] {
        switch self {
        case .one:
            return [CBParameters(layout: .one, edge: .none)]
        case .twoA:
            return [CBParameters(layout: .twoA, edge: .top),
                    CBParameters(layout: .twoA, edge: .bottom)]
        case .twoB:
            return [CBParameters(layout: .twoB, edge: .top),
                    CBParameters(layout: .twoB, edge: .bottom)]
        case .three:
            return [CBParameters(layout: .three, edge: .left),
                    CBParameters(layout: .three, edge: .right),
                    CBParameters(layout: .three, edge: .bottom)]
        case .fourA:
            return [CBParameters(layout: .fourA, edge: .topLeft),
                    CBParameters(layout: .fourA, edge: .topRight),
                    CBParameters(layout: .fourA, edge: .botLeft),
                    CBParameters(layout: .fourA, edge: .botRight)]
        case .fourB:
            return [CBParameters(layout: .fourB, edge: .top),
                    CBParameters(layout: .fourB, edge: .left),
                    CBParameters(layout: .fourB, edge: .right),
                    CBParameters(layout: .fourB, edge: .bottom)]
        case .fiveA:
            return [CBParameters(layout: .fiveA, edge: .topLeft),
                    CBParameters(layout: .fiveA, edge: .topRight),
                    CBParameters(layout: .fiveA, edge: .left),
                    CBParameters(layout: .fiveA, edge: .right),
                    CBParameters(layout: .fiveA, edge: .bottom)]
        case .fiveB:
            return [CBParameters(layout: .fiveB, edge: .topLeft),
                    CBParameters(layout: .fiveB, edge: .topRight),
                    CBParameters(layout: .fiveB, edge: .right),
                    CBParameters(layout: .fiveB, edge: .botLeft),
                    CBParameters(layout: .fiveB, edge: .botRight)]
        case .sixA:
            return [CBParameters(layout: .sixA, edge: .topLeft),
                    CBParameters(layout: .sixA, edge: .topRight),
                    CBParameters(layout: .sixA, edge: .left),
                    CBParameters(layout: .sixA, edge: .right),
                    CBParameters(layout: .sixA, edge: .botLeft),
                    CBParameters(layout: .sixA, edge: .botRight)]
        case .sixB:
            return [CBParameters(layout: .sixB, edge: .top),
                    CBParameters(layout: .sixB, edge: .topLeft),
                    CBParameters(layout: .sixB, edge: .topRight),
                    CBParameters(layout: .sixB, edge: .botLeft),
                    CBParameters(layout: .sixB, edge: .botRight),
                    CBParameters(layout: .sixB, edge: .bottom)]
        }
    }
}
