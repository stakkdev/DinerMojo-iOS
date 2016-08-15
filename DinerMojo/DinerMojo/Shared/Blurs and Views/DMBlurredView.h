//
//  DMBlurredView.h
//  DinerMojo
//
//  Created by hedgehog lab on 11/05/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "SVBlurView.h"

@class DMBlurredView;

@protocol DMBlurredViewDelegate <NSObject>

@optional

- (void)tapFromBlurredView:(DMBlurredView *)blurredView;

@end

@interface DMBlurredView : SVBlurView

@property (weak, nonatomic) id<DMBlurredViewDelegate> delegate;

- (void)animateBlurInWithInterval:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion ;
- (void)animateBlurOutWithInterval:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion;

@end
