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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {}
    return self;
}


/* GETTER / SETTER */

- (DOPixelPainterModel *) model
{    
    if(!_model) _model = [[DOPixelPainterModel alloc] init];
    return _model;
}


/* ACTIONS */

- (IBAction)folderButtonTouchUpInsideHandler:(id)sender 
{
//    NSLog(@"model %d", self.model.folderIsOpen);
    
    BOOL switchedFolderIsOpen = !self.model.folderIsOpen;
        
    [self closeFolder: switchedFolderIsOpen]; 
    self.model.folderIsOpen = switchedFolderIsOpen;
}


- (void)closeFolder:(BOOL)to
{
    NSLog(@"closeFolder %d", to);
    
    CGRect navigationFrame = self.navigationView.frame; 
    
    if(to)
    {
        navigationFrame.origin.y = NAVIGATION_POSITION_0;
        [self.navigationView setFrame:navigationFrame];
    }
    else
    {
        navigationFrame.origin.y = NAVIGATION_POSITION_1;
        [self.navigationView setFrame:navigationFrame];        
    }
}




/*
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
