//
//  HPItemCell.h
//  Homepwner
//
//  Created by Eric Kim on 12/21/12.
//  Copyright (c) 2012 Eric Kim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HPItemCell : UITableViewCell



@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

- (IBAction)showImage:(id)sender;

@property (nonatomic, weak) id controller;
@property (nonatomic, weak) UITableView *tableView;

@end
