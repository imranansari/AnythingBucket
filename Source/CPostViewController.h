//
//  CPostViewController.h
//  AnythingDB
//
//  Created by Jonathan Wight on 10/16/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CTableViewController.h"

@class CPosting;

@interface CPostViewController : CTableViewController {

}

@property (readwrite, nonatomic, retain) IBOutlet UITextField *tagsTextField;
@property (readwrite, nonatomic, retain) IBOutlet UITextField *subjectTextField;
@property (readwrite, nonatomic, retain) IBOutlet UITextView *bodyTextView;
@property (readwrite, nonatomic, retain) IBOutlet UIToolbar *inputAccessoryView;
@property (readwrite, nonatomic, retain) IBOutlet UIBarButtonItem *doneButton;
@property (readwrite, nonatomic, retain) CPosting *posting;

- (IBAction)done:(id)inSender;
- (IBAction)cancel:(id)inSender;
- (IBAction)keyboard:(id)inSender;
- (IBAction)photo:(id)inSender;

@end
