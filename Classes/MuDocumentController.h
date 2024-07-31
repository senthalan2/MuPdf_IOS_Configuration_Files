#import <UIKit/UIKit.h>

#undef ABS
#undef MIN
#undef MAX

#include "mupdf/fitz.h"

#import "MuOutlineController.h"
#import "MuDocRef.h"
#import "MuDialogCreator.h"
#import "MuUpdater.h"
#import "BookMarkViewController.h"

enum
{
  BARMODE_MAIN,
  BARMODE_SEARCH,
  BARMODE_MORE,
  BARMODE_ANNOTATION,
  BARMODE_HIGHLIGHT,
  BARMODE_UNDERLINE,
  BARMODE_STRIKE,
  BARMODE_INK,
  BARMODE_DELETE
};

@interface MuDocumentController : UIViewController <UIScrollViewDelegate, UIGestureRecognizerDelegate, UISearchBarDelegate, MuDialogCreator, MuUpdater>
- (instancetype) initWithFilename: (NSString*)nsfilename path:(NSString *)path document:(MuDocRef *)aDoc isEnableAnnot:(BOOL) isEnableAnnot isEnableBookMark:(BOOL) isEnableBookMark continuePage:(NSNumber *) continuePage bookID:(NSString*)bookID;
- (void) createPageView: (int)number;
- (void) gotoPage: (int)number animated: (BOOL)animated;
- (void) hideShowBookMarkListButton: (BOOL) isHide;
- (void) onPageNumberChanged:(int)pageNumber;
- (void) onShowOutline: (id)sender;
- (void) onShowSearch: (id)sender;
- (void) onCancel: (id)sender;
- (void) resetSearch;
- (void) showSearchResults: (int)count forPage: (int)number;
- (void) onSlide: (id)sender;
- (void) onTap: (UITapGestureRecognizer*)sender;
- (void) showNavigationBar;
- (void) hideNavigationBar;
- (void) setWindowNavigationToDismiss:(UIWindow*) window navigator:(UINavigationController *)navigator;
@property (nonatomic, retain) BookMarkViewController *bookMarkViewController;
@end
