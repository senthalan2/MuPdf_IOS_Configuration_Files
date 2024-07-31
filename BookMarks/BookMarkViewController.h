//
//  BookMarkViewController.h
//  EasySample
//
//  Created by Marian PAUL on 12/06/12.
//  Copyright (c) 2012 Marian PAUL aka ipodishima — iPuP SARL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utilities.h"
#import "BookMarkTableViewCell.h"


@interface BookMarkViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
 
  Utilities *utilities;
    
    NSMutableArray *bookMarkArray;
	
	IBOutlet UITableView *bookMarkTableView;
    IBOutlet UIButton *deleteButton;
    IBOutlet UILabel *noDataLabel;
    
	NSMutableArray *toDeleteBookMarks;
}
- (void) setWindowNavigationToDismiss:(UIWindow*) window navigator:(UINavigationController *)navigator;
@property (nonatomic, retain) NSString *bookId;

@end
