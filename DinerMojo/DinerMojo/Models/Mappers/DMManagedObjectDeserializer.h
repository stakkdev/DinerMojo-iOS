//
//  DMManagedObjectDeserializer.h
//  DinerMojo
//
//  Created by hedgehog lab on 27/03/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import <FastEasyMapping/FEMManagedObjectDeserializer.h>

@interface DMManagedObjectDeserializer : FEMManagedObjectDeserializer

+ (id)deserializeObjectExternalRepresentation:(NSDictionary *)externalRepresentation
                                 usingMapping:(FEMManagedObjectMapping *)mapping
                                      context:(NSManagedObjectContext *)context;

+ (NSArray *)deserializeCollectionExternalRepresentation:(NSArray *)externalRepresentation
                                            usingMapping:(FEMManagedObjectMapping *)mapping
                                                 context:(NSManagedObjectContext *)context;

@end
