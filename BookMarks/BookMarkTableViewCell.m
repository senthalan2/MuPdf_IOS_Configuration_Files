//
//  BookMarkTableViewCell.m
//  MyTask247
//
//  Created by Dvijen on 03/09/14.
//  Copyright (c) 2014 Divine Arts Techno Media. All rights reserved.
//

#import "BookMarkTableViewCell.h"

@implementation BookMarkTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier bookMarkDetails:(NSMutableArray *)bookMarkDetailsArray
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  
    if (self) {
        // Initialization code
        
        utilities = [Utilities getInstance];
        
        self.bookID = [bookMarkDetailsArray objectAtIndex:0];
     
        
        NSString *xibName = @"BookMarkView_iPhone";
        if ([utilities.xibPostfix caseInsensitiveCompare:@"iPad"] == NSOrderedSame) {
            xibName = @"BookMarkView_iPad";
		} else if ([utilities.xibPostfix caseInsensitiveCompare:@"iPhone6"] == NSOrderedSame) {
			xibName = @"BookMarkView_iPhone6";
		} else if ([utilities.xibPostfix caseInsensitiveCompare:@"iPhone6s"] == NSOrderedSame) {
			xibName = @"BookMarkView_iPhone6s";
		} else if ([utilities.xibPostfix caseInsensitiveCompare:@"iPhoneX"] == NSOrderedSame) {
			xibName = @"BookMarkView_iPhoneX";
		}
		
        BookMarkView *newBookView = [[[NSBundle mainBundle] loadNibNamed:xibName owner:self options:nil] objectAtIndex:0];
     
        CGRect bookViewRect = CGRectMake(0, 0, 320, 105);
        if ([utilities.xibPostfix caseInsensitiveCompare:@"iPad"] == NSOrderedSame) {
            bookViewRect = CGRectMake(0, 0, 768, 199);
		}else if ([utilities.xibPostfix caseInsensitiveCompare:@"iPhone6"] == NSOrderedSame) {
			bookViewRect = CGRectMake(0, 0, 375, 120);
		}else if ([utilities.xibPostfix caseInsensitiveCompare:@"iPhone6s"] == NSOrderedSame) {
			bookViewRect = CGRectMake(0, 0, 415, 140);
		}
        self.frame = bookViewRect;
        self.bounds = bookViewRect;
        newBookView.frame = bookViewRect;
        newBookView.bounds = bookViewRect;
        
        newBookView.utilities = [Utilities getInstance];
		newBookView.bookID = [bookMarkDetailsArray objectAtIndex:0];
        newBookView.lblPageNumber.text = [NSString stringWithFormat:@"Page %d", (int) [[bookMarkDetailsArray objectAtIndex:1] integerValue]];
		newBookView.bookPageNumber = [bookMarkDetailsArray objectAtIndex:1];
        newBookView.lblBMDescription.text = [bookMarkDetailsArray objectAtIndex:2];
      self.bookMarkView = newBookView;
        [self addSubview:newBookView];
      // Initialize UISwitch
             UISwitch *bookmarkSwitch = [[UISwitch alloc] init];
             bookmarkSwitch.translatesAutoresizingMaskIntoConstraints = NO;
             [bookmarkSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
             
             // Add UISwitch to the cell's content view
             [self.contentView addSubview:bookmarkSwitch];
             
             // Set constraints to align the switch to the left
             [NSLayoutConstraint activateConstraints:@[
                 [bookmarkSwitch.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:16],
                 [bookmarkSwitch.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor]
             ]];
        
    }
    return self;
}

- (void)switchValueChanged:(UISwitch *)sender {
  
    NSLog(@"Switch state changed: %@", sender.isOn ? @"ON" : @"OFF");
    // Handle the switch value change
  
  NSLog(@"TESTTTTTTTTTTINDEX");
  if (sender.isOn) {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:self.bookMarkView.bookPageNumber, @"page_number", nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MARK_TO_DELETE_BOOK_MARK" object:self userInfo:userInfo];
  } else {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:self.bookMarkView.bookPageNumber, @"page_number", nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UNMARK_TO_DELETE_BOOK_MARK" object:self userInfo:userInfo];
  }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.frame = CGRectMake(self.imageView.frame.origin.x + 13, self.imageView.frame.origin.y + 7, 73, 73);
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
    //CGRect imageFrame = self.imageView.frame;
}

- (void)awakeFromNib
{
	[super awakeFromNib];
	
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
