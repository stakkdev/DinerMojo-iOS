//
//  OUManagedObjectDeserializer.m
//  DinerMojo
//
//  Created by hedgehog lab on 27/03/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMManagedObjectDeserializer.h"
#import <CoreData/CoreData.h>

@implementation DMManagedObjectDeserializer

+(id)deserializeObjectExternalRepresentation:(NSDictionary *)externalRepresentation
                                 usingMapping:(FEMManagedObjectMapping *)mapping
                                      context:(NSManagedObjectContext *)context;
{
    id returnObject = [super deserializeObjectExternalRepresentation:externalRepresentation usingMapping:mapping context:context];
    
    [context MR_saveToPersistentStoreAndWait];
    
    return returnObject;
}

+(NSArray *)deserializeCollectionExternalRepresentation:(NSArray *)externalRepresentation
                                            usingMapping:(FEMManagedObjectMapping *)mapping
                                                 context:(NSManagedObjectContext *)context;
{
    NSArray *returnArray = [super deserializeCollectionExternalRepresentation:externalRepresentation usingMapping:mapping context:context];
    
    [context MR_saveToPersistentStoreAndWait];
    
    return returnArray;
}

@end
