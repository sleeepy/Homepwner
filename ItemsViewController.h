//
//  ItemsViewController.h
//  Homepwner
//
//  Created by Eric Kim on 12/4/12.
//  Copyright (c) 2012 Eric Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailViewController.h"


@interface ItemsViewController : UITableViewController <UIPopoverControllerDelegate>
{
    UIPopoverController *imagePopover;
}

- (IBAction)addNewItem:(id)sender;

@end
