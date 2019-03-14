//
//  UINavigationBar+MixE.h
//  MixExtention
//
//  Created by Eric Lung on 2019/3/13.
//  Copyright © 2019 Mix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBarMixExtention : NSObject

@property (nonatomic, assign) BOOL bottomLineHidden;

@end

@interface UINavigationBar (MixE)

@property (nonatomic, readonly) UINavigationBarMixExtention *mixE;

@end
