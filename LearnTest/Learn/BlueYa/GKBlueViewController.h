

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

@interface GKBlueViewController : UIViewController<GKPeerPickerControllerDelegate, GKSessionDelegate>
{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIButton *sendMsgButton;//发送数据按钮
    
    //文本框
    IBOutlet UITextField *cardTextField;
    IBOutlet UITextField *moneyTextField;
    IBOutlet UITextField *resultTextField;
}

@end
