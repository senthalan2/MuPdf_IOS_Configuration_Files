//
//  CheckTableViewCell.h
//  TeachingsOfSwamiDayananda
//
//  Created by kumar on 29/07/24.
//

#ifndef CheckTableViewCell_h
#define CheckTableViewCell_h

#import <UIKit/UIKit.h>
#import "BookMarkView.h"
#import "Utilities.h"

@interface CheckTableViewCellCheckTableViewCellCheckTableViewCell : UITableViewCell {
    
    Utilities *utilities;
}

@property (nonatomic, retain) NSDictionary *bookDetailsArray;

@property (nonatomic, retain) NSString *bookID;


@end


#endif /* CheckTableViewCell_h */
