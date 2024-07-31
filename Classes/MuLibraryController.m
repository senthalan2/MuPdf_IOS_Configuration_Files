#include "common.h"
#import "MuDocumentController.h"
#import "MuLibraryController.h"

static void showAlert(NSString *msg, NSString *filename)
{
  UIAlertView *alert = [[UIAlertView alloc]
    initWithTitle: msg
    message: filename
    delegate: nil
    cancelButtonTitle: @"Okay"
    otherButtonTitles: nil];
  [alert show];
  [alert release];
}

@implementation MuLibraryController
{
  NSArray *files;
  NSTimer *timer;
  MuDocRef *doc;
  NSString *_filename;
  NSString *_filePath;
  BOOL isEnableAnnotButton,isEnableBookMarkButton;
  NSNumber *continuePageNumber;
  NSString *bookID;
  
  UIWindow *window;
  UINavigationController *navigator;
  
}


- (void) dealloc
{
  [doc release];
  [files release];
  [super dealloc];
}

- (void) initSetup:(BOOL)isEnableAnnot isEnableBookMark:(BOOL)isEnableBookMark  continuePage:(NSNumber*)continuePage bookId:(NSString*)bookId
{
   window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
   navigator = [[UINavigationController alloc] init];
  isEnableAnnotButton = isEnableAnnot;
  isEnableBookMarkButton = isEnableBookMark;
  continuePageNumber = continuePage;
  bookID = bookId;
}

- (void) openDocument: (NSString*)nsfilename
{
 
  _filePath = [[@[NSHomeDirectory(), @"Documents", nsfilename]
         componentsJoinedByString:@"/"] retain];
//  _filePath = nsfilename;
  if (_filePath == NULL) {
    showAlert(@"Out of memory in openDocument", nsfilename);
    return;
  }

  dispatch_sync(queue, ^{});

  _filename = [nsfilename retain];
  [doc release];
  doc = [[MuDocRef alloc] initWithFilename:_filePath];
  if (!doc) {
    showAlert(@"Cannot open document", nsfilename);
    return;
  }

  if (fz_needs_password(ctx, doc->doc))
    [self askForPassword: @"'%@' needs a password:"];
  else
    [self onPasswordOkay];
}

- (void) askForPassword: (NSString*)prompt
{
  UIAlertView *passwordAlertView = [[UIAlertView alloc]
    initWithTitle: @"Password Protected"
    message: [NSString stringWithFormat: prompt, _filename.lastPathComponent]
    delegate: self
    cancelButtonTitle: @"Cancel"
    otherButtonTitles: @"Done", nil];
  passwordAlertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
  [passwordAlertView show];
  [passwordAlertView release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  const char *password = [alertView textFieldAtIndex: 0].text.UTF8String;
  [alertView dismissWithClickedButtonIndex: buttonIndex animated: TRUE];
  if (buttonIndex == 1) {
    if (fz_authenticate_password(ctx, doc->doc, password))
      [self onPasswordOkay];
    else
      [self askForPassword: @"Wrong password for '%@'. Try again:"];
  } else {
    [self onPasswordCancel];
  }
}

- (void) onPasswordOkay
{
  MuDocumentController *document = [[MuDocumentController alloc] initWithFilename: _filename path:_filePath document: doc isEnableAnnot:isEnableAnnotButton isEnableBookMark:isEnableBookMarkButton continuePage:continuePageNumber bookID:bookID];
  if (document) {
    navigator.viewControllers = @[document];
    window.rootViewController = navigator;
    [document setWindowNavigationToDismiss:window navigator:navigator];
    [window makeKeyAndVisible];
    [document release];
  }
  
  [_filename release];
  [_filePath release];
}

- (void) onPasswordCancel
{
  [_filename release];
  [_filePath release];
}

@end
