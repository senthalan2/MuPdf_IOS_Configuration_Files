#import <Foundation/Foundation.h>
#import "PdfAnnotation.h"
#import "MuAppDelegate.h"
#import "MuDocRef.h"
#import <React/RCTLog.h>
#include "common.h"

@implementation PdfAnnotation
RCT_EXPORT_MODULE()



// Will be called when this module's first listener is added.
-(void)startObserving {
}

// Will be called when this module's last listener is removed, or on dealloc.
-(void)stopObserving {
}

- (NSArray<NSString *> *)supportedEvents {
    return @[@"onPdfPageChange",@"onCloseWithoutSave",@"onCloseWithSave"]; // Add other event names as needed
}

- (void)PdfPageChange:(NSNotification *)notification {
  NSDictionary *extractInfo = notification.userInfo;
  if (extractInfo) {
    [self sendEventWithName:@"onPdfPageChange" body:extractInfo];
  }
}

- (void)onClosePdf:(NSNotification *)notification {
  NSDictionary *extractInfo = notification.userInfo;
  if (extractInfo) {
    [self sendEventWithName:@"onCloseWithoutSave" body:extractInfo];
  }
}

- (void)onSaveClosePdf:(NSNotification *)notification {
  NSDictionary *extractInfo = notification.userInfo;
  if (extractInfo) {
    [self sendEventWithName:@"onCloseWithSave" body:extractInfo];
  }
}

RCT_EXPORT_METHOD(openPdf:(NSString *)url options:(NSDictionary *)options resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(PdfPageChange:)
                                               name:@"PAGE_NUMBER_UPDATE"
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(onClosePdf:)
                                               name:@"CLOSE"
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(onSaveClosePdf:)
                                               name:@"SAVE_CLOSE"
                                             object:nil];
  
  BOOL isEnableAnnot = YES;
  NSNumber *continuePage = nil;
  
  NSNumber *isEnableAnnotValue = [options objectForKey:@"isEnableAnnot"];
          if (isEnableAnnotValue != nil && [isEnableAnnotValue isKindOfClass:[NSNumber class]]) {
              isEnableAnnot = [isEnableAnnotValue boolValue];
          } else {
              isEnableAnnot = YES;
          }
  
  NSNumber *continuePageValue = [options objectForKey:@"continuePage"];
         if (continuePageValue != nil && [continuePageValue isKindOfClass:[NSNumber class]]) {
             continuePage = continuePageValue;
         } else {
             continuePage = nil; // Handle null case
         }

  
  dispatch_async(dispatch_get_main_queue(), ^{
          MuLibraryController *library = [[MuLibraryController alloc] init];
          queue = dispatch_queue_create("com.artifex.mupdf.queue", NULL);
          ctx = fz_new_context(NULL, NULL, 128<<20);
          fz_register_document_handlers(ctx);
          screenScale = [UIScreen mainScreen].scale;
          NSURL *convertedUrl = [NSURL URLWithString:url];
          NSString *lastPathComponent = [convertedUrl lastPathComponent];
          NSString *secondLastPathComponent = [[convertedUrl URLByDeletingLastPathComponent] lastPathComponent];
          NSString *result = [NSString stringWithFormat:@"%@/%@", secondLastPathComponent, lastPathComponent];
          NSString *filename = result;
          if (filename.length > 0) {
            [library initSetup:isEnableAnnot continuePage:continuePage];
              [library openDocument:filename];
              resolve(@"success");
          } else {
              NSLog(@"No PDF filename provided.");
              reject(@"event_failure", @"No PDF filename provided.", nil);
          }
      });
  
}

@end
