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
@synthesize touchPosition = _touchPosition;
@synthesize imageView = _imageView;
@synthesize scrollEnabled = _scrollEnabled;
@synthesize mode = _mode;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self)
    {
        self.imageView = [[UIImageView alloc] initWithFrame:self.frame];
        [self addSubview:self.imageView];
    
        self.imageView.layer.magnificationFilter = kCAFilterNearest;
        self.layer.magnificationFilter = kCAFilterNearest;
        
        NSLog(@"mode %i", self.mode);
    }
    
    return self;
}

/*
 * TOUCHES MOVED HANDLER
 */

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self modeAction:touches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self modeAction:touches];    
}

- (void)modeAction:(NSSet *)touches
{
    if(!self.scrollEnabled) 
    {
        switch (self.mode) 
        {
            case STATE_DRAWING:
                [self drawAtTouches:touches];
                break;
                
            case STATE_PICKING:
                [self pickColorAtTouches:touches];
                break;
        }
    }
}

- (void)drawAtTouches:(NSSet*)touches
{
    self.touchPosition = [[touches anyObject] locationInView:self];
    self.touchPosition = CGPointMake((int) (self.touchPosition.x / 1), (int) (self.touchPosition.y / 1));
    
    UIGraphicsBeginImageContext(self.imageView.frame.size);
    
    [self.imageView.image drawInRect:CGRectMake(0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height)];
    
    CGContextRef cgContext = UIGraphicsGetCurrentContext();
        
    CGContextSetFillColorWithColor(cgContext, self.color.CGColor); 
    CGContextFillRect(cgContext, CGRectMake(self.touchPosition.x, self.touchPosition.y, 1, 1));
    
    CGContextFlush(UIGraphicsGetCurrentContext());
    
    self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
}

- (void)pickColorAtTouches:(NSSet*)touches
{    
    self.touchPosition = [[touches anyObject] locationInView:self];
    self.touchPosition = CGPointMake((int) (self.touchPosition.x / 1), (int) (self.touchPosition.y / 1));
    
    UIColor *pickedColor = [self.imageView getPixelColorAtLocation:self.touchPosition];
    
    if(CGColorGetAlpha(pickedColor.CGColor) != 0)
    {    
        self.color = pickedColor;
    
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_COLOR_DRAWINGVIEW_PICKED object:self];
    }
}

/* SAVE IMAGE DATA */

- (UIImage *) composeImageWithWidth:(NSInteger)_width andHeight:(NSInteger)_height
{
    CGSize _size = CGSizeMake(_width, _height);
    UIGraphicsBeginImageContext(_size);
   
    UIImage *_compositeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return _compositeImage;
}

- (BOOL) writeApplicationData:(NSData *)data toFile:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    if (!documentsDirectory) {
        NSLog(@"Documents directory not found!");
        return NO;
    }
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
    return ([data writeToFile:appFile atomically:YES]);
}



@end
