//
//  BookMarkView.m
//  MyTask247
//
//  Created by Dvijen on 15/09/14.
//  Copyright (c) 2014 Divine Arts Techno Media. All rights reserved.
//

#import "BookMarkView.h"

@implementation BookMarkView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        //moduleClass = [ModuleClass getInstance];
    }
    return self;
}

/*- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        //Cancel
    } else {
        //OK
    }
}*/

- (IBAction)tickForDeleting:(UISwitch *)sender {
  NSLog(@"TESTTTTTTTTTTINDEX");
	if ([self.switchDelete isOn]) {
		NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:self.bookPageNumber, @"page_number", nil];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:@"MARK_TO_DELETE_BOOK_MARK" object:self userInfo:userInfo];
	} else {
		NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:self.bookPageNumber, @"page_number", nil];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:@"UNMARK_TO_DELETE_BOOK_MARK" object:self userInfo:userInfo];
	}
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
