//
//  DMMapViewController.h
//  DinerMojo
//
//  Created by hedgehog lab on 27/04/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMTabBarViewController.h"
#import "DMLocationServices.h"
#import "MapKit/MapKit.h"
#import "CustomAnnotationView.h"
#import "VenueCollectionViewCell.h"

@import MapKit;

@interface DMMapViewController : DMTabBarViewController <UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    IBOutlet UITableView *restaurantsTableView;
    IBOutlet MKMapView *mapView;
    IBOutlet UICollectionView *collectionView;
    IBOutlet UITableView *suggestionsTableView;
}

@property BOOL showOverlay;
@property BOOL collectionViewCellSelected;
@property BOOL limitAnnotationsWarningDisplayed;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *downloadLabel;

@end

