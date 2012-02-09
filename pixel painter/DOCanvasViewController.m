//
//  DOFirstViewController.m
//  pixel painter
//
//  Created by David Ochmann on 29.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DOCanvasViewController.h"

@implementation DOCanvasViewController

- (void)viewWillAppear:(BOOL)animated
{
    //insert your code here
    //EDIT
    
    NSLog(@"viewWillAppear");
    
    [super viewWillAppear:YES];
}

- (void)willMoveToParentViewController:(UIViewController *)parent
{
    NSLog(@"parent %@", parent);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender 
{
    NSLog(@"%@", sender);
}

- (void)viewWillUnload
{
    NSLog(@"viewWillUnload");
}


@end
