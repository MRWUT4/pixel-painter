//
//  DOSecondViewController.m
//  pixel painter
//
//  Created by David Ochmann on 29.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DOColorPickerViewController.h"
#import "UIImageView-ColorUtils.h"

@implementation DOColorPickerViewController

@synthesize colorMapOutlet = _colorMapOutlet;
@synthesize touchPosition = _touchPosition;

- (void)setTouchPosition:(CGPoint)touchPosition
{
    CGFloat colorMapBoundsWidth = self.colorMapOutlet.bounds.size.width;
    CGFloat colorMapBoundsHeight = self.colorMapOutlet.bounds.size.height;
    
    _touchPosition.x = touchPosition.x <= 0 ? 0 : touchPosition.x >= colorMapBoundsWidth ? colorMapBoundsWidth : touchPosition.x;
    
    _touchPosition.y = touchPosition.y <= 0 ? 0 : touchPosition.y >= colorMapBoundsHeight ? colorMapBoundsHeight : touchPosition.y;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesHandler:touches];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesHandler:touches];
}

- (void)touchesHandler:(NSSet *)touches
{
    self.touchPosition = [[touches anyObject] locationInView:self.colorMapOutlet]; 
    
    CGSize size = [[self.colorMapOutlet image] size];
    CGRect transform = [self.colorMapOutlet frame];
    
    CGPoint scale = CGPointMake(transform.size.width / size.width, transform.size.height / size.height);
    
    CGPoint transformedPosition = CGPointMake(floor(self.touchPosition.x / scale.x), floor(self.touchPosition.y / scale.y));
    
    UIColor *color = [self.colorMapOutlet getPixelColorAtLocation:transformedPosition];
    
    NSLog(@"%@", color);
}

- (void)viewDidUnload 
{
    [self setColorMapOutlet:nil];
    [super viewDidUnload];
}

@end
