//
//  BezierCurveArrowViewObjC7.m
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

#import "BezierCurveArrowViewObjC7.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation BezierCurveArrowViewObjC7

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        self.startAnchor = CornerBl;
        self.startOffset = CGPointMake(20, -20);
        self.startControl = CGPointMake(20, 0);
        self.endAnchor = CornerTr;
        self.endOffset = CGPointMake(-20, 20);
        self.endControl = CGPointMake(0, 100);
        self.lineWidth = 2;
        self.arrowSize = 10;
        self.showHandles = false;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setNeedsDisplay];
}

- (void) drawRect: (CGRect) rect
{
    [super drawRect:rect];

    CGContextRef context = UIGraphicsGetCurrentContext();
    if(context ) {
        CGContextBeginPath(context);
        const CGPoint start = [self anchorPoint:self.startAnchor offset:self.startOffset];
        const CGPoint head = [self anchorPoint:self.endAnchor offset:self.endOffset];
        
        const CGPoint cp1 = CGPointMake(start.x + self.startControl.x, start.y + self.startControl.y);
        const CGPoint cp2 = CGPointMake(head.x + self.endControl.x, head.y + self.endControl.y);
        CGContextMoveToPoint(context, start.x, start.y);
        CGContextAddCurveToPoint(
                                 context,
                                 cp1.x, cp1.y,
                                 cp2.x, cp2.y,
                                 head.x, head.y);
        
        // Connect the arrowhead to the shaft
        const CGFloat slope = [self angle:head m:cp2];
        const CGPoint spine = [self polarToCartesian:head r:self.arrowSize/2 θ:slope + M_PI];
        CGContextMoveToPoint(context, head.x, head.y);
        CGContextAddLineToPoint(context, spine.x, spine.y);
        
        CGContextSetStrokeColorWithColor(context, self.tintColor.CGColor);
        CGContextSetLineWidth(context, self.lineWidth);
        CGContextStrokePath(context);
        
        // Draw arrowhead point and ears
        const CGPoint pointe = [self polarToCartesian:head r:self.arrowSize θ:slope + M_PI];
        const CGMutablePathRef headPath = CGPathCreateMutable();
        CGPathMoveToPoint(headPath, nil , pointe.x, pointe.y);
        
        const CGPoint ear1 = [self polarToCartesian:pointe r:self.arrowSize θ:slope + 0.3];
        CGPathAddLineToPoint(headPath, nil, ear1.x, ear1.y);
        
        const CGPoint neck = [self polarToCartesian:head r:self.arrowSize/4 θ:slope + M_PI];
        CGPathAddLineToPoint(headPath, nil, neck.x, neck.y);
        
        const CGPoint ear2 = [self polarToCartesian:pointe r:self.arrowSize θ:slope - 0.3];
        CGPathAddLineToPoint(headPath, nil, ear2.x, ear2.y);
        
        CGPathCloseSubpath(headPath);
        CGContextSetFillColorWithColor(context, self.tintColor.CGColor);
        CGContextAddPath(context, headPath);
        CGContextFillPath(context);
        CGPathRelease(headPath);
        
        // Control Points
        if(self.showHandles) {
            const CGFloat cpRadius = 3;
            CGContextBeginPath(context);
            CGContextMoveToPoint(context, start.x, start.y);
            CGContextAddLineToPoint(context, cp1.x, cp1.y);
            CGContextMoveToPoint(context, head.x, head.y);
            CGContextAddLineToPoint(context, cp2.x, cp2.y);
            
            CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
            CGContextSetLineWidth(context, 2);
            CGContextStrokePath(context);
            
            CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
            CGContextFillEllipseInRect(context,
                                       CGRectMake(cp1.x-cpRadius, cp1.y-cpRadius, cpRadius+cpRadius, cpRadius+cpRadius));
            CGContextFillEllipseInRect(context,
                                       CGRectMake(cp2.x-cpRadius, cp2.y-cpRadius, cpRadius+cpRadius, cpRadius+cpRadius));
        }
    }
}

- (CGPoint)polarToCartesian:(CGPoint)center r:(CGFloat)r θ:(CGFloat)θ {
    const CGPoint m = CGPointMake(r * (CGFloat)cos(θ), r * (CGFloat)sin(θ));
    return CGPointMake(center.x + m.x, center.y + m.y);
}

- (CGFloat)angle:(CGPoint)center m:(CGPoint)m  {
    const CGVector vector = CGVectorMake(m.x - center.x, m.y - center.y);
    return atan2(vector.dy, vector.dx); // in radians
}

// Point are expressed in Corner + Offset
- (CGPoint)anchorPoint:(Corner)corner offset:(CGPoint)offset {
    CGPoint point = CGPointZero;
    switch(corner) {
        case CornerTl:
            // do nothing
            break;
        case CornerTr:
            point = CGPointMake(self.bounds.size.width, 0);
            break;
        case CornerBl:
            point = CGPointMake(0, self.bounds.size.height);
            break;
        case CornerBr:
            point = CGPointMake(self.bounds.size.width, self.bounds.size.height);
            break;
        case CornerCenter:
            point = self.center;
            break;
        default:
            NSAssert(NO, @"Unknown corner %ld",(long)corner);
            // do nothing
    }
    return CGPointMake(point.x + offset.x, point.y + offset.y);
}

@end
