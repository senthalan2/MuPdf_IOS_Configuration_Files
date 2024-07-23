
#ifdef RCT_NEW_ARCH_ENABLED
#import "RNPdfAnnotationSpec.h"
#import <React/RCTEventEmitter.h>

@interface PdfAnnotation : RCTEventEmitter <NativePdfAnnotationSpec>{
    BOOL hasListeners;
}
#else
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface PdfAnnotation : RCTEventEmitter <RCTBridgeModule>{
    BOOL hasListeners;
}
#endif

@end
