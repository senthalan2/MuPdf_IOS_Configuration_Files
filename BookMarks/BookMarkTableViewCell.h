//
//  BookMarkTableViewCell.h
//  MyTask247
//
//  Created by Dvijen on 03/09/14.
//  Copyright (c) 2014 Divine Arts Techno Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookMarkView.h"
#import "Utilities.h"

@interface BookMarkTableViewCell : UITableViewCell {
    
    Utilities *utilities;
}

@property (nonatomic, retain) NSDictionary *bookDetailsArray;

@property (nonatomic, retain) NSString *bookID;
@property (nonatomic, retain) BookMarkView *bookMarkView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier bookMarkDetails:(NSMutableArray *)bookMarkDetailsArray;

@end
