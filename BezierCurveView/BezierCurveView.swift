//    @file:    BezierCurveView.swift
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

@IBDesignable
public class BezierCurveView: UIView {

    public enum Shape:NSInteger {
        case none = 0
        case arrowHead
        case circle
        case disc
    }

    @IBInspectable public var lineWidth:CGFloat = 1.5

    // MARK: Calculated properties

    var curveColor:UIColor {
        get {
            return tintColor ?? UIColor.black
        }
    }

    var handleColor: UIColor {
        get{
            return UIColor.red
        }
    }

    // MARK: BezierCurveView

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentMode = .redraw
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentMode = .redraw
    }

    public override func draw(_ rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext() {
            var handles:[BezierHandleProtocol] = []
            for view in subviews {
                if let bezierCurveHandleView = view as? BezierHandleProtocol {
                    handles.append(bezierCurveHandleView)
                }
            }

            if 2 == handles.count,
                let handle1 = handles.first,
                let handle2 = handles.last {

                // controls are expressed in relative terms against their anchors
                let cp1 = CGPoint(x: handle1.anchor.x + handle1.controlPoint.x,
                                  y: handle1.anchor.y + handle1.controlPoint.y)
                let cp2 = CGPoint(x: handle2.anchor.x + handle2.controlPoint.x,
                                  y: handle2.anchor.y + handle2.controlPoint.y)

                // Terminal shapes
                let anchor1 = drawShape(shape: handle1.terminalShape,
                                        size: handle1.terminalSize,
                                        o: handle1.anchor,
                                        m: cp1,
                                        inContext: context)
                let anchor2 = drawShape(shape: handle2.terminalShape,
                                        size: handle2.terminalSize,
                                        o: handle2.anchor,
                                        m: cp2,
                                        inContext: context)

                // Curve
                context.setStrokeColor(curveColor.cgColor)
                context.setLineWidth(lineWidth)

                context.beginPath()
                context.move(to: anchor1)
                context.addCurve(to: anchor2,
                                 control1: CGPoint(x: anchor1.x + handle1.controlPoint.x,
                                                   y: anchor1.y + handle1.controlPoint.y),
                                 control2: CGPoint(x: anchor2.x + handle2.controlPoint.x,
                                                   y: anchor2.y + handle2.controlPoint.y)) // Cubic curve
                context.strokePath()

                // Handles and control points
                drawHandle(handle: handle1, inContext: context)
                drawHandle(handle: handle2, inContext: context)
            }
        }
    }

    func drawHandle(handle:BezierHandleProtocol, inContext context:CGContext) {
        #if TARGET_INTERFACE_BUILDER
            // Control Points
            let cpRadius:CGFloat = 2

            let cp = CGPoint(x: handle.anchor.x + handle.controlPoint.x,
                              y: handle.anchor.y + handle.controlPoint.y)

            context.beginPath()
            context.move(to: handle.anchor)
            context.addLine(to: cp)
            context.setStrokeColor(handleColor.cgColor)
            context.setLineWidth(1)
            context.strokePath()

            context.setFillColor(handleColor.cgColor)
            context.fillEllipse(in: CGRect(x: cp.x-cpRadius,
                                           y: cp.y-cpRadius,
                                           width: cpRadius+cpRadius,
                                           height: cpRadius+cpRadius))
        #endif // TARGET_INTERFACE_BUILDER
    }

    // Return the location of the new anchor point for the curve
    func drawShape(shape:BezierCurveView.Shape,
                   size:CGFloat,
                   o:CGPoint,
                   m:CGPoint,
                   inContext context:CGContext) -> CGPoint {
        switch shape {

        case .arrowHead:
            // Connect the arrowhead to the shaft
            let θ = radAngle(o:o, m:m)
            let π = CGFloat(M_PI)
            let origin = polarToCartesian(o: o, r: -size, θ: θ + π)
            let shaft = polarToCartesian(o: origin, r: size/2, θ: θ + π)
            context.move(to: origin)
            context.addLine(to: shaft)

            context.setStrokeColor(curveColor.cgColor)
            context.setLineWidth(lineWidth)
            context.strokePath()

            // Draw arrowhead point and ears (retraction)
            let headPath = CGMutablePath()
            headPath.move(to: o)

            let ear1 = polarToCartesian(o: o, r: size, θ: θ + 0.3)
            headPath.addLine(to: ear1)

            let neck = polarToCartesian(o: origin, r: size/4, θ: θ + π)
            headPath.addLine(to: neck)

            let ear2 = polarToCartesian(o: o, r: size, θ: θ - 0.3)
            headPath.addLine( to: ear2)

            headPath.closeSubpath()
            context.setFillColor(curveColor.cgColor)
            context.addPath(headPath)
            context.fillPath()

            return origin

        case .circle:
            fallthrough
        case .disc:
            let θ = radAngle(o:o, m:m)
            let π = CGFloat(M_PI)
            let origin = polarToCartesian(o: o, r: -size, θ: θ + π)
            context.addEllipse(in: CGRect(x: o.x - size,
                                          y: o.y - size,
                                          width: size + size,
                                          height: size + size))
            if .circle == shape {
                context.setStrokeColor(curveColor.cgColor)
                context.setLineWidth(lineWidth)
                context.strokePath()
            } else { // .disc
                context.setFillColor(curveColor.cgColor)
                context.fillPath()
            }
            return origin

        case .none:
            return o
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
}

