//
//  TabsFilterView.h
//  DinerMojo
//
//  Created by Mike Mikina on 11/30/16.
//  Copyright © 2016 hedgehog lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMNewsItemModelController.h"
#import "DMVenueModelController.h"

@protocol TabsFilterViewDelegate <NSObject>
@optional
- (void)didSelectTabItem:(DMVenueListState)item;
@end


@interface TabsFilterView : UIView

@property (weak, nonatomic) IBOutlet DMButton *buttonAll;
@property (weak, nonatomic) IBOutlet DMButton *buttonRestaurants;
@property (weak, nonatomic) IBOutlet DMButton *buttonOthers;
@property (nonatomic, weak) id <TabsFilterViewDelegate> delegate;

- (void)selectTabForType:(DMVenueListState)type;

@end
