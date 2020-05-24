//
//  CBParameters.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 11/3/18.
//  Copyright © 2018 Matt Marks. All rights reserved.
//

import Foundation
import UIKit

// Each player needs a few parameters (layout & edge) to figure out how to
// position themselves properly on the screen. This structure is a new data
// type that keeps track of those things. There are also some functions that
// perform computation on those two variables for the player.
struct CBParameters {
    
    // Each player needs to know which layout it is in.
    var layout: CBLayout
    
    // Each player needs to know which egde it will be built in.
    var edge: CBEdge
    
    // CBParameters must have both layout and edge values.
    init(layout: CBLayout, edge: CBEdge) {
        self.layout = layout
        self.edge = edge
    }
    
    // The rotation of the player. The rotations can be 0, pi/2, pi, or -pi/2.
    func rotation() -> CGFloat {
        switch layout {
        case .one   where edge == .none:     return .pi/2
        case .twoA  where edge == .top:      return .pi
        case .twoA  where edge == .bottom:   return 0
        case .twoB  where edge == .top:      return .pi/2
        case .twoB  where edge == .bottom:   return .pi/2
        case .three where edge == .left:     return .pi/2
        case .three where edge == .right:    return -.pi/2
        case .three where edge == .bottom:   return 0
        case .fourA where edge == .topLeft:  return .pi/2
        case .fourA where edge == .topRight: return -.pi/2
        case .fourA where edge == .botLeft:  return .pi/2
        case .fourA where edge == .botRight: return -.pi/2
        case .fourB where edge == .top:      return .pi
        case .fourB where edge == .left:     return .pi/2
        case .fourB where edge == .right:    return -.pi/2
        case .fourB where edge == .bottom:   return 0
        case .fiveA where edge == .topLeft:  return .pi/2
        case .fiveA where edge == .topRight: return -.pi/2
        case .fiveA where edge == .left:     return .pi/2
        case .fiveA where edge == .right:    return -.pi/2
        case .fiveA where edge == .bottom:   return 0
        case .fiveB where edge == .topLeft:  return .pi/2
        case .fiveB where edge == .topRight: return -.pi/2
        case .fiveB where edge == .right:    return -.pi/2
        case .fiveB where edge == .botLeft:  return .pi/2
        case .fiveB where edge == .botRight: return -.pi/2
        case .sixA  where edge == .topLeft:  return .pi/2
        case .sixA  where edge == .topRight: return -.pi/2
        case .sixA  where edge == .left:     return .pi/2
        case .sixA  where edge == .right:    return -.pi/2
        case .sixA  where edge == .botLeft:  return .pi/2
        case .sixA  where edge == .botRight: return -.pi/2
        case .sixB  where edge == .top:      return .pi
        case .sixB  where edge == .topLeft:  return .pi/2
        case .sixB  where edge == .topRight: return -.pi/2
        case .sixB  where edge == .botLeft:  return .pi/2
        case .sixB  where edge == .botRight: return -.pi/2
        case .sixB  where edge == .bottom:   return 0
        default:                             return 0
        }
    }
    
    // The frame that the player finds itself in. This is calculated prior to
    // rotation. In the game itself the rect that the frames are built within
    // are the entire screen. But in things like the layout buttons on the
    // setup menu these frames are used to draw players within the bounding
    // rectanges of the buttons.
    func frame(within rect: CGRect, seperation: CGFloat) -> CGRect {
        
        // This is a quick utility funciton to calculate with baised values.
        func w(_ widthMultiplier: CGFloat, _ seperationMultiplier: CGFloat) -> CGFloat {
            return rect.width * widthMultiplier + seperation * seperationMultiplier
        }
        
        // This is a quick utility funciton to calculate height baised values.
        func h(_ heightMultiplier: CGFloat, _ seperationMultiplier: CGFloat) -> CGFloat {
            return rect.height * heightMultiplier + seperation * seperationMultiplier
        }
        
        // This is just used to clean up this massive switch case a bit.
        var params: (x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat)
        
        switch layout {
        case .one   where edge == .none:     params = (w(0.0, 0.0), h(0.0,  0.0), w(1.0, 0.0), h(1.0,  0.0))
        case .twoA  where edge == .top:      params = (w(0.0, 0.0), h(0.0,  0.0), w(1.0, 0.0), h(1/2, -1/2))
        case .twoA  where edge == .bottom:   params = (w(0.0, 0.0), h(1/2,  1/2), w(1.0, 0.0), h(1/2, -1/2))
        case .twoB  where edge == .top:      params = (w(0.0, 0.0), h(0.0,  0.0), w(1.0, 0.0), h(1/2, -1/2))
        case .twoB  where edge == .bottom:   params = (w(0.0, 0.0), h(1/2,  1/2), w(1.0, 0.0), h(1/2, -1/2))
        case .three where edge == .left:     params = (w(0.0, 0.0), h(0.0,  0.0), w(1/2,-1/2), h(2/3, -1/2))
        case .three where edge == .right:    params = (w(1/2, 1/2), h(0.0,  0.0), w(1/2,-1/2), h(2/3, -1/2))
        case .three where edge == .bottom:   params = (w(0.0, 0.0), h(2/3,  1/2), w(1.0, 0.0), h(1/3, -1/2))
        case .fourA where edge == .topLeft:  params = (w(0.0, 0.0), h(0.0,  0.0), w(1/2,-1/2), h(1/2, -1/2))
        case .fourA where edge == .topRight: params = (w(1/2, 1/2), h(0.0,  0.0), w(1/2,-1/2), h(1/2, -1/2))
        case .fourA where edge == .botLeft:  params = (w(0.0, 0.0), h(1/2,  1/2), w(1/2,-1/2), h(1/2, -1/2))
        case .fourA where edge == .botRight: params = (w(1/2, 1/2), h(1/2,  1/2), w(1/2,-1/2), h(1/2, -1/2))
        case .fourB where edge == .top:      params = (w(0.0, 0.0), h(0.0,  0.0), w(1.0, 0.0), h(1/4, -1/2))
        case .fourB where edge == .left:     params = (w(0.0, 0.0), h(1/4,  1/2), w(1/2,-1/2), h(1/2, -1.0))
        case .fourB where edge == .right:    params = (w(1/2, 1/2), h(1/4,  1/2), w(1/2,-1/2), h(1/2, -1.0))
        case .fourB where edge == .bottom:   params = (w(0.0, 0.0), h(3/4,  1/2), w(1.0, 0.0), h(1/4, -1/2))
        case .fiveA where edge == .topLeft:  params = (w(0.0, 0.0), h(0.0,  0.0), w(1/2,-1/2), h(7/20,-1/2))
        case .fiveA where edge == .topRight: params = (w(1/2, 1/2), h(0.0,  0.0), w(1/2,-1/2), h(7/20,-1/2))
        case .fiveA where edge == .left:     params = (w(0.0, 0.0), h(7/20, 1/2), w(1/2,-1/2), h(7/20,-1.0))
        case .fiveA where edge == .right:    params = (w(1/2, 1/2), h(7/20, 1/2), w(1/2,-1/2), h(7/20,-1.0))
        case .fiveA where edge == .bottom:   params = (w(0.0, 0.0), h(0.7,  1/2), w(1.0, 0.0), h(0.3, -1/2))
        case .fiveB where edge == .topLeft:  params = (w(0.0, 0.0), h(0.0,  0.0), w(1/2,-1/2), h(1/2, -1/2))
        case .fiveB where edge == .topRight: params = (w(1/2, 1/2), h(0.0,  0.0), w(1/2,-1/2), h(1/3, -1/2))
        case .fiveB where edge == .right:    params = (w(1/2, 1/2), h(1/3,  1/2), w(1/2,-1/2), h(1/3, -1.0))
        case .fiveB where edge == .botLeft:  params = (w(0.0, 0.0), h(1/2,  1/2), w(1/2,-1/2), h(1/2, -1/2))
        case .fiveB where edge == .botRight: params = (w(1/2, 1/2), h(2/3,  1/2), w(1/2,-1/2), h(1/3, -1/2))
        case .sixA  where edge == .topLeft:  params = (w(0.0, 0.0), h(0.0,  0.0), w(1/2,-1/2), h(1/3, -1/2))
        case .sixA  where edge == .topRight: params = (w(1/2, 1/2), h(0.0,  0.0), w(1/2,-1/2), h(1/3, -1/2))
        case .sixA  where edge == .left:     params = (w(0.0, 0.0), h(1/3,  1/2), w(1/2,-1/2), h(1/3, -1.0))
        case .sixA  where edge == .right:    params = (w(1/2, 1/2), h(1/3,  1/2), w(1/2,-1/2), h(1/3, -1.0))
        case .sixA  where edge == .botLeft:  params = (w(0.0, 0.0), h(2/3,  1/2), w(1/2,-1/2), h(1/3, -1/2))
        case .sixA  where edge == .botRight: params = (w(1/2, 1/2), h(2/3,  1/2), w(1/2,-1/2), h(1/3, -1/2))
        case .sixB  where edge == .top:      params = (w(0.0, 0.0), h(0.0,  0.0), w(1.0, 0.0), h(0.2, -1/2))
        case .sixB  where edge == .topLeft:  params = (w(0.0, 0.0), h(0.2,  1/2), w(1/2,-1/2), h(0.3, -1.0))
        case .sixB  where edge == .topRight: params = (w(1/2, 1/2), h(0.2,  1/2), w(1/2,-1/2), h(0.3, -1.0))
        case .sixB  where edge == .botLeft:  params = (w(0.0, 0.0), h(1/2,  1/2), w(1/2,-1/2), h(0.3, -1.0))
        case .sixB  where edge == .botRight: params = (w(1/2, 1/2), h(1/2,  1/2), w(1/2,-1/2), h(0.3, -1.0))
        case .sixB  where edge == .bottom:   params = (w(0.0, 0.0), h(0.8,  1/2), w(1.0, 0.0), h(0.2, -1/2))
        default:                             return CGRect.zero
        }
        
        return CGRect(x: params.x, y: params.y, width: params.w, height: params.h)
    }
    
    // This app should work for a screen with any amount of notches on any size.
    // Each player, after rotation, has to be assigned the padding from the safe
    // area of the screen for that players edge. This padding is used to pad all
    // the objects locations within each player so they are never cut off by notches.
    func padding(forSide side: UIRectEdge) -> CGFloat {
        
        // Padding values are based off the sare are inserts of the device.
        let app = UIApplication.shared.delegate as! AppDelegate
        let area = app.window!.rootViewController!.view.safeAreaInsets
        
        switch layout {
        case .one   where edge == .none     && side == .top:    return area.right
        case .one   where edge == .none     && side == .left:   return area.top
        case .one   where edge == .none     && side == .right:  return area.bottom
        case .one   where edge == .none     && side == .bottom: return area.left
        case .twoA  where edge == .top      && side == .top:    return 0
        case .twoA  where edge == .top      && side == .left:   return area.right
        case .twoA  where edge == .top      && side == .right:  return area.left
        case .twoA  where edge == .top      && side == .bottom: return area.top
        case .twoA  where edge == .bottom   && side == .top:    return 0
        case .twoA  where edge == .bottom   && side == .left:   return area.left
        case .twoA  where edge == .bottom   && side == .right:  return area.right
        case .twoA  where edge == .bottom   && side == .bottom: return area.bottom
        case .twoB  where edge == .top      && side == .top:    return area.right
        case .twoB  where edge == .top      && side == .left:   return area.top
        case .twoB  where edge == .top      && side == .right:  return 0
        case .twoB  where edge == .top      && side == .bottom: return area.left
        case .twoB  where edge == .bottom   && side == .top:    return area.right
        case .twoB  where edge == .bottom   && side == .left:   return 0
        case .twoB  where edge == .bottom   && side == .right:  return area.bottom
        case .twoB  where edge == .bottom   && side == .bottom: return area.left
        case .three where edge == .left     && side == .top:    return 0
        case .three where edge == .left     && side == .left:   return area.top
        case .three where edge == .left     && side == .right:  return 0
        case .three where edge == .left     && side == .bottom: return area.left
        case .three where edge == .right    && side == .top:    return 0
        case .three where edge == .right    && side == .left:   return 0
        case .three where edge == .right    && side == .right:  return area.top
        case .three where edge == .right    && side == .bottom: return area.right
        case .three where edge == .bottom   && side == .top:    return 0
        case .three where edge == .bottom   && side == .left:   return area.left
        case .three where edge == .bottom   && side == .right:  return area.right
        case .three where edge == .bottom   && side == .bottom: return area.bottom
        case .fourA where edge == .topLeft  && side == .top:    return 0
        case .fourA where edge == .topLeft  && side == .left:   return area.top
        case .fourA where edge == .topLeft  && side == .right:  return 0
        case .fourA where edge == .topLeft  && side == .bottom: return area.left
        case .fourA where edge == .topRight && side == .top:    return 0
        case .fourA where edge == .topRight && side == .left:   return 0
        case .fourA where edge == .topRight && side == .right:  return area.top
        case .fourA where edge == .topRight && side == .bottom: return area.right
        case .fourA where edge == .botLeft  && side == .top:    return 0
        case .fourA where edge == .botLeft  && side == .left:   return 0
        case .fourA where edge == .botLeft  && side == .right:  return area.bottom
        case .fourA where edge == .botLeft  && side == .bottom: return area.left
        case .fourA where edge == .botRight && side == .top:    return 0
        case .fourA where edge == .botRight && side == .left:   return area.bottom
        case .fourA where edge == .botRight && side == .right:  return 0
        case .fourA where edge == .botRight && side == .bottom: return area.right
        case .fourB where edge == .top      && side == .top:    return 0
        case .fourB where edge == .top      && side == .left:   return area.right
        case .fourB where edge == .top      && side == .right:  return area.left
        case .fourB where edge == .top      && side == .bottom: return area.top
        case .fourB where edge == .left     && side == .top:    return 0
        case .fourB where edge == .left     && side == .left:   return 0
        case .fourB where edge == .left     && side == .right:  return 0
        case .fourB where edge == .left     && side == .bottom: return area.left
        case .fourB where edge == .right    && side == .top:    return 0
        case .fourB where edge == .right    && side == .left:   return 0
        case .fourB where edge == .right    && side == .right:  return 0
        case .fourB where edge == .right    && side == .bottom: return area.right
        case .fourB where edge == .bottom   && side == .top:    return 0
        case .fourB where edge == .bottom   && side == .left:   return area.left
        case .fourB where edge == .bottom   && side == .right:  return area.right
        case .fourB where edge == .bottom   && side == .bottom: return area.bottom
        case .fiveA where edge == .topLeft  && side == .top:    return 0
        case .fiveA where edge == .topLeft  && side == .left:   return area.top
        case .fiveA where edge == .topLeft  && side == .right:  return 0
        case .fiveA where edge == .topLeft  && side == .bottom: return area.left
        case .fiveA where edge == .topRight && side == .top:    return 0
        case .fiveA where edge == .topRight && side == .left:   return 0
        case .fiveA where edge == .topRight && side == .right:  return area.top
        case .fiveA where edge == .topRight && side == .bottom: return area.right
        case .fiveA where edge == .left     && side == .top:    return 0
        case .fiveA where edge == .left     && side == .left:   return 0
        case .fiveA where edge == .left     && side == .right:  return 0
        case .fiveA where edge == .left     && side == .bottom: return area.left
        case .fiveA where edge == .right    && side == .top:    return 0
        case .fiveA where edge == .right    && side == .left:   return 0
        case .fiveA where edge == .right    && side == .right:  return 0
        case .fiveA where edge == .right    && side == .bottom: return area.right
        case .fiveA where edge == .bottom   && side == .top:    return 0
        case .fiveA where edge == .bottom   && side == .left:   return area.left
        case .fiveA where edge == .bottom   && side == .right:  return area.right
        case .fiveA where edge == .bottom   && side == .bottom: return area.bottom
        case .fiveB where edge == .topLeft  && side == .top:    return 0
        case .fiveB where edge == .topLeft  && side == .left:   return area.top
        case .fiveB where edge == .topLeft  && side == .right:  return 0
        case .fiveB where edge == .topLeft  && side == .bottom: return area.left
        case .fiveB where edge == .topRight && side == .top:    return 0
        case .fiveB where edge == .topRight && side == .left:   return 0
        case .fiveB where edge == .topRight && side == .right:  return area.top
        case .fiveB where edge == .topRight && side == .bottom: return area.right
        case .fiveB where edge == .right    && side == .top:    return 0
        case .fiveB where edge == .right    && side == .left:   return 0
        case .fiveB where edge == .right    && side == .right:  return 0
        case .fiveB where edge == .right    && side == .bottom: return area.right
        case .fiveB where edge == .botLeft  && side == .top:    return 0
        case .fiveB where edge == .botLeft  && side == .left:   return 0
        case .fiveB where edge == .botLeft  && side == .right:  return area.bottom
        case .fiveB where edge == .botLeft  && side == .bottom: return area.left
        case .fiveB where edge == .botRight && side == .top:    return 0
        case .fiveB where edge == .botRight && side == .left:   return area.bottom
        case .fiveB where edge == .botRight && side == .right:  return 0
        case .fiveB where edge == .botRight && side == .bottom: return area.right
        case .sixA  where edge == .topLeft  && side == .top:    return 0
        case .sixA  where edge == .topLeft  && side == .left:   return area.top
        case .sixA  where edge == .topLeft  && side == .right:  return 0
        case .sixA  where edge == .topLeft  && side == .bottom: return area.left
        case .sixA  where edge == .topRight && side == .top:    return 0
        case .sixA  where edge == .topRight && side == .left:   return 0
        case .sixA  where edge == .topRight && side == .right:  return area.top
        case .sixA  where edge == .topRight && side == .bottom: return area.right
        case .sixA  where edge == .left     && side == .top:    return 0
        case .sixA  where edge == .left     && side == .left:   return 0
        case .sixA  where edge == .left     && side == .right:  return 0
        case .sixA  where edge == .left     && side == .bottom: return area.left
        case .sixA  where edge == .right    && side == .top:    return 0
        case .sixA  where edge == .right    && side == .left:   return 0
        case .sixA  where edge == .right    && side == .right:  return 0
        case .sixA  where edge == .right    && side == .bottom: return area.right
        case .sixA  where edge == .botLeft  && side == .top:    return 0
        case .sixA  where edge == .botLeft  && side == .left:   return 0
        case .sixA  where edge == .botLeft  && side == .right:  return area.bottom
        case .sixA  where edge == .botLeft  && side == .bottom: return area.left
        case .sixA  where edge == .botRight && side == .top:    return 0
        case .sixA  where edge == .botRight && side == .left:   return area.bottom
        case .sixA  where edge == .botRight && side == .right:  return 0
        case .sixA  where edge == .botRight && side == .bottom: return area.right
        case .sixB  where edge == .top      && side == .top:    return 0
        case .sixB  where edge == .top      && side == .left:   return area.right
        case .sixB  where edge == .top      && side == .right:  return area.left
        case .sixB  where edge == .top      && side == .bottom: return area.top
        case .sixB  where edge == .topLeft  && side == .top:    return 0
        case .sixB  where edge == .topLeft  && side == .left:   return 0
        case .sixB  where edge == .topLeft  && side == .right:  return 0
        case .sixB  where edge == .topLeft  && side == .bottom: return area.left
        case .sixB  where edge == .topRight && side == .top:    return 0
        case .sixB  where edge == .topRight && side == .left:   return 0
        case .sixB  where edge == .topRight && side == .right:  return 0
        case .sixB  where edge == .topRight && side == .bottom: return area.right
        case .sixB  where edge == .botLeft  && side == .top:    return 0
        case .sixB  where edge == .botLeft  && side == .left:   return 0
        case .sixB  where edge == .botLeft  && side == .right:  return 0
        case .sixB  where edge == .botLeft  && side == .bottom: return area.left
        case .sixB  where edge == .botRight && side == .top:    return 0
        case .sixB  where edge == .botRight && side == .left:   return 0
        case .sixB  where edge == .botRight && side == .right:  return 0
        case .sixB  where edge == .botRight && side == .bottom: return area.right
        case .sixB  where edge == .bottom   && side == .top:    return 0
        case .sixB  where edge == .bottom   && side == .left:   return area.left
        case .sixB  where edge == .bottom   && side == .right:  return area.right
        case .sixB  where edge == .bottom   && side == .bottom: return area.bottom
        default: return 0
        }
    }
    
}
