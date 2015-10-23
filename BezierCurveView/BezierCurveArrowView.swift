//
//  BezierCurveArrowView.swift
//  BezierCurveView
//
//  Copyright (c) 2015 Xavier Schott
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import UIKit

@IBDesignable
class BezierCurveArrowView: UIView {

    enum Corner:Int {
        case tl = 0, tr, bl, br, center //topLeft, topRight, bottomLeft, bottomRight, center
    }
    
    @IBInspectable var startAnchor:Int = Corner.bl.rawValue
    @IBInspectable var startOffset:CGPoint = CGPointMake(20, -20)
    @IBInspectable var startControl:CGPoint = CGPointMake(20, 0)
    @IBInspectable var endAnchor:Int = Corner.tr.rawValue
    @IBInspectable var endOffset:CGPoint = CGPointMake(-20, 20)
    @IBInspectable var endControl:CGPoint = CGPointMake(0, 100)
    @IBInspectable var lineWidth:CGFloat = 2
    @IBInspectable var arrowSize:CGFloat = 10
    @IBInspectable var showHandles:Bool = false

    override func layoutSubviews() {
        super.layoutSubviews()
        self.setNeedsDisplay()
    }

    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        if let context:CGContextRef = UIGraphicsGetCurrentContext() {
            CGContextBeginPath(context)
            let start = self.anchorPoint(Corner(rawValue: self.startAnchor) ?? .bl, offset: self.startOffset)
            let head = self.anchorPoint(Corner(rawValue: self.endAnchor) ?? .tr, offset: self.endOffset)
    
            let cp1 = CGPointMake(start.x + self.startControl.x, start.y + self.startControl.y)
            let cp2 = CGPointMake(head.x + self.endControl.x, head.y + self.endControl.y)
            CGContextMoveToPoint(context, start.x, start.y)
            CGContextAddCurveToPoint(
                context,
                cp1.x, cp1.y,
                cp2.x, cp2.y,
                head.x, head.y)
            

            // Connect the arrowhead to the shaft
            let slope = self.angle(head, m: cp2)
            let spine = self.polarToCartesian(head, r: self.arrowSize/2, θ: slope + CGFloat(M_PI))
            CGContextMoveToPoint(context, head.x, head.y)
            CGContextAddLineToPoint(context, spine.x, spine.y)

            CGContextSetStrokeColorWithColor(context, self.tintColor.CGColor)
            CGContextSetLineWidth(context, self.lineWidth)
            CGContextStrokePath(context)

            // Draw arrowhead point and ears
            let pointe = self.polarToCartesian(head, r: self.arrowSize, θ: slope + CGFloat(M_PI))
            let headPath = CGPathCreateMutable()
            CGPathMoveToPoint(headPath, nil , pointe.x, pointe.y)
            
            let ear1 = self.polarToCartesian(pointe, r: self.arrowSize, θ: slope + 0.3)
            CGPathAddLineToPoint(headPath, nil, ear1.x, ear1.y)

            let neck = self.polarToCartesian(head, r: self.arrowSize/4, θ: slope + CGFloat(M_PI))
            CGPathAddLineToPoint(headPath, nil, neck.x, neck.y)

            let ear2 = self.polarToCartesian(pointe, r: self.arrowSize, θ: slope - 0.3)
            CGPathAddLineToPoint(headPath, nil, ear2.x, ear2.y)

            CGPathCloseSubpath(headPath)
            CGContextSetFillColorWithColor(context, self.tintColor.CGColor)
            CGContextAddPath(context, headPath)
            CGContextFillPath(context)
            
            // Control Points
            if showHandles {
                let cpRadius:CGFloat = 3
                CGContextBeginPath(context)
                CGContextMoveToPoint(context, start.x, start.y)
                CGContextAddLineToPoint(context, cp1.x, cp1.y)
                CGContextMoveToPoint(context, head.x, head.y)
                CGContextAddLineToPoint(context, cp2.x, cp2.y)
                
                CGContextSetStrokeColorWithColor(context, UIColor.redColor().CGColor)
                CGContextSetLineWidth(context, 2)
                CGContextStrokePath(context)
                
                CGContextSetFillColorWithColor(context, UIColor.redColor().CGColor)
                CGContextFillEllipseInRect(context,
                    CGRectMake(cp1.x-cpRadius, cp1.y-cpRadius, cpRadius+cpRadius, cpRadius+cpRadius))
                CGContextFillEllipseInRect(context,
                    CGRectMake(cp2.x-cpRadius, cp2.y-cpRadius, cpRadius+cpRadius, cpRadius+cpRadius))
            }
        }
    }
    
    private func polarToCartesian(center: CGPoint, r: CGFloat, θ: CGFloat) -> CGPoint {
        let m = CGPointMake(r * CGFloat(cos(θ)), r * CGFloat(sin(θ)))
        return CGPointMake(center.x + m.x, center.y + m.y)
    }
    
    private func angle(center: CGPoint, m: CGPoint) -> CGFloat {
        let vector = CGVector(dx: m.x - center.x, dy: m.y - center.y)
        return atan2(vector.dy, vector.dx) // in radians
    }
    
    // Point are expressed in Corner + Offset
    private func anchorPoint(corner: Corner, offset: CGPoint) -> CGPoint {
        var point:CGPoint
        switch corner {
        case .tl:
            point = CGPointZero
            break
        case .tr:
            point = CGPointMake(self.bounds.width, 0)
            break
        case .bl:
            point = CGPointMake(0, self.bounds.height)
            break
        case .br:
            point = CGPointMake(self.bounds.width, self.bounds.height)
            break
        case .center:
            point = self.center
            break
        }
        return CGPointMake(point.x + offset.x, point.y + offset.y)
    }
}
