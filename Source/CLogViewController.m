//
//  CLogViewController.m
//  AnythingBucket
//
//  Created by Jonathan Wight on 06/18/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CLogViewController.h"

#import "CMemoryLogDestination.h"
#import "CLogEvent.h"

@interface CLogViewController ()
@end

@implementation CLogViewController

- (void)viewDidAppear:(BOOL)animated
    {
    [super viewDidAppear:animated];
    //
    CMemoryLogDestination *theDestination = [CMemoryLogDestination sharedInstance];
    
    [theDestination addObserver:self forKeyPath:@"events" options:0 context:NULL];
//    [theDestination.events addObserver:self toObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:(NSRange){0, theDestination.events.count}] forKeyPath:@"self" options:0 context:NULL];
    }

- (void)viewWillDisappear:(BOOL)animated
    {
    [super viewWillDisappear:animated];

    CMemoryLogDestination *theDestination = [CMemoryLogDestination sharedInstance];
    
    [theDestination removeObserver:self forKeyPath:@"events"];
    }


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
    {
    return([CMemoryLogDestination sharedInstance].events.count);
    }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
    {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
    
    CLogEvent *theEvent = [[CMemoryLogDestination sharedInstance].events objectAtIndex:indexPath.row];
    cell.textLabel.text = theEvent.message;
    
    
    cell.detailTextLabel.text = [NSDateFormatter localizedStringFromDate:theEvent.timestamp dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterFullStyle];

    // Configure the cell...
    
    return cell;
    }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
    {
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    }
    
- (IBAction)log:(id)inSender
    {
    LogDebug_(@"This is a test log");
    }

#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
    {
    if ([[change objectForKey:NSKeyValueChangeKindKey] integerValue] == NSKeyValueChangeInsertion)
        {
        NSIndexSet *theIndexes = [change objectForKey:NSKeyValueChangeIndexesKey];
        
        __block NSIndexPath *theIndexPath = NULL;
        
        [self.tableView beginUpdates];
        [theIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
            theIndexPath = [NSIndexPath indexPathForRow:idx inSection:0];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:theIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
        
        [self.tableView endUpdates];
        
        [self.tableView scrollToRowAtIndexPath:theIndexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
        }
    }

@end
