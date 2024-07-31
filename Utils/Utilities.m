//
//  Utilities.m
//  TeachingsOfSwamiDayananda
//
//  Created by kumar on 26/07/24.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"
#import "Utilities.h"

@interface Utilities ()

@property (nonatomic, assign) sqlite3 *database;

@end

@implementation Utilities

static Utilities *instance = nil;

+ (Utilities *) getInstance
{
    @synchronized(self)
    {
        if(instance == nil)
        {
            instance = [Utilities new];
        }
    }
    return instance;
}

- (NSString *) getDatabaseName
{
    return @"master_v2.db";
}

- (NSMutableArray *) getAllBookMarks :(NSString *) bookID {
  
  NSMutableArray *booksMarksArray = [[NSMutableArray alloc] init];
  
  // Setup some globals
  NSString *databaseName = [self getDatabaseName];
  
  // Get the path to the documents directory and append the databaseName
  NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDir = [documentPaths objectAtIndex:0];
  NSString *databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
  
  // Execute the "checkAndCreateDatabase" function
  [self checkAndCreateDatabase :databasePath];
  
  // Setup the database object
  sqlite3 *database;
  
  // Open the database from the users filessytem
  if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
    // Setup the SQL Statement and compile it for faster access
    const char *sqlStatement = [[NSString stringWithFormat:@"SELECT * FROM BookMarkMaster WHERE BookID = '%@'", bookID] UTF8String];
    sqlite3_stmt *compiledStatement;
    if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
      // Loop through the results and add them to the feeds array
      while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
        // Read the data from the result row
        NSMutableArray *bookMarkDetailsArray = [[NSMutableArray alloc] init];
        [bookMarkDetailsArray addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)]];
        [bookMarkDetailsArray addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)]];
        [bookMarkDetailsArray addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)]];
        [booksMarksArray addObject:bookMarkDetailsArray];
      }
    }
    // Release the compiled statement from memory
    sqlite3_finalize(compiledStatement);
  }
  sqlite3_close(database);
  
  return booksMarksArray;
}

- (bool) isAlreadyBookMarked :(NSString *) bookID :(int) pageNumber {
  
  // Setup some globals
  NSString *databaseName = [self getDatabaseName];
  
  // Get the path to the documents directory and append the databaseName
  NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDir = [documentPaths objectAtIndex:0];
  NSString *databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
  
  // Execute the "checkAndCreateDatabase" function
  [self checkAndCreateDatabase :databasePath];
  
  // Setup the database object
  sqlite3 *database;
  
  bool isBookMarked = false;
  
  // Open the database from the users filessytem
  if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
    // Setup the SQL Statement and compile it for faster access
    const char *sqlStatement = [[NSString stringWithFormat:@"SELECT * FROM BookMarkMaster WHERE BookID = '%@' AND PageNumber = %d", bookID, pageNumber] UTF8String];
    sqlite3_stmt *compiledStatement;
    if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
      // Loop through the results and add them to the feeds array
      while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
        // Read the data from the result row
        isBookMarked = true;
      }
    }
    // Release the compiled statement from memory
    sqlite3_finalize(compiledStatement);
  }
  sqlite3_close(database);
  
  //isPurchased = true;
  return isBookMarked;
}

- (bool) deleteBookMark :(NSString *) bookID :(int) pageNumber {
  
  NSString *databaseName = [self getDatabaseName];
  
  // Get the path to the documents directory and append the databaseName
  NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDir = [documentPaths objectAtIndex:0];
  NSString *databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
  
  // Execute the "checkAndCreateDatabase" function
  [self checkAndCreateDatabase :databasePath];
  
  // Setup the database object
  sqlite3 *database;
  
  // Open the database from the users filessytem
  const char *dbpath = [databasePath UTF8String];
  if (sqlite3_open(dbpath, &database) == SQLITE_OK)
  {
    NSString *updateSQL = [NSString stringWithFormat:@"DELETE FROM BookMarkMaster WHERE BookID = '%@' AND PageNumber = %d", bookID, pageNumber];
    const char *update_stmt = [updateSQL UTF8String];
    sqlite3_stmt *statement;
    sqlite3_prepare_v2(database, update_stmt, -1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE)
    {
      sqlite3_finalize(statement);
      sqlite3_close(database);
      return YES;
    } else {
      sqlite3_finalize(statement);
      sqlite3_close(database);
      return NO;
    }
    //sqlite3_reset(statement);
  }
  sqlite3_close(database);
  return NO;
}

- (bool) saveBookMark :(NSString *) bookID :(int) pageNumber :(NSString *) bmDescription {
  
  NSString *databaseName = [self getDatabaseName];
  
  // Get the path to the documents directory and append the databaseName
  NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDir = [documentPaths objectAtIndex:0];
  NSString *databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
  
  // Execute the "checkAndCreateDatabase" function
  [self checkAndCreateDatabase :databasePath];
  
  // Setup the database object
  sqlite3 *database;
  
  // Open the database from the users filessytem
  const char *dbpath = [databasePath UTF8String];
  if (sqlite3_open(dbpath, &database) == SQLITE_OK)
  {
    NSString *updateSQL = [NSString stringWithFormat:@"INSERT INTO BookMarkMaster VALUES('%@',%d,'%@')", bookID, pageNumber, bmDescription];
    const char *update_stmt = [updateSQL UTF8String];
    sqlite3_stmt *statement;
    sqlite3_prepare_v2(database, update_stmt, -1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE)
    {
      sqlite3_finalize(statement);
      sqlite3_close(database);
      
      return YES;
    } else {
      sqlite3_finalize(statement);
      sqlite3_close(database);
      return NO;
    }
    //sqlite3_reset(statement);
  }
  sqlite3_close(database);
  return NO;
}


- (void) checkAndCreateDatabase :(NSString *) databasePath {
  // Check if the SQL database has already been saved to the users phone, if not then copy it over
  BOOL success;
  
  // Create a FileManager object, we will use this to check the status
  // of the database and to copy it over if required
  NSFileManager *fileManager = [NSFileManager defaultManager];
    
  // Check if the database has already been created in the users filesystem
  success = [fileManager fileExistsAtPath:databasePath];
    
  // If the database already exists then return without doing anything
  if(success) return;
    
  // If not then proceed to copy the database from the application to the users filesystem
    
  // Get the path to the database in the application package
  NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[self getDatabaseName]];
    
  // Copy the database from the package to the users filesystem
  [fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
}

- (void)showToastWithMessage:(NSString *)message inView:(UIView *)view {
    UILabel *toastLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width/2 - 150, view.frame.size.height-120, 300, 35)];
    toastLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    toastLabel.textColor = [UIColor whiteColor];
    toastLabel.textAlignment = NSTextAlignmentCenter;
    toastLabel.font = [UIFont systemFontOfSize:14];
    toastLabel.text = message;
    toastLabel.alpha = 1.0;
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds = YES;

    [view addSubview:toastLabel];

    [UIView animateWithDuration:0.5 delay:2.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        toastLabel.alpha = 0.0;
    } completion:^(BOOL finished) {
        [toastLabel removeFromSuperview];
    }];
}


//
//static NSString * const DB_NAME = @"master_v2.db";
//static NSString *DB_PATH = nil;
//static sqlite3 *ebookDatabase = NULL;
//
//+ (NSString *)dbName {
//    return DB_NAME;
//}
//
//+ (NSString *)dbPath {
//    if (DB_PATH == nil) {
//        DB_PATH = [NSString stringWithFormat:@"%@/Library/Application Support/%@", NSHomeDirectory(), DB_NAME];
//    }
//    return DB_PATH;
//}
//
//+ (void)openDatabase {
//    NSString *path = [Utilities dbPath];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    if ([fileManager fileExistsAtPath:path]) {
//        if (sqlite3_open([path UTF8String], &ebookDatabase) != SQLITE_OK) {
//            sqlite3_close(ebookDatabase);
//            NSLog(@"Failed to open database");
//        }
//    } else {
//        [Utilities copyDatabase];
//    }
//}
//
//+ (BOOL)checkDatabase {
//    NSString *path = [Utilities dbPath];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    return [fileManager fileExistsAtPath:path];
//}
//
//+ (void)copyDatabase {
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:DB_NAME ofType:nil];
//    NSString *destinationPath = [Utilities dbPath];
//    
//    NSError *error;
//    if (![fileManager fileExistsAtPath:destinationPath]) {
//        if (![fileManager copyItemAtPath:sourcePath toPath:destinationPath error:&error]) {
//            NSLog(@"Error copying database: %@", [error localizedDescription]);
//        }
//    }
//}
//
//+ (void)createDatabase {
//    if (![Utilities checkDatabase]) {
//        [Utilities copyDatabase];
//    }
//}
//
//+ (sqlite3 *)getDatabase {
//    if (ebookDatabase == NULL) {
//        [Utilities openDatabase];
//    }
//    return ebookDatabase;
//}
//
//+ (void)deleteBookMarkWithBookId:(NSString *)bookId pageNo:(int)pageNo {
//    sqlite3 *db = [Utilities getDatabase];
//    NSString *sql = @"DELETE FROM BookMarkMaster WHERE BookID = ? AND PageNumber = ?";
//    
//    sqlite3_stmt *statement;
//    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
//        sqlite3_bind_text(statement, 1, [bookId UTF8String], -1, SQLITE_TRANSIENT);
//        sqlite3_bind_int(statement, 2, pageNo);
//        
//        if (sqlite3_step(statement) != SQLITE_DONE) {
//            NSLog(@"Failed to delete bookmark");
//        }
//        sqlite3_finalize(statement);
//    }
//}
//
//+ (NSArray<BookMark *> *)getAllBookMarksForBookId:(NSString *)bookId {
//    sqlite3 *db = [Utilities getDatabase];
//    NSString *sql = @"SELECT PageNumber, PageDescription FROM BookMarkMaster WHERE BookID = ?";
//    
//    sqlite3_stmt *statement;
//    NSMutableArray<BookMark *> *bookMarkList = [NSMutableArray array];
//    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
//        sqlite3_bind_text(statement, 1, [bookId UTF8String], -1, SQLITE_TRANSIENT);
//        
//        while (sqlite3_step(statement) == SQLITE_ROW) {
//            BookMark *bookMark = [[BookMark alloc] init];
//            bookMark.bookId = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
//            bookMark.pageNo = sqlite3_column_int(statement, 1);
//            bookMark.bookMarkDesc = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
//            
//            [bookMarkList addObject:bookMark];
//        }
//        sqlite3_finalize(statement);
//    }
//    return bookMarkList;
//}
//
//+ (int)getBookMarkCount {
//    sqlite3 *db = [Utilities getDatabase];
//    NSString *sql = @"SELECT COUNT(*) FROM BookMarkMaster";
//    
//    sqlite3_stmt *statement;
//    int count = 0;
//    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
//        if (sqlite3_step(statement) == SQLITE_ROW) {
//            count = sqlite3_column_int(statement, 0);
//        }
//        sqlite3_finalize(statement);
//    }
//    return count;
//}
//
//+ (BOOL)addBookMark:(BookMark *)bookMark {
//    sqlite3 *db = [Utilities getDatabase];
//    NSString *sql = @"INSERT OR REPLACE INTO BookMarkMaster (BookID, PageNumber, PageDescription) VALUES (?, ?, ?)";
//    
//    sqlite3_stmt *statement;
//    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
//        sqlite3_bind_text(statement, 1, [bookMark.bookId UTF8String], -1, SQLITE_TRANSIENT);
//        sqlite3_bind_int(statement, 2, bookMark.pageNo);
//        sqlite3_bind_text(statement, 3, [bookMark.bookMarkDesc UTF8String], -1, SQLITE_TRANSIENT);
//        
//        if (sqlite3_step(statement) != SQLITE_DONE) {
//            NSLog(@"Failed to add bookmark");
//            sqlite3_finalize(statement);
//            return NO;
//        }
//        sqlite3_finalize(statement);
//    }
//    return YES;
//}

@end
