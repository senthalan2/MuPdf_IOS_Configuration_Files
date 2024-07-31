//
//  BookMarkView.h
//  MyTask247
//
//  Created by Dvijen on 15/09/14.
//  Copyright (c) 2014 Divine Arts Techno Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utilities.h"
#import "MarqueeLabel.h"

@interface BookMarkView : UIView  {
	
}

@property (nonatomic, retain) IBOutlet MarqueeLabel *lblBMDescription, *lblPageNumber;

@property (nonatomic, retain) IBOutlet UISwitch *switchDelete;

@property (nonatomic, retain) NSString *bookID, *bookPageNumber, *bookMarkDescription;

@property (nonatomic, retain) Utilities *utilities;

@property (nonatomic, assign) int viewIndex;

@end
