//
//  GestureView.m
//  gesture
//
//  Created by zhanghan on 2017/12/26.
//  Copyright © 2017年 zhanghan. All rights reserved.
//

#import "GestureView.h"

static int kBtnCount = 9;
static int kcolCount = 3;
static CGFloat kBtnWidth = 74;
static CGFloat kBtnHegiht = 74;
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeihgt [UIScreen mainScreen].bounds.size.height

@interface GestureView ()
@property (nonatomic, strong) NSMutableArray *selectBtns;
@property (nonatomic, assign) CGPoint currentPoint;
@end

@implementation GestureView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addButton];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self addButton];
    }
    return self;
}

- (void)addButton {
    CGFloat margin = (self.frame.size.width - kcolCount * kBtnWidth) / (kcolCount + 1);
    for (int i = 0; i < kBtnCount; i ++) {
        int row = i / kcolCount;
        int column = i % kcolCount;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.userInteractionEnabled = NO;
        button.tag = i;
        button.frame = CGRectMake(margin + (kBtnWidth + margin) * column, (kBtnHegiht + margin) * row, kBtnWidth, kBtnHegiht);
        [button setBackgroundImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];
        [self addSubview:button];
    }
    CGFloat viewHeight = (kBtnHegiht + margin) * kcolCount - margin;
    self.frame = CGRectMake(0, (kScreenHeihgt - viewHeight) / 2, kScreenWidth, viewHeight);
}

- (CGPoint)pointWithTouches:(NSSet<UITouch *> *)touches {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    return point;
}

- (UIButton *)buttonWithPoint:(CGPoint)point {
    for (UIButton *button in self.subviews) {
        if (CGRectContainsPoint(button.frame, point)) {
            return button;
        }
    }
    return nil;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIButton *button = [self buttonWithPoint:[self pointWithTouches:touches]];
    if (button && !button.selected) {
        button.selected = YES;
        [self.selectBtns addObject:button];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIButton *button = [self buttonWithPoint:[self pointWithTouches:touches]];
    if (button && !button.selected) {
        button.selected = YES;
        [self.selectBtns addObject:button];
    } else {
        self.currentPoint = [self pointWithTouches:touches];
    }
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([self.delegate respondsToSelector:@selector(gestureView:didFinishPath:)]) {
        NSMutableString *path = [NSMutableString string];
        for (UIButton *btn in self.selectBtns) {
            [path appendFormat:@"%ld",(long)btn.tag];
        }
        [self.delegate gestureView:self didFinishPath:path];
    }
    
    [self.selectBtns makeObjectsPerformSelector:@selector(setSelected:) withObject:NULL];
    [self.selectBtns removeAllObjects];
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}

- (void)drawRect:(CGRect)rect {
    if (self.selectBtns.count == 0) {
        return;
    }
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    bezierPath.lineWidth = 8;
    bezierPath.lineJoinStyle = kCGLineCapRound;
    [[UIColor colorWithRed:32/255.0 green:210/255.0 blue:254/255.0 alpha:0.5] set];
    for (NSInteger i = 0; i < self.selectBtns.count; i ++) {
        UIButton *button = self.selectBtns[i];
        if (i == 0) {
            [bezierPath moveToPoint:button.center];
        } else {
            [bezierPath addLineToPoint:button.center];
        }
    }
    [bezierPath addLineToPoint:self.currentPoint];
    [bezierPath stroke];
}

- (NSMutableArray *)selectBtns {
    if (!_selectBtns) {
        _selectBtns = [NSMutableArray array];
    }
    return _selectBtns;
}

@end

