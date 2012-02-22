//
//  DOPixelPainterViewContoller.m
//  pixel painter
//
//  Created by David Ochmann on 07.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DOPixelPainterViewContoller.h"

@implementation DOPixelPainterViewContoller

@synthesize navigationView = _navigationView;
@synthesize folderView = _folderView;
@synthesize model = _model;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self)
    {
        self.model.navigationStatus = NAVIGATION_STATUS_NAVIGATION;
    }
    
    return self;
}

/* GETTER / SETTER */

- (DOPixelPainterModel *)model
{    
    if(!_model) 
    {
        _model = [[DOPixelPainterModel alloc] init];
        [_model addObserver:self forKeyPath:@"navigationStatus" options:NSKeyValueObservingOptionNew context:@selector(navigationStatus)];
    }
    
    return _model;
}

/* ACTIONS */

- (IBAction)folderButtonTouchUpInsideHandler:(id)sender 
{
    switch (self.model.navigationStatus) 
    {
        case NAVIGATION_STATUS_NAVIGATION:
            self.model.navigationStatus = NAVIGATION_STATUS_CLOSED;
            break;
            
        case NAVIGATION_STATUS_CLOSED:
            self.model.navigationStatus = NAVIGATION_STATUS_NAVIGATION;
            break;
    }
}

- (void)changeNavigationStatus:(NSNumber *)to
{
    CGRect navigationFrame = self.navigationView.frame;
 
    switch([to intValue]) 
    {
        case NAVIGATION_STATUS_CLOSED:
            navigationFrame.origin.y = NAVIGATION_POSITION_CLOSED;
            break;

        case NAVIGATION_STATUS_NAVIGATION:
            navigationFrame.origin.y = NAVIGATION_POSITION_NAVIGATION;
            break;
            
        case NAVIGATION_STATUS_SUBVIEW:
            navigationFrame.origin.y = NAVIGATION_POSITION_SUBVIEW;
            break;
    }
    
    [self.navigationView setFrame:navigationFrame];
}

/* OBSERVER IMPLEMENTATION */

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"observer %@", (NSNumber *)[change valueForKey:@"new"]);
    
    if(keyPath == @"navigationStatus")
    {
        [self changeNavigationStatus: (NSNumber *)[change valueForKey:@"new"]];
    }
}


/*
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
 {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 
 if (self) 
 {
 NSLog(@"initWithNibName");
 }
 return self;
 }
 
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setNavigationView:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)viewDidUnload 
{
    [self setFolderView:nil];
    [self setNavigationView:nil];
    [super viewDidUnload];
}

@end
