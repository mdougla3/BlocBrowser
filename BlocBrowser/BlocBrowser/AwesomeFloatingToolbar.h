//
//  AwesomeFloatingToolbar.h
//  BlocBrowser
//
//  Created by McCay Barnes on 6/28/15.
//  Copyright (c) 2015 Change5. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AwesomeFloatingToolbar;

@protocol AwesomeFloatingToolbarDelegate <NSObject>

@optional

-(void) floatingToolbar:(AwesomeFloatingToolbar *)toolbar didSelectButtonWithTitle:(NSString *)title;
-(void) floatingToolbar:(AwesomeFloatingToolbar *)toolbar didTryToPanWithOffset:(CGPoint)offset;
-(void) floatingToolbar:(AwesomeFloatingToolbar *)toolbar didTryToPinchwithScale:(CGFloat)scale;
-(void) floatingToolbar:(AwesomeFloatingToolbar *)toolbar didLongPress:(BOOL)didPress;

@end

@interface AwesomeFloatingToolbar : UIView

-(instancetype) initWithFourTitles:(NSArray *)titles;

-(void) setEnabled:(BOOL)enabled forButtonWithTitle:(NSString *)title;

@property (nonatomic, weak) id <AwesomeFloatingToolbarDelegate> delegate;

@end
