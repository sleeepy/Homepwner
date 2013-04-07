//
//  ImageViewController.m
//  Homepwner
//
//  Created by Eric Kim on 12/24/12.
//  Copyright (c) 2012 Eric Kim. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

@synthesize image;



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGSize sz = self.image.size;
    
    scrollView.contentSize = sz;
    imageView.frame = CGRectMake(0, 0, sz.width, sz.height);
    imageView.image = self.image;
}

@end
