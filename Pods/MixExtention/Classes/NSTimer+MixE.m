
//
//  NSTimer+MixE.m
//  MixExtention
//
//  Created by Eric Lung on 2019/3/13.
//  Copyright © 2019 Mix. All rights reserved.
//

#import "NSTimer+MixE.h"
#import <objc/runtime.h>

@interface NSTimerMixExtention ()

@property (nonatomic, weak) NSTimer *timer;

@property (nonatomic, copy) void (^timerBlock)(NSTimer *timer);

@end

@implementation NSTimerMixExtention

- (instancetype)initWithTimer:(NSTimer *)timer
{
    if (self = [super init]) {
        self.timer = timer;
    }
    return self;
}

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti repeats:(BOOL)yesOrNo block:(void (^)(NSTimer *timer))block
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:ti target:self selector:@selector(timerHandle:) userInfo:nil repeats:yesOrNo];
    timer.mixE.timerBlock = block;
    return timer;
}

+ (void)timerHandle:(NSTimer *)timer
{
    if (timer.mixE.timerBlock) timer.mixE.timerBlock(timer);
}

@end

@implementation NSTimer (MixE)

- (NSTimerMixExtention *)mixE
{
    id obj = objc_getAssociatedObject(self, _cmd);
    if (!obj) {
        obj = [[NSTimerMixExtention alloc] initWithTimer:self];
        objc_setAssociatedObject(self, _cmd, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return obj;
}

@end
