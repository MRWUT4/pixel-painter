//
//  DODrawingView.m
//  pixel painter
//
//  Created by David Ochmann on 23.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/CoreAnimation.h>
#import "DODrawingView.h"
#import "UIImageView-ColorUtils.h"
#import "DOConstants.h"

@implementation DODrawingView


@synthesize color = _color;
@synthesize touchDown = _touchDown;
@synthesize touchPosition = _touchPosition;
@synthesize imageView = _imageView;
@synthesize scrollEnabled = _scrollEnabled;
@synthesize mode = _mode;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self)
    {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"rBackgroundTile.png"]];

        self.imageView = [[UIImageView alloc] initWithFrame:self.frame];
        [self addSubview:self.imageView];
    
        self.imageView.layer.magnificationFilter = kCAFilterNearest;
        self.layer.magnificationFilter = kCAFilterNearest;
        
//        self.imageView.contentMode = UIViewContentModeCenter;
    }
    
    return self;
}



/*
 * TOUCHES MOVED HANDLER
 */

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.touchDown = [[touches anyObject] locationInView:self];
    self.touchDown = CGPointMake((int) (self.touchDown.x / 1), (int) (self.touchDown.y / 1));
    
    [self modeAction:touches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self modeAction:touches];    
}

/* MODEACTION */

- (void)modeAction:(NSSet *)touches
{
    if(!self.scrollEnabled) 
    {
        self.touchPosition = [[touches anyObject] locationInView:self];
        self.touchPosition = CGPointMake((int) (self.touchPosition.x / 1), (int) (self.touchPosition.y / 1));
                
        if(self.touchPosition.x < self.bounds.size.width && self.touchPosition.y < self.bounds.size.height)
        {
            switch(self.mode) 
            {
                case STATE_DRAWING:
                    [self drawAtPosition];
                    break;
                case STATE_PICKING:
                    [self pickColorAtPosition];
                    break;
                case STATE_ERASING:
                    [self clearAtPosition];
                    break;
                case STATE_POSITION:
                    [self moveImageToPosition];
                    break;
            }
        }
    }
}

- (void)drawAtPosition
{    
    UIGraphicsBeginImageContext(self.imageView.frame.size);
    
    [self.imageView.image drawInRect:CGRectMake(0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height)];

    CGContextRef cgContext = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(cgContext, self.color.CGColor);
    CGContextFillRect(cgContext, CGRectMake(self.touchPosition.x, self.touchPosition.y, 1, 1));
    CGContextFlush(UIGraphicsGetCurrentContext());
    
    self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
}

- (void)clearAtPosition
{
    [self clearViewFrame:[NSValue valueWithCGRect:CGRectMake(self.touchPosition.x, self.touchPosition.y, 1, 1)]];
}

- (void)pickColorAtPosition
{    
    UIColor *pickedColor = [self.imageView getPixelColorAtLocation:self.touchPosition];
    
    if(CGColorGetAlpha(pickedColor.CGColor) != 0)
    {    
        self.color = pickedColor;
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_COLOR_DRAWINGVIEW_PICKED object:self];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_COLOR_ERASE_PICKED object:self];
    }
}

- (void)changeDrawingViewSize:(NSValue *)rectangle
{
    CGRect previousViewFrame = self.imageView.frame;
    CGRect rectangleViewFrame = rectangle.CGRectValue;
    CGRect viewFrame = rectangleViewFrame;
    
    self.imageView.center = CGPointMake(rectangleViewFrame.size.width * .5, rectangleViewFrame.size.height * .5);
    
    CGImageRef croppedImage = CGImageCreateWithImageInRect([self.imageView.image CGImage], rectangleViewFrame);
    
    self.imageView.bounds = rectangleViewFrame;
    self.bounds = rectangleViewFrame;
    
    if(previousViewFrame.size.width < rectangleViewFrame.size.width || previousViewFrame.size.height < rectangleViewFrame.size.height)
        viewFrame = previousViewFrame;
    
    
    UIGraphicsBeginImageContext(self.imageView.frame.size);
    
    CGContextRef cgContext = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(cgContext, 0, self.imageView.frame.size.height);
    CGContextScaleCTM(cgContext, 1.0, -1.0);
    
    CGContextDrawImage(cgContext, viewFrame, croppedImage);
    CGContextFlush(UIGraphicsGetCurrentContext());
    
    self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void)moveImageToPosition
{
    CGRect viewFrame = self.imageView.bounds;    
    CGRect positionFrame = viewFrame;
        
    positionFrame.origin.x = self.touchPosition.x - self.touchDown.x;
    positionFrame.origin.y = (self.touchPosition.y - self.touchDown.y) * -1;
    
    CGImageRef croppedImage = self.imageView.image.CGImage;  
    
    UIGraphicsBeginImageContext(self.imageView.frame.size);
    
    CGContextRef cgContext = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(cgContext, 0, self.imageView.frame.size.height);
    CGContextScaleCTM(cgContext, 1.0, -1.0);
    
    CGContextDrawImage(cgContext, positionFrame, croppedImage);
    CGContextFlush(UIGraphicsGetCurrentContext());
    
    self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.touchDown =  self.touchPosition;
}

/* CLEARVIEW */

- (void)clearCompleteView
{
    [self clearViewFrame:[NSValue valueWithCGRect:self.imageView.bounds]];
}

- (void)clearViewFrame:(NSValue *)rectangle
{
    CGRect imageViewFrame = self.imageView.frame;
    
    UIGraphicsBeginImageContext(imageViewFrame.size);
    
    [self.imageView.image drawInRect:imageViewFrame];
    
    CGContextRef cgContext = UIGraphicsGetCurrentContext();
    CGContextClearRect(cgContext, rectangle.CGRectValue);
    CGContextFlush(UIGraphicsGetCurrentContext());
    
    self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
}


@end
