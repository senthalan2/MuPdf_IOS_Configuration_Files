#import <UIKit/UIKit.h>

#undef ABS
#undef MIN
#undef MAX

#include "mupdf/fitz.h"

#import "MuDocRef.h"

@interface MuLibraryController : NSObject <UIActionSheetDelegate>
- (void) initSetup:(BOOL)isEnableAnnot continuePage:(NSNumber*)continuePage;
- (void) openDocument: (NSString*)filename;
- (void) askForPassword: (NSString*)prompt;
- (void) onPasswordOkay;
- (void) onPasswordCancel;
@end
