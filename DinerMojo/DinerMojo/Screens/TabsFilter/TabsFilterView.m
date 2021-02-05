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
  
  if([button isEqual:self.buttonMap] || type == DMVenueMap) {
      [self.buttonList toggleInnerShadow:NO];
      [self.buttonMap toggleInnerShadow:YES];
    [self.buttonMap setBackgroundColor:[UIColor lifestyleSelected]];
    [self.buttonList setBackgroundColor:[UIColor restaurantsDeselected]];
    state = DMVenueMap;
  }
  else if([button isEqual:self.buttonList] || type == DMVenueList) {
      [self.buttonList toggleInnerShadow:YES];
      [self.buttonMap toggleInnerShadow:NO];
    [self.buttonMap setBackgroundColor:[UIColor restaurantsDeselected]];
    [self.buttonList setBackgroundColor:[UIColor lifestyleSelected]];
    state = DMVenueList;
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
