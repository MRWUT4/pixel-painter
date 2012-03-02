//
//  DODrawingView.m
//  pixel painter
//
//  Created by David Ochmann on 23.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DODrawingView.h"
#import <QuartzCore/QuartzCore.h>

@implementation DODrawingView


@synthesize color = _color;
@synthesize scale = _scale;
@synthesize touchPosition = _touchPosition;
@synthesize imageView = _imageView;
@synthesize previousScale;

-(id)initWithFrame:(CGRect)r
{
    self = [super initWithFrame:r];
    
    if(self)
    {
        CATiledLayer *tempTiledLayer = (CATiledLayer*)self.layer;    
        tempTiledLayer.levelsOfDetail = 5;
        tempTiledLayer.levelsOfDetailBias = 2;
        self.opaque=YES;
    }
    
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

+(Class)layerClass

{
    return [CATiledLayer class];
}

-(unsigned int)scale
{
    _scale = _scale <= 0 ? 1 : _scale;
    return _scale;
}


/*
 * TOUCHES MOVED HANDLER
 */


- (void)setTransformWithoutScaling:(CGAffineTransform)newTransform;
{
    [super setTransform:newTransform];
}

- (void)setTransform:(CGAffineTransform)newValue;
{
    [super setTransform:CGAffineTransformScale(newValue, 1.0f / previousScale, 1.0f / previousScale)];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.touchPosition = [[touches anyObject] locationInView:self];
    
    
//    self.touchPosition = CGPointMake((int) (self.touchPosition.x / self.scale), 
//                                     (int) (self.touchPosition.y / self.scale));

    self.touchPosition = CGPointMake((int) (self.touchPosition.x), (int) (self.touchPosition.y));

    
    UIGraphicsBeginImageContext(self.frame.size);
    [self.imageView.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];

    CGContextRef cgContext = UIGraphicsGetCurrentContext();

//    CGContextSetAllowsAntialiasing(cgContext, NO);
//    CGContextSetShouldAntialias(cgContext, NO);
  
    CGContextScaleCTM(cgContext, self.scale, self.scale);

    CGContextSetFillColorWithColor(cgContext, self.color.CGColor); 
    CGContextFillRect(cgContext, CGRectMake(self.touchPosition.x, self.touchPosition.y, 1, 1));
    CGContextFlush(UIGraphicsGetCurrentContext());

    self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
}

/*
 * DRAWING IMPLEMENTATION
 */

-(void)drawRect:(CGRect)r

{
    
}

-(void)drawLayer:(CALayer*)layer inContext:(CGContextRef)context

{
    
    // The context is appropriately scaled and translated such that you can draw to this context
    
    // as if you were drawing to the entire layer and the correct content will be rendered.
    
    // We assume the current CTM will be a non-rotated uniformly scaled
    
    
    
    // affine transform, which implies that
    
    // a == d and b == c == 0
    
    // CGFloat scale = CGContextGetCTM(context).a;
    
    // While not used here, it may be useful in other situations.
    
    
    
    // The clip bounding box indicates the area of the context that
    
    // is being requested for rendering. While not used here
    
    // your app may require it to do scaling in other
    
    // situations.
    
    // CGRect rect = CGContextGetClipBoundingBox(context);
    
    
    
    // Set and draw the background color of the entire layer
    
    // The other option is to set the layer as opaque=NO;
    
    // eliminate the following two lines of code
    
    // and set the scroll view background color
    
    CGContextSetRGBFillColor(context, 1.0,1.0,1.0,1.0);
    CGContextFillRect(context,self.bounds);
    
    
    
    // draw a simple plus sign
    
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 1.0, 1.0);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context,35,255);
    CGContextAddLineToPoint(context,35,205);
    CGContextAddLineToPoint(context,135,205);
    CGContextAddLineToPoint(context,135,105);
    CGContextAddLineToPoint(context,185,105);
    CGContextAddLineToPoint(context,185,205);
    CGContextAddLineToPoint(context,285,205);
    CGContextAddLineToPoint(context,285,255);
    CGContextAddLineToPoint(context,185,255);
    CGContextAddLineToPoint(context,185,355);
    CGContextAddLineToPoint(context,135,355);
    CGContextAddLineToPoint(context,135,255);
    CGContextAddLineToPoint(context,35,255);
    CGContextClosePath(context);
    
    // Stroke the simple shape
    
    CGContextStrokePath(context);
}


@end
