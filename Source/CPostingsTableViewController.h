//
//  CPostingsTableViewController.h
//  AnythingDB
//
//  Created by Jonathan Wight on 10/20/10.
//  Copyright (c) 2010 toxicsoftware.com. All rights reserved.
//

#import "CTableViewController.h"

@interface CPostingsTableViewController : CTableViewController {
    NSMutableArray *postings;
}

@property (readwrite, nonatomic, retain) NSMutableArray *postings;

- (IBAction)post:(id)inSender;

@end