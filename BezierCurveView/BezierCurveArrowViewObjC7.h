//
//  BezierCurveArrowViewObjC7.h
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

#import <UIKit/UIKit.h>

@interface BezierCurveArrowViewObjC7: UIView

typedef NS_ENUM(NSInteger, Corner) {
    CornerTl = 0,   // topLeft
    CornerTr,       // topRight
    CornerBl,       // bottomLeft
    CornerBr,       // bottomRight
    CornerCenter    // center
};


@property (nonatomic, assign) NSInteger startAnchor;
@property (nonatomic, assign) CGPoint startOffset;
@property (nonatomic, assign) CGPoint startControl;
@property (nonatomic, assign) NSInteger endAnchor;
@property (nonatomic, assign) CGPoint endOffset;
@property (nonatomic, assign) CGPoint endControl;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat arrowSize;
@property (nonatomic, assign) BOOL showHandles;


@end
