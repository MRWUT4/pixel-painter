//
//  DODrawingView.m
//  pixel painter
//
//  Created by David Ochmann on 23.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DODrawingView.h"

@implementation DODrawingView


@synthesize color = _color;
@synthesize scale = _scale;
@synthesize touchPosition = _touchPosition;
@synthesize imageView = _imageView;
@synthesize originalFrame = _originalFrame;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self)
    {
        self.imageView = [[UIImageView alloc] initWithFrame:self.frame];
        [self addSubview:self.imageView];
    
        self.originalFrame = self.imageView.frame;
        
        NSLog(@"of %f", self.originalFrame.size.width);
    }
    
    return self;
}

/*
 * GETTER / SETTER 
 */

- (void)setScale:(unsigned int)scale
{
    _scale = scale;
    
    NSLog(@"scale %i", scale);
    
//    self.originalFrame = CGRectMake(0, 0, self.originalFrame.size.width * _scale, self.originalFrame.size.height * _scale);
//    self.imageView.bounds = newFrame;
    
    UIGraphicsGetImageFromCurrentImageContext();
    CGContextRef cgContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(cgContext, self.scale, self.scale);
    UIGraphicsPushContext(cgContext);
}

-(unsigned int)scale
{
    _scale = _scale <= 0 ? 1 : _scale;
    return _scale;
}

/*
 * TOUCHES MOVED HANDLER
 */

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.touchPosition = [[touches anyObject] locationInView:self];
        
    self.touchPosition = CGPointMake((int) (self.touchPosition.x / self.scale), 
                                     (int) (self.touchPosition.y / self.scale));
    
    UIGraphicsBeginImageContext(self.frame.size);
//    UIGraphicsBeginImageContextWithOptions(self.frame.size, YES, self.scale);
    
    [self.imageView.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];

    CGContextRef cgContext = UIGraphicsGetCurrentContext();
  
    CGContextScaleCTM(cgContext, self.scale, self.scale);

    CGContextSetFillColorWithColor(cgContext, self.color.CGColor); 
    CGContextFillRect(cgContext, CGRectMake(self.touchPosition.x, self.touchPosition.y, 1, 1));
    CGContextFlush(UIGraphicsGetCurrentContext());

    self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
}


@end
