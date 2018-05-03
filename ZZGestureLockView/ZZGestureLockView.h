//
//  ZZGestureLockView.h
//  ZZGestureLockView
//
//  Created by 周兴 on 2018/5/2.
//  Copyright © 2018年 zx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ZZGestureLockItemState) {
    ZZGestureLockItemStateNormal,
    ZZGestureLockItemStateSelected,
    ZZGestureLockItemStateWarning
};

@class ZZGestureLockView;

@protocol ZZGestureLockViewDelegate <NSObject>

@optional
- (void)zzGestureLockViewDidStartWithLockView:(ZZGestureLockView *)lockView;

- (void)zzGestureLockViewDidEndWithLockView:(ZZGestureLockView *)lockView itemState:(ZZGestureLockItemState)itemState gestureResult:(NSString *)gestureResult;


@end

@interface ZZGestureLockView : UIView

@property (nonatomic, weak) id<ZZGestureLockViewDelegate>delegate;

@property (nonatomic, strong) UIColor *normalLineColor;
@property (nonatomic, strong) UIColor *warningLineColor;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat itemWidth;

@property (nonatomic, assign) NSInteger miniPasswordLength;

@end
