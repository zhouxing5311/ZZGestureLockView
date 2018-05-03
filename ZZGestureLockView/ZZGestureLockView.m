//
//  ZZGestureLockView.m
//  ZZGestureLockView
//
//  Created by 周兴 on 2018/5/2.
//  Copyright © 2018年 zx. All rights reserved.
//

#import "ZZGestureLockView.h"

@interface ZZGestureLockItem : UIImageView

@property (nonatomic, assign) ZZGestureLockItemState itemState;
@property (nonatomic, strong) UIImage *normalImage;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) UIImage *warningImage;

- (void)setImage:(UIImage*)image forState:(ZZGestureLockItemState)itemState;

@end

@implementation ZZGestureLockItem

- (void)setImage:(UIImage *)image forState:(ZZGestureLockItemState)itemState {
    switch (itemState) {
        case ZZGestureLockItemStateNormal:
        {
            self.normalImage = image;
            //default
            self.image = self.normalImage;
        }
            break;
        case ZZGestureLockItemStateSelected:
        {
            self.selectedImage = image;
        }
            break;
        case ZZGestureLockItemStateWarning:
        {
            self.warningImage = image;
        }
            break;
        default:
            break;
    }
}

- (void)setItemState:(ZZGestureLockItemState)itemState {
    
    _itemState = itemState;
    
    switch (itemState) {
        case ZZGestureLockItemStateNormal:
        {
            self.image = self.normalImage;
        }
            break;
        case ZZGestureLockItemStateSelected:
        {
            self.image = self.selectedImage;
        }
            break;
        case ZZGestureLockItemStateWarning:
        {
            self.image = self.warningImage;
        }
            break;
        default:
            break;
    }
}

@end


@interface ZZGestureLockView ()

@property (nonatomic, strong) NSMutableArray *allItemsArray;
@property (nonatomic, strong) NSMutableArray *selectedItemsArray;
@property (nonatomic, assign) CGPoint currentPoint;
@property (nonatomic, assign) BOOL isWarning;

@end

@implementation ZZGestureLockView

- (instancetype)init {
    if (self = [super init]) {
        [self initialization];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialization];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialization];
}

- (void)initialization {
    
    self.backgroundColor = [UIColor clearColor];
    
    self.allItemsArray = [NSMutableArray array];
    self.selectedItemsArray = [NSMutableArray array];
    self.miniPasswordLength = 4;
    self.normalLineColor = [UIColor redColor];
    self.warningLineColor = [UIColor redColor];
    self.lineWidth = 4;
    self.itemWidth = 60;
    
    for (NSInteger i = 0; i < 9; i++) {
        ZZGestureLockItem *item = [[ZZGestureLockItem alloc] init];
        item.tag = i;
        
        //set image
        [item setImage:[UIImage imageNamed:@"gesture_node_normal"] forState:ZZGestureLockItemStateNormal];
        [item setImage:[UIImage imageNamed:@"gesture_node_selected"] forState:ZZGestureLockItemStateSelected];
        [item setImage:[UIImage imageNamed:@"gesture_node_warning"] forState:ZZGestureLockItemStateWarning];
        
        [self.allItemsArray addObject:item];
        [self addSubview:item];
    }
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [self addGestureRecognizer:panGesture];
}

- (void)panAction:(UIPanGestureRecognizer *)panGesture {
    
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        //begin
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(clearAllSelectedItems) object:nil];
        
        //init state
        [self clearAllSelectedItems];
        
        [self getSelectedItemWithPanGesture:panGesture];
        
        if ([self.delegate respondsToSelector:@selector(zzGestureLockViewDidStartWithLockView:)]) {
            [self.delegate zzGestureLockViewDidStartWithLockView:self];
        }
        
    } else if (panGesture.state == UIGestureRecognizerStateEnded) {
        
        if (self.selectedItemsArray.count < self.miniPasswordLength) {
            
            //make warning
            [self makeWarning];
            
            //tell the delegate
            if ([self.delegate respondsToSelector:@selector(zzGestureLockViewDidEndWithLockView:itemState:gestureResult:)]) {
                [self.delegate zzGestureLockViewDidEndWithLockView:self itemState:ZZGestureLockItemStateWarning gestureResult:@""];
            }
            
        } else {
            
            NSString *password = @"";
            //get final password
            for (NSInteger i = 0; i < self.selectedItemsArray.count; i++) {
                ZZGestureLockItem *currentItem = self.selectedItemsArray[i];
                password = [password stringByAppendingFormat:@"%d",(int)currentItem.tag];
            }
            
            //tell the delegate
            if ([self.delegate respondsToSelector:@selector(zzGestureLockViewDidEndWithLockView:itemState:gestureResult:)]) {
                [self.delegate zzGestureLockViewDidEndWithLockView:self itemState:ZZGestureLockItemStateNormal gestureResult:password];
            }
            
            [self clearAllSelectedItems];
        }
    } else {
        //moving
        [self getSelectedItemWithPanGesture:panGesture];
        
        [self setNeedsDisplay];
        
    }
}

//return the item which contains the point
- (ZZGestureLockItem *)getCurrentSelectedItemWithPoint:(CGPoint)point {
    
    for (ZZGestureLockItem *item in self.allItemsArray) {
        if (CGRectContainsPoint(item.frame, point)) {
            return item;
        }
    }
    return nil;
}

//get need selected item and make it selected
- (void)getSelectedItemWithPanGesture:(UIPanGestureRecognizer *)panGesture {
    
    CGPoint currentPoint = [panGesture locationInView:self];
    self.currentPoint = currentPoint;
    ZZGestureLockItem *currentSelectedItem = [self getCurrentSelectedItemWithPoint:currentPoint];
    if (currentSelectedItem && currentSelectedItem.itemState != ZZGestureLockItemStateSelected) {
        currentSelectedItem.itemState = ZZGestureLockItemStateSelected;
        [self.selectedItemsArray addObject:currentSelectedItem];
    }
}

- (void)makeWarning {
    
    self.isWarning = YES;
    
    for (NSInteger i = 0; i < self.selectedItemsArray.count; i++) {
        ZZGestureLockItem *currentItem = self.selectedItemsArray[i];
        currentItem.itemState = ZZGestureLockItemStateWarning;
    }
    
    //only show the line between items
    [self setNeedsDisplay];
    
    [self performSelector:@selector(clearAllSelectedItems) withObject:nil afterDelay:1];
}

- (void)clearAllSelectedItems {
    
    for (NSInteger i = 0; i < self.selectedItemsArray.count; i++) {
        ZZGestureLockItem *item = self.selectedItemsArray[i];
        item.itemState = ZZGestureLockItemStateNormal;
    }
    [self.selectedItemsArray removeAllObjects];
    self.isWarning = NO;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    if (self.selectedItemsArray.count) {

        UIBezierPath *path = [UIBezierPath bezierPath];

        for (NSInteger i = 0; i < self.selectedItemsArray.count; i++) {

            ZZGestureLockItem *currentItem = self.selectedItemsArray[i];

            if (i == 0) {
                //path begin
                [path moveToPoint:currentItem.center];
            } else {
                [path addLineToPoint:currentItem.center];
            }
        }

        if (!self.isWarning) {
            [path addLineToPoint:self.currentPoint];
        }
        
        //set line
        [path setLineWidth:self.lineWidth];
        if (self.isWarning) {
            [self.warningLineColor set];
        } else {
            [self.normalLineColor set];
        }
        
        //draw path
        [path stroke];
    }
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //get the item space
    CGFloat itemSpace = (MIN(self.bounds.size.width, self.bounds.size.height) - self.itemWidth*3)/2.0;
    
    for (NSInteger i = 0; i < self.allItemsArray.count; i++) {
        ZZGestureLockItem *item = self.allItemsArray[i];
        
        NSInteger column = i % 3;
        NSInteger row = i / 3;
        
        item.frame = CGRectMake(column*itemSpace+self.itemWidth*column, row*itemSpace+self.itemWidth*row, self.itemWidth, self.itemWidth);
    }
    
}

@end
