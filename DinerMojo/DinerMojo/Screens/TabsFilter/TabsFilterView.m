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
    [self.buttonMap setBottomBorderHighlightColor:[UIColor lifestyleSelected]];
    [self.buttonList setBottomBorderHighlightColor:[UIColor brandColor]];

    state = DMVenueMap;
  }
  else if([button isEqual:self.buttonList] || type == DMVenueList) {
    [self.buttonMap setBottomBorderHighlightColor:[UIColor brandColor]];
    [self.buttonList setBottomBorderHighlightColor:[UIColor lifestyleSelected]];

    state = DMVenueList;
  }
  
  if(self.delegate != nil) {
    [self.delegate didSelectTabItem:state];
  }
}

- (void)setup {
    [self.buttonMap setBackgroundColor:[UIColor restaurantsDeselected]];
    [self.buttonMap toggleInnerShadow:NO];
    [self.buttonMap setBorderWidth:0.0];
    [self.buttonList setBackgroundColor:[UIColor restaurantsDeselected]];
    [self.buttonList toggleInnerShadow:NO];
    [self.buttonList setBorderWidth:0.0];
    self.backgroundColor = [UIColor brandColor];
}

- (IBAction)selectTabAction:(id)sender {
  [self setTabTypeForButton:sender OrType:DMVenueListNone];
}

- (void)selectTabForType:(DMVenueListState)type {
  [self setTabTypeForButton:nil OrType:type];
}

@end
