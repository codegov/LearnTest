/*!
 @header    DLFontManager
 @abstract  字体下载
 @author    丁磊
 @version   1.0.1 2015/04/03 Creation
 */

#import "DLFontManager.h"
#import <CoreText/CoreText.h>

@implementation DLFontManager
{
    NSString *_errorMessage;
    DownLoadSuccess _successBlock;
    DownLoadFailed _failedBlock;
}

+ (id)shareInstance
{
    static DLFontManager *_instance = nil;
    static dispatch_once_t onectoken;
    dispatch_once(&onectoken, ^{
        _instance = [[DLFontManager alloc] init];
    });
    return _instance;
}

- (BOOL)isFontDownLoaded:(NSString *)fontName
{
    UIFont *font = [UIFont fontWithName:fontName size:12.0];
    if (font &&
            ([font.fontName compare:fontName] == NSOrderedSame
                    || [font.familyName compare:fontName] == NSOrderedSame))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)downLoadFont:(NSString *)fontName success:(DownLoadSuccess)successBlock failed:(DownLoadFailed)failedBlock
{

    _successBlock = successBlock;
    _failedBlock = failedBlock;

    // 用字体的PoatScript名字创建一个Dictionary
    NSMutableDictionary *attrs = [NSMutableDictionary dictionaryWithObjectsAndKeys:fontName, kCTFontNameAttribute, nil];

    // 创建一个字体描述对象CTFontDeacriptorRef
    CTFontDescriptorRef desc = CTFontDescriptorCreateWithAttributes((__bridge CFDictionaryRef)attrs);

    // 将字体描述对象放到一个NSmutableArray中
    NSMutableArray *descs = [NSMutableArray arrayWithCapacity:0];
    [descs addObject:(__bridge id)desc];
    CFRelease(desc);


    __block BOOL errorDuringDownload = NO;
    __block DownLoadSuccess __successBlock = _successBlock;
    __block DownLoadFailed __failedBlock = _failedBlock;
    // Start processing the font descriptor..
    // This function returns immediately, but can potentially take long time to process.
    // The progress is notified via the callback block of CTFontDescriptorProgressHandler type.
    // See CTFontDescriptor.h for the list of progress states and keys for progressParameter dictionary.
    CTFontDescriptorMatchFontDescriptorsWithProgressHandler( (__bridge CFArrayRef)descs, NULL,  ^(CTFontDescriptorMatchingState state, CFDictionaryRef progressParameter) {

        //NSLog( @"state %d - %@", state, progressParameter);

        double progressValue = [[(__bridge NSDictionary *)progressParameter objectForKey:(id)kCTFontDescriptorMatchingPercentage] doubleValue];

        if (state == kCTFontDescriptorMatchingDidBegin) {
            dispatch_async( dispatch_get_main_queue(), ^ {
                // Show an activity indicator
                NSLog(@"Begin Matching");
            });
        } else if (state == kCTFontDescriptorMatchingDidFinish) {
            dispatch_async( dispatch_get_main_queue(), ^ {
                // Log the font URL in the console
                CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)fontName, 0., NULL);
                CFStringRef fontURL = CTFontCopyAttribute(fontRef, kCTFontURLAttribute);
//                NSLog(@"%@", (__bridge NSURL*)(fontURL));
                CFRelease(fontURL);
                CFRelease(fontRef);

                if (!errorDuringDownload) {
                    NSLog(@"%@ downloaded", fontName);
//                    [[APPUserDefaults instance] setFontname:fontName];
                    if (__successBlock)
                    {
                        __successBlock(YES);
                    }
                }
            });
        } else if (state == kCTFontDescriptorMatchingWillBeginDownloading) {
            dispatch_async( dispatch_get_main_queue(), ^ {
                // Show a progress bar
                NSLog(@"Begin Downloading");
            });
        } else if (state == kCTFontDescriptorMatchingDidFinishDownloading) {
            dispatch_async( dispatch_get_main_queue(), ^ {
                // Remove the progress bar
                NSLog(@"Finish downloading");
                if (__successBlock)
                {
                    __successBlock(YES);
                }
            });
        } else if (state == kCTFontDescriptorMatchingDownloading) {
            dispatch_async( dispatch_get_main_queue(), ^ {
                // Use the progress bar to indicate the progress of the downloading
                NSLog(@"Downloading %.0f%% complete", progressValue);
            });
        } else if (state == kCTFontDescriptorMatchingDidFailWithError) {
            // An error has occurred.
            // Get the error message
            NSError *error = [(__bridge NSDictionary *)progressParameter objectForKey:(id)kCTFontDescriptorMatchingError];
            if (error != nil) {
                _errorMessage = [error description];
            } else {
                _errorMessage = @"ERROR MESSAGE IS NOT AVAILABLE!";
            }
            // Set our flag
            errorDuringDownload = YES;

            if (__failedBlock)
            {
                __failedBlock(_errorMessage);
            }
            dispatch_async( dispatch_get_main_queue(), ^ {
                NSLog(@"Download error: %@", _errorMessage);
            });
        }

        return (bool)YES;
    });
}

@end