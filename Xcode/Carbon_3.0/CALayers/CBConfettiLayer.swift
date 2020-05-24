//
//  ConfettiLayer.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 1/8/19.
//  Copyright © 2019 Matt Marks. All rights reserved.
//

import Foundation
import UIKit

class CBConfettiLayer: CAEmitterLayer {
    
    // TODO: - Add init for custom images in addition to its frame.
    
    convenience init(frame: CGRect) {
        self.init()
        self.frame = frame
        defer {
            emitterPosition = CGPoint(x: frame.width/2, y: -10)
            emitterSize     = CGSize(width: frame.width, height: 2.0)
            emitterShape    = CAEmitterLayerEmitterShape.line
            emitterCells    = generateEmitterCells()
//            shadowColor     = UIColor.black.cgColor
//            shadowOffset    = CGSize(width:0, height:0)
//            shadowOpacity   = 0.3
//            shadowRadius    = 10.0
            animateBirthRate()
        }
    }
    
    private func generateEmitterCells() -> [CAEmitterCell] {
        var cells:[CAEmitterCell] = [CAEmitterCell]()
        for index in 0..<16 {
            let cell               = CAEmitterCell()
            cell.birthRate         = 8
            cell.lifetime          = 14.0
            cell.lifetimeRange     = 0
            cell.velocity          = getRandomVelocity()
            cell.velocityRange     = 0
            cell.emissionLongitude = CGFloat(Double.pi)
            cell.emissionRange     = 0.5
            cell.spin              = 3.5
            cell.spinRange         = 0
            cell.color             = getNextColor(i: index)
            cell.contents          = getNextImage(i: index)
            cell.scaleRange        = 0.25
            cell.scale             = 0.1
            cells.append(cell)
        }
        return cells
    }
    
    private func getRandomVelocity() -> CGFloat {
        let velocities = [100,90,150,200]
        return CGFloat(velocities[Int(arc4random_uniform(4))])
    }
    
    private func getNextColor(i: Int) -> CGColor {
        let colors:[UIColor] = [.silicon, .barium, .lithium, .iron]
        return colors[i%4].cgColor
    }
    
    private func getNextImage(i:Int) -> CGImage {
        let images = [#imageLiteral(resourceName: "Emitter_Triangle"),#imageLiteral(resourceName: "Emitter_Spiral"),#imageLiteral(resourceName: "Emitter_Circle"),#imageLiteral(resourceName: "Emitter_Curl")]
        return images[i % 4].cgImage!
    }
    
    private func animateBirthRate() {
        let animation      = CAKeyframeAnimation()
        animation.keyPath  = "birthRate"
        animation.duration = 3.0
        animation.keyTimes = [0.0,0.2,1.0]
        animation.values   = [1.0,1.5,0.0]
        animation.delegate = self
        add(animation, forKey: "birthRate")
    }

}

extension CBConfettiLayer: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        birthRate = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.removeFromSuperlayer()
        }
    }
}


