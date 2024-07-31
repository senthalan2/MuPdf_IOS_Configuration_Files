//
//  Utilities.h
//  TeachingsOfSwamiDayananda
//
//  Created by kumar on 26/07/24.
//

#ifndef Utilities_h
#define Utilities_h

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface Utilities : NSObject <UIActionSheetDelegate>{
  NSString *xibPostfix;
}

@property (nonatomic, retain) NSString *xibPostfix;

// Singleton instance method
+ (Utilities *) getInstance;

// Method to get the name of the database
- (NSString *) getDatabaseName;

// Method to fetch all bookmarks for a given bookID
- (NSMutableArray *) getAllBookMarks :(NSString *) bookID;

// Method to check if a specific page in a book is already bookmarked
- (bool) isAlreadyBookMarked :(NSString *) bookID :(int) pageNumber;

// Method to delete a bookmark for a specific bookID and pageNumber
- (bool) deleteBookMark :(NSString *) bookID :(int) pageNumber;

// Method to save a new bookmark
- (bool) saveBookMark :(NSString *) bookID :(int) pageNumber :(NSString *) bmDescription;

// Method to show toast
- (void)showToastWithMessage:(NSString *)message inView:(UIView *)view;

@end


#endif /* Utilities_h */
