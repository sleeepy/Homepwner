//
//  HPItemCell.m
//  Homepwner
//
//  Created by Eric Kim on 12/21/12.
//  Copyright (c) 2012 Eric Kim. All rights reserved.
//

#import "HPItemCell.h"

@implementation HPItemCell

@synthesize controller, tableView;


- (IBAction)showImage:(id)sender
{    
    NSString *selector = [NSStringFromSelector(_cmd) stringByAppendingString:@"atIndexPath:"];

    SEL newSelector = NSSelectorFromString(selector);
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:self];
    
    if (indexPath) {
        if ([self.controller respondsToSelector:newSelector]) {
            [self.controller performSelector:newSelector withObject:sender withObject:indexPath];
        }
    }
    
}


@end
