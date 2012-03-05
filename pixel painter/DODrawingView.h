//
//  DODrawingView.h
//  pixel painter
//
//  Created by David Ochmann on 23.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DODrawingView : UIView

@property(strong, nonatomic) UIColor *color;

@property (nonatomic, assign) unsigned int scale;
@property (nonatomic, assign) CGPoint touchPosition;
@property (nonatomic, strong) UIImageView *imageView;

- (UIImage *)resizedImage:(CGSize)newSize transform:(CGAffineTransform)transform drawTransposed:(BOOL)transpose interpolationQuality:(CGInterpolationQuality)quality;

@end
