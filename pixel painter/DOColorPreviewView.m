//
//  DOColorPreviewView.m
//  pixel painter
//
//  Created by David Ochmann on 22.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DOColorPreviewView.h"

@implementation DOColorPreviewView

@synthesize color = _color;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) 
    {
        // Initialization code
    }
    return self;
}

- (void)setColor:(UIColor *)color
{
    _color = color;
    
    UIGraphicsBeginImageContext(self.frame.size);
    [self.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];

    CGContextRef cgContext = UIGraphicsGetCurrentContext();
    
//    CGContextScaleCTM(cgContext, scale, scale);
    CGContextScaleCTM(cgContext, 1, 1);
    
    CGContextSetFillColorWithColor(cgContext, color.CGColor); 
    CGContextFillRect(cgContext, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
    CGContextFlush(UIGraphicsGetCurrentContext());
    
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
