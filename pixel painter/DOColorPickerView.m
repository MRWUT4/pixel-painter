//
//  DOColorPickerView.m
//  pixel painter
//
//  Created by David Ochmann on 22.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DOColorPickerView.h"

@implementation DOColorPickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
 
 - (void)viewDidLoad
 {
 [super viewDidLoad];
 
 [gradientView setTheColor:[UIColor colorWithHex:0xff0000]];
 [gradientView setupGradient]; 
 
 [self initModel];
 }
 
 - (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
 {
 touchPosition = [[touches anyObject] locationInView:colorMapImage];    
 
 
 CGSize size = [[colorMapImage image] size];
 CGRect transform = [colorMapImage frame];
 
 CGPoint scale = CGPointMake(transform.size.width / size.width, transform.size.height / size.height);
 CGPoint transformedPosition = CGPointMake(floor(touchPosition.x / scale.x), floor(touchPosition.y / scale.y));
 
 
 [dot setTransform:CGAffineTransformMakeTranslation(touchPosition.x, touchPosition.y)];
 
 UIColor *color = [colorMapImage getPixelColorAtLocation:transformedPosition];
 model.color = color;   
 }
 
- (void)initModel
{
    NSLog(@"initModel");
    
    model = [Model sharedModel];        
    [model addObserver:self forKeyPath:@"color" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)pKeyPath ofObject:(id)pObject change:(NSDictionary *)pChange context:(void *)pContext
{
    if(pKeyPath == @"color")
    {
        [gradientView setTheColor:model.color];
        [gradientView setupGradient];
        [gradientView setNeedsDisplay];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [self setColorMapImage:nil];
    [self setGradientView:nil];
    [self setDot:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
 
*/

@end
