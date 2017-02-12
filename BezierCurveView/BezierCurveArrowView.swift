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

    public override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }

    public override func draw(_ rect: CGRect) {
        super.draw(rect)

        if let context = UIGraphicsGetCurrentContext() {
            context.beginPath()
            let start = anchorPoint(corner: startCornerAnchor, offset:startOffset)
            let end = anchorPoint(corner:endCornerAnchor, offset:endOffset)

            let startCp = CGPoint(x: start.x + startControl.x,
                                  y: start.y + startControl.y)
            let endCp = CGPoint(x: end.x + endControl.x,
                                y: end.y + endControl.y)
            context.move(to: start)
            context.addCurve(to: end, control1: startCp, control2: endCp)

            // Connect the arrowhead to the shaft
            let θ = radAngle(o:end, m:endCp)
            let π = CGFloat(M_PI)
            let spine = polarToCartesian(o: end, r: arrowSize/2, θ: θ + π)
            context.move(to: end)
            context.addLine(to: spine)

            context.setStrokeColor(tintColor?.cgColor ?? UIColor.black.cgColor)
            context.setLineWidth(lineWidth)
            context.strokePath()

            // Draw arrowhead point and ears
            let pointe = polarToCartesian(o: end, r: arrowSize, θ: θ + π)
            let headPath = CGMutablePath()
            headPath.move(to: pointe)

            let ear1 = polarToCartesian(o: pointe, r: arrowSize, θ: θ + 0.3)
            headPath.addLine(to: ear1)

            let neck = polarToCartesian(o: end, r: arrowSize/4, θ: θ + π)
            headPath.addLine(to: neck)

            let ear2 = polarToCartesian(o: pointe, r: arrowSize, θ: θ - 0.3)
            headPath.addLine( to: ear2)

            headPath.closeSubpath()
            context.setFillColor(tintColor?.cgColor ?? UIColor.black.cgColor)
            context.addPath(headPath)
            context.fillPath()

            // Control Points
            if showHandles {
                let cpRadius:CGFloat = 3
                context.beginPath()
                context.move(to: start)
                context.addLine(to: startCp)
                context.move(to: end)
                context.addLine(to: endCp)

                context.setStrokeColor(UIColor.red.cgColor)
                context.setLineWidth(2)
                context.strokePath()

                context.setFillColor(UIColor.red.cgColor)
                context.fillEllipse(in: CGRect(x: startCp.x-cpRadius,
                                               y: startCp.y-cpRadius,
                                               width: cpRadius+cpRadius,
                                               height: cpRadius+cpRadius))
                context.fillEllipse(in: CGRect(x: endCp.x-cpRadius,
                                               y: endCp.y-cpRadius,
                                               width: cpRadius+cpRadius,
                                               height: cpRadius+cpRadius))
            }
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

