//
//  CustomAnnotationView.m
//  DinerMojo
//
//  Created by James Shaw on 05/02/2021.
//  Copyright © 2021 hedgehog lab. All rights reserved.
//

#import "CustomAnnotationView.h"

static NSString *identifier = @"com.domain.clusteringIdentifier";

@implementation CustomAnnotationView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier])) {
        self.clusteringIdentifier = identifier;
        self.collisionMode = MKAnnotationViewCollisionModeCircle;
        self.canShowCallout = YES;
        self.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }

    return self;
}

- (void)setAnnotation:(id<MKAnnotation>)annotation {
    [super setAnnotation:annotation];

    self.clusteringIdentifier = identifier;
    self.canShowCallout = YES;
}

@end
