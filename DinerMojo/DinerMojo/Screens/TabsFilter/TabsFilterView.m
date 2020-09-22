//
//  TabsFilterView.m
//  DinerMojo
//
//  Created by Mike Mikina on 11/30/16.
//  Copyright © 2016 hedgehog lab. All rights reserved.
//

#import "TabsFilterView.h"
#import "DMNewsItemModelController.h"

@implementation TabsFilterView

- (void)setTabTypeForButton:(DMButton*)button OrType:(DMVenueListState)type {
  DMVenueListState state = DMVenueListAll;
  
  if([button isEqual:self.buttonRestaurants] || type == DMVenueListDining) {
      [self.buttonOthers toggleInnerShadow:NO];
      [self.buttonRestaurants toggleInnerShadow:YES];
    [self.buttonRestaurants setBackgroundColor:[UIColor lifestyleSelected]];
    [self.buttonOthers setBackgroundColor:[UIColor restaurantsDeselected]];
    state = DMVenueListDining;
  }
  else if([button isEqual:self.buttonOthers] || type == DMVenueListLifestyle) {
      [self.buttonOthers toggleInnerShadow:YES];
      [self.buttonRestaurants toggleInnerShadow:NO]; 
    [self.buttonRestaurants setBackgroundColor:[UIColor restaurantsDeselected]];
    [self.buttonOthers setBackgroundColor:[UIColor lifestyleSelected]];
    state = DMVenueListLifestyle;
  }
  
  if(self.delegate != nil) {
    [self.delegate didSelectTabItem:state];
  }
}

- (IBAction)selectTabAction:(id)sender {
  [self setTabTypeForButton:sender OrType:DMVenueListNone];
}

- (void)selectTabForType:(DMVenueListState)type {
  [self setTabTypeForButton:nil OrType:type];
}

@end
