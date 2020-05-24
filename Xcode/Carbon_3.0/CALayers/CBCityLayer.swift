//
//  CBCityLayer.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 12/24/18.
//  Copyright © 2018 Matt Marks. All rights reserved.
//

import UIKit

class CBCityLayer: CALayer {
    
    private var color: CGColor!
    
    private var alpha: Float!
    
    private var averageBuildingWidth: CGFloat!
    
    enum BuildingTop: CaseIterable {
        case dome
        case block
        case triangle
        case wedge
        case domeSpire
        case triangleSpire
        case none
    }
    
    struct BuildingParams {
        var top: BuildingTop // One of 8 types of building tops
        var xPos: CGFloat    // The leftmost side of the building
        var yPos: CGFloat    // The top of the body of the bulding
        var height: CGFloat  // The height of the building without the top
        var width: CGFloat   // The width of the building
    }
    
    override var frame: CGRect {
        didSet {
            populateLayerWithBuildings()
            opacity = alpha
        }
    }
    
    // MARK: - Initialization
    convenience init(color: CGColor, alpha: Float, averageBuildingWidth: CGFloat) {
        self.init()
        self.color = color
        self.alpha = alpha
        self.averageBuildingWidth = averageBuildingWidth
    }
    
    // MARK: - Public Members
    public func setColor(_ newColor: UIColor) {
        for sublayer in sublayers! {
            (sublayer as! CAShapeLayer).fillColor = newColor.cgColor
            (sublayer as! CAShapeLayer).strokeColor = newColor.cgColor
        }
    }
    
    // MARK: - Building Construction
    private func populateLayerWithBuildings() {
        var xPos: CGFloat = 0
        
        let minWidth  = averageBuildingWidth - 10
        let maxWidth  = averageBuildingWidth + 10
        let minHeight = bounds.height/6
        let maxHeight = bounds.height/1.4
        
        for _ in 0...Int(bounds.width / minWidth)*3 {
            let top = BuildingTop.allCases.randomElement()!
            let width = CGFloat.random(in: minWidth...maxWidth)
            let height = CGFloat.random(in: minHeight...maxHeight)
            let params = BuildingParams(top: top,
                                        xPos: xPos,
                                        yPos: bounds.height - height,
                                        height: height,
                                        width: width)
            let building = createBuilding(params: params)
            
            addSublayer(building)
            
            building.fillColor = color
            building.lineWidth = 1
            building.strokeColor = color
            xPos += width
        }
        
    }
    
    private func createBuilding(params: BuildingParams) -> CAShapeLayer {
        let shape      = CAShapeLayer()
        let path       = UIBezierPath()
        let bodyOrigin = CGPoint(x: params.xPos, y: params.yPos)
        let bodySize   = CGSize(width: params.width, height: params.height)
        let bodyRect   = CGRect(origin: bodyOrigin, size: bodySize)
        
        path.append(UIBezierPath(rect: bodyRect))
        
        switch params.top {
        case .dome:
            path.append(createDome(forParams: params))
        case .block:
            createBlocks(forParams: params).forEach({path.append($0)})
        case .triangle:
            path.append(createTriange(forParams: params))
        case .wedge:
            path.append(createWedge(forParams: params))
        case .domeSpire:
            path.append(createDome(forParams: params))
            path.append(createSpire(forParams: params))
        case .triangleSpire:
            path.append(createTriange(forParams: params))
            path.append(createSpire(forParams: params))
        default: ()
        }

        
        path.usesEvenOddFillRule = true
        shape.path = path.cgPath
        
        return shape
    }
    
    // MARK: - Building Tops
    private func createDome(forParams params: BuildingParams) -> UIBezierPath {
        let center = CGPoint(x: params.xPos + params.width/2, y: params.yPos)
        let radius = params.width/2 - params.width/8
        return UIBezierPath(arcCenter: center,
                            radius: radius,
                            startAngle: 0,
                            endAngle: .pi,
                            clockwise: false)
    }
    
    private func createBlocks(forParams params: BuildingParams) -> [UIBezierPath] {
        var paths = [UIBezierPath]()
        for i in 1...2 {
            let height = params.height / CGFloat(15)
            let width  = params.width - (params.width/2 * 0.7 * CGFloat(i))
            let x      = params.xPos + (params.width - width)/2
            let y      = params.yPos - (height * CGFloat(i))
            let origin = CGPoint(x: x, y: y)
            let size   = CGSize(width: width, height: height)
            let rect   = CGRect(origin: origin, size: size)
            paths.append(UIBezierPath(rect: rect))
        }
        return paths
    }
    
    private func createTriange(forParams params: BuildingParams) -> UIBezierPath {
        let path       = UIBezierPath()
        let leftPoint  = CGPoint(x: params.xPos, y: params.yPos)
        let rightPoint = CGPoint(x: params.xPos + params.width, y: params.yPos)
        let topPoint   = CGPoint(x: params.xPos + params.width/2, y: params.yPos - params.width/2)
        path.move(to: leftPoint)
        path.addLine(to: rightPoint)
        path.addLine(to: topPoint)
        path.close()
        return path
    }
    
    private func createWedge(forParams params: BuildingParams) -> UIBezierPath {
        let path       = UIBezierPath()
        let leftPeak   = params.xPos + 2
        let rightPeak  = params.xPos + params.width - 2
        let peak       = Bool.random() ? rightPeak : leftPeak
        let leftPoint  = CGPoint(x: params.xPos + 2, y: params.yPos)
        let rightPoint = CGPoint(x: params.xPos + params.width - 2, y: params.yPos)
        let topPoint   = CGPoint(x: peak, y: params.yPos - params.width/2)
        path.move(to: leftPoint)
        path.addLine(to: rightPoint)
        path.addLine(to: topPoint)
        path.close()
        return path
    }
    
    private func createSpire(forParams params: BuildingParams) -> UIBezierPath {
        let path       = UIBezierPath()
        let center     = params.xPos + params.width/2
        let leftPoint  = CGPoint(x: center - params.width/15, y: params.yPos)
        let rightPoint = CGPoint(x: center + params.width/15, y: params.yPos)
        let topPoint   = CGPoint(x: center, y: params.yPos - params.width/1.5)
        path.move(to: leftPoint)
        path.addLine(to: rightPoint)
        path.addLine(to: topPoint)
        path.close()
        return path
    }
    
    // MARK: - Animations
    public func animateEntrance() {
        for sublayer in sublayers! {
            let grow = CABasicAnimation()
            let timingFunc = CAMediaTimingFunctionName.easeOut
            grow.keyPath = "transform.translation.y"
            grow.fromValue = bounds.height
            grow.toValue = 0.0
            grow.timingFunction = CAMediaTimingFunction(name: timingFunc)
            grow.duration = Double.random(in: 3...11)/10
            sublayer.add(grow, forKey: "entrance")
            sublayer.transform = CATransform3DMakeTranslation(0, 0, 0)
        }
    }
    
}
