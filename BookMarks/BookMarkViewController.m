//
//  BookMarkViewController.m
//  EasySample
//
//  Created by Marian PAUL on 12/06/12.
//  Copyright (c) 2012 Marian PAUL aka ipodishima — iPuP SARL. All rights reserved.
//

#import "BookMarkViewController.h"

@interface BookMarkViewController ()

@end

@implementation BookMarkViewController{
  UIWindow *windowThis;
  UINavigationController *navigatorThis;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
  utilities = [Utilities getInstance];
	
	toDeleteBookMarks = [[NSMutableArray alloc] init];
    
    bookMarkArray = [utilities getAllBookMarks:self.bookId];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(markToDeleteBookMark:) name:@"MARK_TO_DELETE_BOOK_MARK" object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unmarkToDeleteBookMark:) name:@"UNMARK_TO_DELETE_BOOK_MARK" object:nil];
  [self showHideDeleteButton];
}

- (void)setWindowNavigationToDismiss:(UIWindow *)window navigator:(UINavigationController *)navigator
{
  windowThis = window;
  navigatorThis = navigator;
}

- (BOOL)isToDeleteBookMarksEmpty {
    return toDeleteBookMarks == nil || [toDeleteBookMarks count] == 0;
}
- (BOOL)isBookMarksListEmpty {
    return bookMarkArray == nil || [bookMarkArray count] == 0;
}

- (void)showHideDeleteButton {
    if([self isToDeleteBookMarksEmpty]){
      deleteButton.hidden = YES;
     
    }
    else{
      deleteButton.hidden = NO;
    }
  if([self isBookMarksListEmpty]){
    noDataLabel.hidden = NO;
    NSDictionary *myData = @{@"isHide" :@(YES)};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HIDE_SHOW_BOOKMARK_LIST_BUTTON" object:nil userInfo:myData];
  }
  else{
    noDataLabel.hidden = YES;
    NSDictionary *myData = @{@"isHide" :@(NO)};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HIDE_SHOW_BOOKMARK_LIST_BUTTON" object:nil userInfo:myData];
  }
}


- (void) markToDeleteBookMark :(NSNotification *) notification {
	NSDictionary *bookMarkInfo = notification.userInfo;
	NSString *pageNumber = [bookMarkInfo objectForKey:@"page_number"];
	
	[toDeleteBookMarks addObject:pageNumber];
  [self showHideDeleteButton];
  
}

- (void) unmarkToDeleteBookMark :(NSNotification *) notification {
	
	NSDictionary *bookMarkInfo = notification.userInfo;
	NSString *pageNumber = [bookMarkInfo objectForKey:@"page_number"];
	
	[toDeleteBookMarks removeObject:pageNumber];
  [self showHideDeleteButton];
}

- (IBAction) deleteSelectedBookmarks :(id)sender {
	if ([toDeleteBookMarks count] > 0) {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Delete Bookmarks"
                                                                             message:@"Are you sure you want to delete the selected bookmarks?"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes"
                                                        style:UIAlertActionStyleDestructive
                                                      handler:^(UIAlertAction *action) {
        for (int index = 0; index < [toDeleteBookMarks count]; index++) {
            [utilities deleteBookMark:self.bookId :(int) [[toDeleteBookMarks objectAtIndex:index] integerValue]];
        }
        
        bookMarkArray = [utilities getAllBookMarks:self.bookId];
        [bookMarkTableView reloadData];
      [toDeleteBookMarks removeAllObjects];
      [self showHideDeleteButton];
      
    }];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No"
                                                       style:UIAlertActionStyleCancel
                                                     handler:nil];
    [alertController addAction:yesAction];
    [alertController addAction:noAction];
    [self presentViewController:alertController animated:YES completion:nil];
		
	} else {
    [utilities showToastWithMessage :NSLocalizedString(@"Please tick atleast one bookmark to delete", @"") inView:self.view];
	}
  
  
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([utilities.xibPostfix caseInsensitiveCompare:@"iPad"] == NSOrderedSame) {
		return 60.0;
	} else if ([utilities.xibPostfix caseInsensitiveCompare:@"iPhone6"] == NSOrderedSame) {
		return 60.0;
	} else if ([utilities.xibPostfix caseInsensitiveCompare:@"iPhone6s"] == NSOrderedSame) {
		return 60.0;
	} else if ([utilities.xibPostfix caseInsensitiveCompare:@"iPhoneX"] == NSOrderedSame) {
		return 60.0;
	}
	return 42.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [bookMarkArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    BookMarkTableViewCell *cell = [bookMarkTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //if (!cell) {
        cell = [[BookMarkTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier bookMarkDetails:[bookMarkArray objectAtIndex:indexPath.row]];
	//}
    
    return cell;
}

- (IBAction) returnBack :(id)sender {
	[self.view removeFromSuperview];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSMutableArray *bookMarkDetails = [bookMarkArray objectAtIndex:indexPath.row];

	NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[bookMarkDetails objectAtIndex:1], @"page_number", nil];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"GO_TO_PAGE" object:self userInfo:userInfo];
	
	[self.view removeFromSuperview];
	
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)dealloc {
    [deleteButton release];
    [noDataLabel release];
    [super dealloc];
}
@end
