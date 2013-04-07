//
//  ImageViewController.h
//  Homepwner
//
//  Created by Eric Kim on 12/24/12.
//  Copyright (c) 2012 Eric Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController
{
    __weak IBOutlet UIScrollView *scrollView;
    __weak IBOutlet UIImageView *imageView;
}

@property (nonatomic, strong) UIImage *image;

@end
