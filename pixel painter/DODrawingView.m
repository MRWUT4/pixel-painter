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
@synthesize fillPickColor = _fillPickColor;
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
        
        self.clipsToBounds = YES;
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
        
    switch (self.mode) 
    {
        case STATE_FILLING:
            self.fillPickColor = [self.imageView getPixelColorAtLocation:self.touchDown];
            
            [self fillImageAtPositionLeft:self.touchDown];
            [self fillImageAtPositionRight:self.touchDown];
            break;
            
        default:
            [self modeAction:touches];
            break;
    }
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
                    [self drawAtPosition:self.touchPosition];
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

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{    
    switch(self.mode) 
    {
        case STATE_POSITION:
            [self cropCurrentDisposition];
            break;
    }
}

- (void)cropCurrentDisposition
{
    CGRect movedFrame = self.imageView.frame;
    self.imageView.frame = CGRectMake(0, 0, movedFrame.size.width, movedFrame.size.height);
    
    movedFrame.origin = CGPointMake(movedFrame.origin.x, movedFrame.origin.y * -1);
    
    CGImageRef croppedImage = self.imageView.image.CGImage;  
    
    UIGraphicsBeginImageContext(self.imageView.frame.size);
    
    CGContextRef cgContext = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(cgContext, 0, self.imageView.frame.size.height);
    CGContextScaleCTM(cgContext, 1.0, -1.0);
    
    CGContextDrawImage(cgContext, movedFrame, croppedImage);
    CGContextFlush(UIGraphicsGetCurrentContext());
    
    self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void)drawAtPosition:(CGPoint)position
{    
    UIGraphicsBeginImageContext(self.imageView.frame.size);
    
    NSLog(@"dap %f", CGColorGetAlpha(self.color.CGColor));
    
    [self.imageView.image drawInRect:CGRectMake(0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height)];

    CGContextRef cgContext = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(cgContext, self.color.CGColor);
    CGContextFillRect(cgContext, CGRectMake(position.x, position.y, 1, 1));
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
    NSLog(@"pickColorAtPosition %f", CGColorGetAlpha(pickedColor.CGColor));    
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
    {
        viewFrame = previousViewFrame;
        viewFrame.origin.y = rectangleViewFrame.size.height - previousViewFrame.size.height;
    }
    
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
    positionFrame.origin.y = self.touchPosition.y - self.touchDown.y;

    self.imageView.frame = positionFrame;
}

- (void)fillImageAtPositionLeft:(CGPoint)position
{
    CGPoint drawPosition = position;
    
    //NSLog(@"%i", [[self getPixelColorAtLocation:drawPosition] isEqual:self.fillPickColor]);
    
    UIColor *colorAtPosition = [self getPixelColorAtLocation:drawPosition];
        
    if([[self getPixelColorAtLocation:drawPosition] isEqual:self.fillPickColor] && ![self.color isEqual:colorAtPosition])
    {   
        [self drawAtPosition:drawPosition];
        
        drawPosition.x --;
        if([self positionIsInBounds:drawPosition])
            [self fillImageAtPositionLeft:drawPosition];

        drawPosition.x ++;
        drawPosition.y --;
        if([self positionIsInBounds:drawPosition])
            [self fillImageAtPositionLeft:drawPosition];
        
        drawPosition.y += 2;
        if([self positionIsInBounds:drawPosition])
            [self fillImageAtPositionLeft:drawPosition];
    }
}

- (void)fillImageAtPositionRight:(CGPoint)position
{
    
}

- (BOOL)positionIsInBounds:(CGPoint)position
{
    BOOL inBounds = YES;
    
    if(position.x < 0 || position.y < 0 || position.x > self.bounds.size.width || position.y > self.bounds.size.height)
        inBounds = NO;
            
    return inBounds;
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
