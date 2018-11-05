//
//  UINavigationItem+Mix.h
//  MixRoute
//
//  Created by Eric Lung on 2018/11/5.
//  Copyright © 2018年 YOOEE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationItem (MixRoute)

/* You may specify the font, text color, and shadow properties for the title in the text attributes dictionary, using the keys found in NSAttributedString.h.
 */
@property (nonatomic, strong) NSDictionary *mix_titleTextAttributes;

@property (nonatomic, copy) UIColor *mix_barTintColor;

@property (nonatomic, strong) NSNumber *mix_barHidden;

@property (nonatomic, assign) BOOL mix_disableInteractivePopGesture;

@property (nonatomic, strong) NSNumber *mix_statusBarStyle;

@end
