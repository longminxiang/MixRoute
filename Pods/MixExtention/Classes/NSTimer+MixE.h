//
//  NSTimer+MixE.h
//  MixExtention
//
//  Created by Eric Lung on 2019/3/13.
//  Copyright © 2019 Mix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimerMixExtention : NSObject

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti repeats:(BOOL)yesOrNo block:(void (^)(NSTimer *timer))block;

@end

@interface NSTimer (MixE)

@property (nonatomic, readonly) NSTimerMixExtention *mixE;

@end
