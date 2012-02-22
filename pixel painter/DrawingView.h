//
//  DrawingView.h
//  pixel perfect
//
//  Created by David Ochmann on 30.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "Model.h"

CGPoint touchPosition;
CGContextRef cgContext;
CGFloat scale;

@interface DrawingView : UIView

@property (strong, nonatomic) UIImageView *drawImage;
@property (strong, nonatomic) UIColor *color;

- (void)setScale:(CGFloat)pScale;
- (CGFloat)scale;

@end
