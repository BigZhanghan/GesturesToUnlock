//
//  GestureView.h
//  gesture
//
//  Created by zhanghan on 2017/12/26.
//  Copyright © 2017年 zhanghan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GestureView;

@protocol GestureDelegate <NSObject>
- (void)gestureView:(GestureView *)gesture didFinishPath:(NSString *)path;
@end

@interface GestureView : UIView
@property (nonatomic, weak) IBOutlet id<GestureDelegate> delegate;
@end
