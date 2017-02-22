//    @file:    BezierCurveArrowView.swift
//    @project: BezierCurveView
//
//    @author:  Xavier Schott
//              mailto://xschott@gmail.com
//              http://thegothicparty.com
//              tel://+18089383634
//
//    @license: http://opensource.org/licenses/MIT
//    Copyright (c) 2017, Xavier Schott
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in
//    all copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//    THE SOFTWARE.

import UIKit

public enum Corner:NSInteger {
    case topLeft = 0
    case topRight
    case bottomLeft
    case bottomRight
    case center
}

public enum Shape:NSInteger {
    case none = 0
    case arrowHead
    // case disc
    // case circle
}

@IBDesignable
public class BezierCurveArrowView: UIView {
    @IBInspectable public var startAnchor:NSInteger = Corner.bottomLeft.rawValue
    @IBInspectable public var startOffset:CGPoint = CGPoint(x: 20, y: -20)
    @IBInspectable public var startControl:CGPoint = CGPoint(x: 20, y: 0)
    @IBInspectable public var endAnchor:NSInteger = Corner.topRight.rawValue
    @IBInspectable public var endOffset:CGPoint = CGPoint(x: -20, y: 20)
    @IBInspectable public var endControl:CGPoint = CGPoint(x: 0, y: 100)
    @IBInspectable public var lineWidth:CGFloat = 2
    @IBInspectable public var arrowSize:CGFloat = 10
    @IBInspectable public var showHandles:Bool = false
    @IBInspectable public var endStyle:NSInteger = Shape.arrowHead.rawValue

    // MARK: Adapters

    public var startCornerAnchor:Corner {
        get {
            return Corner(rawValue: startAnchor) ?? .bottomLeft
        }
        set {
            startAnchor = newValue.rawValue
        }
    }

    public var endCornerAnchor:Corner {
        get {
            return Corner(rawValue: endAnchor) ?? .topRight
        }
        set {
            endAnchor = newValue.rawValue
        }
    }

    public var endShapeStyle:Shape {
        get {
            return Shape(rawValue: endStyle) ?? .arrowHead
        }
        set {
            endStyle = newValue.rawValue
        }
    }

    // MARK: BezierCurveView

    public override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }

    public override func draw(_ rect: CGRect) {
        super.draw(rect)

        if let context = UIGraphicsGetCurrentContext() {
            context.beginPath()
            let insertAnchor = anchorPoint(corner: startCornerAnchor, offset:startOffset)
            let endAnchor = anchorPoint(corner:endCornerAnchor, offset:endOffset)

            // startControl & endControl are expressed in relative terms against their anchors
            let controlPoint1 = CGPoint(x: insertAnchor.x + startControl.x,
                                        y: insertAnchor.y + startControl.y)
            let controlPoint2 = CGPoint(x: endAnchor.x + endControl.x,
                                        y: endAnchor.y + endControl.y)

            // End shapes
            // These cause the curve endpoints to be offset to new locations
            let adjInsert = drawShape(shape: Shape.none,
                                      o: insertAnchor,
                                      m: controlPoint1,
                                      inContext: context)
            let adjEnd = drawShape(shape: endShapeStyle,
                                   o: endAnchor,
                                   m: controlPoint2,
                                   inContext: context)

            // Curve
            let color = tintColor?.cgColor ?? UIColor.black.cgColor
            context.setStrokeColor(color)
            context.setLineWidth(lineWidth)

            let adjPoint1 = CGPoint(x: adjInsert.x + startControl.x,
                                    y: adjInsert.y + startControl.y)
            let adjPoint2 = CGPoint(x: adjEnd.x + endControl.x,
                                    y: adjEnd.y + endControl.y)


            context.move(to: adjInsert)
            context.addCurve(to: adjEnd, control1: adjPoint1, control2: adjPoint2) // Cubic curve
            context.strokePath()

            // Control Points
            if showHandles {
                let color = UIColor.red.cgColor
                let cpRadius:CGFloat = 2

                context.beginPath()
                context.move(to: insertAnchor)
                context.addLine(to: controlPoint1)
                context.move(to: endAnchor)
                context.addLine(to: controlPoint2)

                context.setStrokeColor(color)
                context.setLineWidth(1)
                context.strokePath()

                context.setFillColor(color)
                context.fillEllipse(in: CGRect(x: controlPoint1.x-cpRadius,
                                               y: controlPoint1.y-cpRadius,
                                               width: cpRadius+cpRadius,
                                               height: cpRadius+cpRadius))
                context.fillEllipse(in: CGRect(x: controlPoint2.x-cpRadius,
                                               y: controlPoint2.y-cpRadius,
                                               width: cpRadius+cpRadius,
                                               height: cpRadius+cpRadius))
            }
        }
    }

    // Return the location of the new anchor point for the curve
    func drawShape(shape:Shape, o:CGPoint, m:CGPoint, inContext context:CGContext) -> CGPoint {
        switch shape {
        case .none:
            return o
            
        case .arrowHead:
            let color = tintColor?.cgColor ?? UIColor.black.cgColor

            // Connect the arrowhead to the shaft
            let θ = radAngle(o:o, m:m)
            let π = CGFloat(M_PI)
            let origin = polarToCartesian(o: o, r: -arrowSize, θ: θ + π)
            let shaft = polarToCartesian(o: origin, r: arrowSize/2, θ: θ + π)
            context.move(to: origin)
            context.addLine(to: shaft)

            context.setStrokeColor(color)
            context.setLineWidth(lineWidth)
            context.strokePath()

            // Draw arrowhead point and ears (retraction)
            let headPath = CGMutablePath()
            headPath.move(to: o)

            let ear1 = polarToCartesian(o: o, r: arrowSize, θ: θ + 0.3)
            headPath.addLine(to: ear1)

            let neck = polarToCartesian(o: origin, r: arrowSize/4, θ: θ + π)
            headPath.addLine(to: neck)

            let ear2 = polarToCartesian(o: o, r: arrowSize, θ: θ - 0.3)
            headPath.addLine( to: ear2)

            headPath.closeSubpath()
            context.setFillColor(color)
            context.addPath(headPath)
            context.fillPath()

            return origin
        }
    }

    func polarToCartesian(o:CGPoint, r:CGFloat, θ:CGFloat) -> CGPoint {
        let m = CGPoint(x: r * CGFloat(cos(θ)),
                        y: r * CGFloat(sin(θ)))
        return CGPoint(x: o.x + m.x,
                       y: o.y + m.y)
    }

    func radAngle(o:CGPoint, m:CGPoint) -> CGFloat {
        let vector = CGVector(dx: m.x - o.x,
                              dy: m.y - o.y)
        return atan2(vector.dy, vector.dx) // in radians
    }

    // Point are expressed in Corner + Offset
    func anchorPoint(corner: Corner, offset: CGPoint) -> CGPoint {
        var point = CGPoint.zero
        switch corner {
        case .topRight:
            point = CGPoint(x: bounds.size.width,
                            y:0)

        case .bottomLeft:
            point = CGPoint(x: 0,
                            y: bounds.size.height)

        case .bottomRight:
            point = CGPoint(x: bounds.size.width,
                            y: bounds.size.height)

        case .center:
            point = center

        case .topLeft: // do nothing
            break
        }
        return CGPoint(x: point.x + offset.x,
                       y: point.y + offset.y)
    }
}

