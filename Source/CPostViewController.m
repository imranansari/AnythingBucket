//
//  CPostViewController.m
//  AnythingDB
//
//  Created by Jonathan Wight on 10/16/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CPostViewController.h"

#import <iAd/iAd.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <QuartzCore/QuartzCore.h>

#import "NSManagedObjectContext_Extensions.h"

#import "CBetterLocationManager.h"
#import "CAnythingDBServer.h"
#import "CCouchDBDatabase.h"
#import "CErrorPresenter.h"
#import "NSObject_KVOBlockNotificationExtensions.h"
#import "CLLocation_Extensions.h"
#import "CPosting.h"
#import "CCouchDBAttachment.h"
#import "UIActionSheet_BlocksExtensions.h"
#import "UIViewController_KeyboardExtensions.h"
#import "CMailTableViewCell.h"
#import "CPosting_CouchDBExtensions.h"
#import "CAnythingDBModel.h"
#import "CAttachment.h"

#define UNNULLIFY(x) x == [NSNull null] ? NULL : x;

@interface CPostViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, ADBannerViewDelegate, UITextViewDelegate, UIActionSheetDelegate>
@property (readwrite, nonatomic, retain) UIImagePickerController *imagePickerController;
@property (readwrite, nonatomic, assign) CGFloat textViewRowHeight;

@end

#pragma mark -

@implementation CPostViewController

@synthesize tagsTextField;
@synthesize subjectTextField;
@synthesize bodyTextView;
@synthesize inputAccessoryView;
@synthesize doneButton;
@synthesize posting;

@synthesize imagePickerController;
@synthesize textViewRowHeight;

- (id)init
	{
	if ((self = [super initWithNibName:NSStringFromClass([self class]) bundle:NULL]) != NULL)
		{
        self.title = @"Post";
        self.textViewRowHeight = 279;
		}
	return(self);
	}

- (void)dealloc
    {    
	// TODO

    [inputAccessoryView release];
    inputAccessoryView = NULL;
    
    [doneButton release];
    doneButton = NULL;
    //
    [super dealloc];
    }
    
#pragma mark -	

- (CPosting *)posting
    {
    if (posting == NULL)
        {
        NSManagedObjectContext *theContext = [CAnythingDBModel instance].managedObjectContext;
        NSError *theError = NULL;
        id theBlock = ^ (void) {
            CPosting *thePosting = [NSEntityDescription insertNewObjectForEntityForName:[CPosting entityName] inManagedObjectContext:[CAnythingDBModel instance].managedObjectContext];
            
            CLLocation *theLocation = [CBetterLocationManager instance].location;
            posting.location = theLocation;
            
            posting = [thePosting retain];
            };
        if ([theContext performTransaction:theBlock error:&theError])
            {
            NSLog(@"Error: %@", theError);
            }
        }
    return(posting);
    }

#pragma mark -

#pragma mark -	

- (void)viewDidLoad
    {
    [super viewDidLoad];
    //
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(done:)] autorelease];
    }

- (void)viewDidUnload
    {
    [super viewDidLoad];
    //
    //
    self.bodyTextView = NULL;
    self.inputAccessoryView = NULL;
    self.doneButton = NULL;
    }
    
- (void)viewWillAppear:(BOOL)animated
    {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(betterLocationManagerDidUpdateToLocationNotification:) name:kBetterLocationManagerDidUpdateToLocationNotification object:[CBetterLocationManager instance]];
    [[CBetterLocationManager instance] startUpdatingLocation:NULL];

    __block CPostViewController *_self = self;
    KVOBlock theKVOBlock = ^(NSString *keyPath, id object, NSDictionary *change, id identifier) {
        dispatch_block_t theBlock = ^(void) {
            id theDatabase = UNNULLIFY([change objectForKey:NSKeyValueChangeNewKey]);
            _self.doneButton.enabled = theDatabase != NULL;
            if (theDatabase != NULL)
                {
                [[CAnythingDBServer sharedInstance] removeObserver:_self forKeyPath:@"database" identifier:@"xyzzy"];
                }
            };
        dispatch_async(dispatch_get_main_queue(), theBlock);
        };
    [[CAnythingDBServer sharedInstance] addObserver:self handler:theKVOBlock forKeyPath:@"database" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew identifier:@"xyzzy"];
    
    [self respondToKeyboardAppearance];    
    }

- (void)viewWillDisappear:(BOOL)animated
    {
    [super viewWillDisappear:animated];

    NSManagedObjectContext *theContext = [CAnythingDBModel instance].managedObjectContext;
    id theTransactionBlock = ^ (void) {
        self.posting.title = self.subjectTextField.text;
        self.posting.body = self.bodyTextView.text;
		self.posting.tags = [self.tagsTextField.text componentsSeparatedByString:@","];
        };
    NSError *theError = NULL;
    if ([theContext performTransaction:theTransactionBlock error:&theError] == NO)
        {
        NSLog(@"Error: %@", theError);
        }
    
    [self stopRespondingToKeyboardAppearance];
    }

#pragma mark -

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
    {
    return(toInterfaceOrientation == UIInterfaceOrientationPortrait || UIInterfaceOrientationIsLandscape(toInterfaceOrientation));
    }

#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
    {
    return(3);
    }
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
    {
    UITableViewCell *theReturnedCell = NULL;
    
    switch (indexPath.row)
        {
        case 0:
            {
			CMailTableViewCell *theCell = (id)[self.tableView dequeueReusableCellWithIdentifier:@"TAGS_CELL"];
			if (theCell == NULL)
				{
				theCell = [[[CMailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TAGS_CELL"] autorelease];
				theCell.textLabel.text = @"Tags:";
				theCell.textField.text = [self.posting.tags componentsJoinedByString:@","];
				self.tagsTextField = theCell.textField;
				}
            theReturnedCell = theCell;
            }
            break;
        case 1:
            {
			CMailTableViewCell *theCell = (id)[self.tableView dequeueReusableCellWithIdentifier:@"SUBJECT_CELL"];
			if (theCell == NULL)
				{
				theCell = [[[CMailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SUBJECT_CELL"] autorelease];
				theCell.textLabel.text = @"Subject:";
				theCell.textField.text = self.posting.title;
				self.subjectTextField = theCell.textField;
				}
            theReturnedCell = theCell;
            }
            break;
        case 2:
            {
			UITableViewCell *theCell = [self.tableView dequeueReusableCellWithIdentifier:@"BODY_CELL"];
			if (theCell == NULL)
				{
				theCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BODY_CELL"] autorelease];
				theCell.selectionStyle = UITableViewCellSelectionStyleNone;
				if (self.bodyTextView == NULL)
					{
					self.bodyTextView = [[[UITextView alloc] initWithFrame:theCell.contentView.bounds] autorelease];
					self.bodyTextView.text = self.posting.body;
					self.bodyTextView.scrollEnabled = NO;
					self.bodyTextView.showsVerticalScrollIndicator = NO;
					self.bodyTextView.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
					self.bodyTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
					[[NSNotificationCenter defaultCenter] addObserverForName:UITextViewTextDidChangeNotification object:self.bodyTextView queue:NULL usingBlock:^(NSNotification *arg1) {
						CGSize theSize = [self.bodyTextView sizeThatFits:(CGSize){320, 99999}];
						if (theSize.height > 67)
							{
							[self.tableView beginUpdates];
							self.textViewRowHeight = theSize.height;
							[self.tableView endUpdates];
							[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
							}
						}];
					[theCell.contentView addSubview:self.bodyTextView];
					}
				}
            theReturnedCell = theCell;
			}
            break;
        }
    
    return(theReturnedCell);
    }

#pragma mark -
    
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
    {
    if (indexPath.row == 2)
        {
//        NSLog(@"%g", self.textViewRowHeight);
        return(self.textViewRowHeight);
        }
    else
        {
        return(44);
        }
    }
    
- (void)betterLocationManagerDidUpdateToLocationNotification:(NSNotification *)inNotification
    {
    NSManagedObjectContext *theContext = [CAnythingDBModel instance].managedObjectContext;
    id theTransactionBlock = ^ (void) {
		self.posting.location = [CBetterLocationManager instance].location;
		};
	NSError *theError = NULL;
	if ([theContext performTransaction:theTransactionBlock error:&theError] == NO)
		{
		NSLog(@"Error: %@", theError);
		}
    }
    
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error;
    {
//    NSLog(@"%@", error);
    }
    
#pragma mark -

- (IBAction)done:(id)inSender
    {
    NSLog(@"####### SENDING");
    
    [self.bodyTextView resignFirstResponder];
    
//    [[CUserNotificationManager instance] enqueueNotificationWithMessage:@"Posting"];
    
    NSManagedObjectContext *theContext = [CAnythingDBModel instance].managedObjectContext;
    id theTransactionBlock = ^ (void) {
		self.posting.title = self.subjectTextField.text;
		self.posting.body = self.bodyTextView.text;
		self.posting.tags = [self.tagsTextField.text componentsSeparatedByString:@","];
		};
	NSError *theError = NULL;
	if ([theContext performTransaction:theTransactionBlock error:&theError] == NO)
		{
		NSLog(@"Error: %@", theError);
		}
    
    CouchDBSuccessHandler theSuccessHandler = ^(id inParameter) {
        NSLog(@"########## RECEIVED: %@", inParameter);

//        [[CUserNotificationManager instance] dequeueCurrentNotification];
        
        [self dismissModalViewControllerAnimated:YES];
        };
    CouchDBFailureHandler theFailureHandler = ^(NSError *inError) {
        NSLog(@"Error: %@", inError);
//        [[CUserNotificationManager instance] dequeueCurrentNotification];
        [self presentError:inError];
        };
    [self.posting postWithSuccessHandler:theSuccessHandler failureHandler:theFailureHandler];
    }

- (IBAction)keyboard:(id)inSender
    {
	
    [self.bodyTextView resignFirstResponder];
    }
    
- (IBAction)photo:(id)inSender
    {
    UIActionSheet *theActionSheet = [[[UIActionSheet alloc] initWithTitle:NULL delegate:NULL cancelButtonTitle:NULL destructiveButtonTitle:NULL otherButtonTitles:NULL] autorelease];
    [theActionSheet retain];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
        NSArray *theAvailableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        if ([theAvailableMediaTypes containsObject:(id)kUTTypeImage] == YES && [theAvailableMediaTypes containsObject:(id)kUTTypeMovie] == YES)
            {
            [theActionSheet addButtonWithTitle:@"Take Photo or Video" handler:^(void) {
                UIImagePickerController *theController = [[[UIImagePickerController alloc] init] autorelease];
                theController.sourceType = UIImagePickerControllerSourceTypeCamera;
                theController.mediaTypes = [NSArray arrayWithObjects:(id)kUTTypeImage, (id)kUTTypeMovie, NULL];
                theController.allowsEditing = YES;
                theController.delegate = self;
                self.imagePickerController = theController;
                [self presentModalViewController:theController animated:YES];
                }];
            }
        else if ([theAvailableMediaTypes containsObject:(id)kUTTypeImage] == YES && [theAvailableMediaTypes containsObject:(id)kUTTypeMovie] == NO)
            {
            [theActionSheet addButtonWithTitle:@"Take Photo" handler:^(void) {
                UIImagePickerController *theController = [[[UIImagePickerController alloc] init] autorelease];
                theController.sourceType = UIImagePickerControllerSourceTypeCamera;
                theController.mediaTypes = [NSArray arrayWithObjects:(id)kUTTypeImage, NULL];
                theController.allowsEditing = YES;
                theController.delegate = self;
                self.imagePickerController = theController;
                [self presentModalViewController:theController animated:YES];
                }];
            }
        else if ([theAvailableMediaTypes containsObject:(id)kUTTypeImage] == NO && [theAvailableMediaTypes containsObject:(id)kUTTypeMovie] == YES)
            {
            CPostViewController *_self = self;
            
            [theActionSheet addButtonWithTitle:@"Take Movie" handler:^(void) {
                UIImagePickerController *theController = [[[UIImagePickerController alloc] init] autorelease];
                theController.sourceType = UIImagePickerControllerSourceTypeCamera;
                theController.mediaTypes = [NSArray arrayWithObjects:(id)kUTTypeMovie, NULL];
                theController.allowsEditing = YES;
                theController.delegate = self;
                _self.imagePickerController = theController;
                [_self presentModalViewController:theController animated:YES];
                }];
            }
        }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
        [theActionSheet addButtonWithTitle:@"Choose Existing" handler:^(void) {
            UIImagePickerController *theController = [[[UIImagePickerController alloc] init] autorelease];
            theController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//            theController.mediaTypes = [NSArray arrayWithObjects:(id)kUTTypeImage, NULL];
//            theController.allowsEditing = YES;
            theController.delegate = self;
            self.imagePickerController = theController;
            [self presentModalViewController:theController animated:YES];
            }];
        }
    theActionSheet.cancelButtonIndex = [theActionSheet addButtonWithTitle:@"Cancel"];

    [theActionSheet showFromBarButtonItem:inSender animated:YES];
    }
    
- (void)actionSheetCancel:(UIActionSheet *)actionSheet
    {
    }

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
    {
    NSString *theNewString = [self.bodyTextView.text stringByReplacingCharactersInRange:range withString:text];
    
    CGSize theSize = [theNewString sizeWithFont:self.bodyTextView.font constrainedToSize:(CGSize){320, 99999} lineBreakMode:UILineBreakModeWordWrap];
    
//    NSLog(@"%@", NSStringFromCGSize(theSize));
    if (theSize.height > 67)
        {
        [self.tableView beginUpdates];
        self.textViewRowHeight = theSize.height;
        [self.tableView endUpdates];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    return(YES);
    }

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
    {
//    NSLog(@"%@", info);
    id theMediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([theMediaType isEqualToString:(id)kUTTypeImage])
        {
        UIImage *theImage = [info objectForKey:UIImagePickerControllerEditedImage];
        if (theImage == NULL)
            {
            theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
            }

//        UIImageWriteToSavedPhotosAlbum(theImage, NULL, NULL, NULL);

        NSData *theJPEGRepresentation = UIImageJPEGRepresentation(theImage, 0.8);
        NSLog(@"%d", [theJPEGRepresentation length]);
        
        NSManagedObjectContext *theContext = [CAnythingDBModel instance].managedObjectContext;
        id theTransactionBlock = ^ (void) {
            CAttachment *theAttachment = [NSEntityDescription insertNewObjectForEntityForName:[CAttachment entityName] inManagedObjectContext:theContext];
            theAttachment.identifier = @"image.jpg";
            theAttachment.contentType = @"image/jpeg";
            theAttachment.data = theJPEGRepresentation;
            [self.posting.attachments addObject:theAttachment];
            };
        NSError *theError = NULL;
        if ([theContext performTransaction:theTransactionBlock error:&theError] == NO)
            {
            NSLog(@"Error: %@", theError);
            }
        }
    else if ([theMediaType isEqualToString:(id)kUTTypeMovie])
        {
        // NSCache
        // public.movie
//        NSLog(@"%@", info);

//    NSLog(@"%@", UTTypeCopyPreferredTagWithClass(kUTTypeMovie, kUTTagClassMIMEType));


//        NSLog(@"%@", UTTypeCopyDeclaration(kUTTypeMovie));

        NSURL *theMediaURL = [info objectForKey:UIImagePickerControllerMediaURL];
        NSData *theData = NULL;
        if ([theMediaURL isFileURL])
            {
            NSError *theError = NULL;
            theData = [NSData dataWithContentsOfURL:theMediaURL options:NSDataReadingMapped error:&theError];
            NSLog(@"%@", theError);
            }

//        self.posting.attachments = [NSArray arrayWithObjects:
//            [[[CCouchDBAttachment alloc] initWithIdentifier:@"movie.mov" contentType:@"video/quicktime" data:theData] autorelease],
//            NULL];
        }
    
    [self dismissModalViewControllerAnimated:YES];
    }

@end
