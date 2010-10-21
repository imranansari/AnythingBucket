//
//  CMyCell.m
//  AnythingDB
//
//  Created by Jonathan Wight on 10/18/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CMyCell.h"

#import <QuartzCore/QuartzCore.h>

#import "Geometry.h"

@implementation CMyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
    {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) != NULL)
        {
        self.textLabel.numberOfLines = 1;
        self.textLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
        self.textLabel.textColor = [UIColor grayColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    return(self);
    }


- (UITextField *)textField
    {
    if (textField == NULL)
        {
        textField = [[UITextField alloc] initWithFrame:self.contentView.bounds];
        textField.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
        textField.textColor = [UIColor grayColor];
        [textField sizeToFit];
        }
    return(textField);
    }

- (void)layoutSubviews
    {
    [super layoutSubviews];
    
    if (self.textField.superview == NULL)
        {
        [self.contentView addSubview:self.textField];
        }
    
    self.contentView.frame = CGRectInset(self.bounds, 5, 0);

//    self.contentView.layer.borderWidth = 1.0;
//    self.contentView.layer.borderColor = [UIColor redColor].CGColor;
//
//    self.textLabel.layer.borderWidth = 1.0;
//    self.textLabel.layer.borderColor = [UIColor blueColor].CGColor;
//
//    self.textField.layer.borderWidth = 1.0;
//    self.textField.layer.borderColor = [UIColor greenColor].CGColor;
    
    [self.textLabel sizeToFit];
    [self.textField sizeToFit];

    CGRect theSlice;
    CGRect theRemainder;

    CGRectDivide(self.contentView.frame, &theSlice, &theRemainder, self.textLabel.frame.size.width + 5.0, CGRectMinXEdge);
    self.textLabel.frame = theSlice;

    CGRect theFrame = self.textLabel.frame;
    theFrame.origin.x = theSlice.origin.x;
    theFrame.origin.y = (theSlice.size.height - theFrame.size.height) * 0.5;
    theFrame.size.width = theSlice.size.width;
    theFrame = CGRectIntegral(theFrame);
    self.textLabel.frame = theFrame;


    theFrame = self.textField.frame;
    theFrame.origin.x = theRemainder.origin.x;
    theFrame.origin.y = (theRemainder.size.height - theFrame.size.height) * 0.5;
    theFrame.size.width = theRemainder.size.width;
    theFrame = CGRectIntegral(theFrame);
    self.textField.frame = theFrame;
    }

@end
