/*!
 @header    DLFontManager
 @abstract  字体下载
 @author    丁磊
 @version   1.0.1 2015/04/03 Creation
 */

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

typedef void (^DownLoadSuccess)(BOOL finished);
typedef void (^DownLoadFailed) (NSString * error);

@interface DLFontManager : NSObject

/*
    @method : shareInstance
    @func   : 单例模式
    @return : DLFontManager
 */
+ (id)shareInstance;

/*
    @method : isFontDownloaded:
    @func   : 判断字体是否已经下载，若下载返回YES，否则返回NO
    @pare   : fontName:字体名字，例如"DFWaWaSC-W5"
    @return : BOOL
 */
- (BOOL)isFontDownLoaded:(NSString *)fontName;

/*
    @method : isFontDownloaded:
    @func   : 判断字体是否已经下载，若下载返回YES，否则返回NO
    @pare   : fontName:字体名字，例如"DFWaWaSC-W5"
              successBlock:成功的回调
              failedBlock:失败的回调
    @return : BOOL
 */
- (void)downLoadFont:(NSString *)fontName success:(DownLoadSuccess)successBlock failed:(DownLoadFailed)failedBlock;
@end