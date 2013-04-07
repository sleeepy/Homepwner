//
//  ItemsViewController.m
//  Homepwner
//
//  Created by Eric Kim on 12/4/12.
//  Copyright (c) 2012 Eric Kim. All rights reserved.
//

#import "ItemsViewController.h"
#import "BNRItemStore.h"
#import "BNRItem.h"
#import "HPItemCell.h"

#import "BNRImageStore.h"
#import "ImageViewController.h"


@implementation ItemsViewController



- (id)init
{
    // Call the superclass' designated initializer
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        UINavigationItem *n = self.navigationItem;
        n.title = @"Homepwner";
        
        // Bar button to add new item
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
        self.navigationItem.rightBarButtonItem = bbi;
        self.navigationItem.leftBarButtonItem = [self editButtonItem];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"HPItemCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"HPItemCell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)io
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return YES;
    } else {
        return (io == UIInterfaceOrientationPortrait);
    }
}

- (IBAction)addNewItem:(id)sender
{
    BNRItem *newItem = [[BNRItemStore sharedStore] createItem];
    
    //int lastRow = [[[BNRItemStore sharedStore] allItems] indexOfObject:newItem];
    // Get indexpath
    // NSIndexPath *ip = [NSIndexPath indexPathForRow:lastRow inSection:0];
    
    // Add row to top of tableview
    //[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:ip] withRowAnimation:UITableViewRowAnimationTop];
    
    DetailViewController *detailViewController = [[DetailViewController alloc] initForNewItem:YES];
    detailViewController.item = newItem;
    [detailViewController setDismissBlock:^{
        [self.tableView reloadData];
    }];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    [navController setModalPresentationStyle:UIModalPresentationFormSheet];
    [navController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:navController animated:YES completion:nil];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[BNRItemStore sharedStore] allItems] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BNRItem *p = [[[BNRItemStore sharedStore] allItems] objectAtIndex:indexPath.row];
    
    HPItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HPItemCell"];
    
    cell.controller = self;
    cell.tableView = tableView;
    
    cell.nameLabel.text = p.itemName;
    cell.thumbnailView.image = p.thumbnail;
    cell.serialNumberLabel.text = p.serialNumber;
    cell.valueLabel.text = [NSString stringWithFormat:@"$%d", p.valueInDollars];
    
    return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        BNRItemStore *ps = [BNRItemStore sharedStore];
        NSArray *items = [ps allItems];
        BNRItem *p = [items objectAtIndex:indexPath.row];
        [ps removeItem:p];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[BNRItemStore sharedStore] moveItemAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detailViewController = [[DetailViewController alloc] initForNewItem:NO];
    
    // Pass along the BNRItem to edit in DVC
    NSArray *items = [[BNRItemStore sharedStore] allItems];
    BNRItem *selectedItem = [items objectAtIndex:indexPath.row];
    detailViewController.item = selectedItem;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark - UIPopoverControllerDelegate
- (void)showImage:(id)sender atIndexPath:(NSIndexPath *)ip
{
    NSLog(@"Going to show the image for %@", ip);
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        BNRItem *i = [[[BNRItemStore sharedStore] allItems] objectAtIndex:ip.row];
        NSString *imageKey = i.imageKey;
        UIImage *img = [[BNRImageStore sharedStore] imageForKey:imageKey];
    
        if (!img) return;
        
        CGRect rect = [self.view convertRect:[sender bounds] fromView:sender];
    
        ImageViewController *ivc = [[ImageViewController alloc] init];
        ivc.image = img;
        
        imagePopover = [[UIPopoverController alloc] initWithContentViewController:ivc];
        imagePopover.delegate = self;
        imagePopover.popoverContentSize = CGSizeMake(600, 600);
        
        [imagePopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [imagePopover dismissPopoverAnimated:YES];
    imagePopover = nil;
}


@end
