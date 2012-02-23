//
//  UIImageView+DOColorUtils.h
//  pixel perfect
//
//  Created by David Ochmann on 17.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIView (ColorUtils)

- (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef)inImage;
- (UIColor*) getPixelColorAtLocation:(CGPoint)point;

@end
