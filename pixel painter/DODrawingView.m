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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {}
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self)
    {
        self.imageView = [[UIImageView alloc] initWithFrame:self.frame];
        [self addSubview:self.imageView];
    }
    
    return self;
}

/*
 * GETTER / SETTER
 */

/*
-(UIImage *)image
{
    id subview = [[self subviews] objectAtIndex:0];
    UIImageView *imageView = [subview isKindOfClass:[UIImageView class]] ? subview : nil;
    
    NSLog(@"imageView %@", imageView.image);
    
    return imageView.image;
}
*/
 
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
    
    
//    self.touchPosition = CGPointMake((int) (self.touchPosition.x / self.scale), 
//                                     (int) (self.touchPosition.y / self.scale));

    self.touchPosition = CGPointMake((int) (self.touchPosition.x), (int) (self.touchPosition.y));

    
    UIGraphicsBeginImageContext(self.frame.size);
    [self.imageView.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];

    CGContextRef cgContext = UIGraphicsGetCurrentContext();

    CGContextSetAllowsAntialiasing(cgContext, NO);
    CGContextSetShouldAntialias(cgContext, NO);
    
    CGContextScaleCTM(cgContext, self.scale, self.scale);

    CGContextSetFillColorWithColor(cgContext, self.color.CGColor); 
    CGContextFillRect(cgContext, CGRectMake(self.touchPosition.x, self.touchPosition.y, 1, 1));
    CGContextFlush(UIGraphicsGetCurrentContext());

    self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
}


@end
