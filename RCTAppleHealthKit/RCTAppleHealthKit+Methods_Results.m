//
//  RCTAppleHealthKit+Methods_Results.m
//  RCTAppleHealthKit
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.

#import "RCTAppleHealthKit+Methods_Results.h"
#import "RCTAppleHealthKit+Queries.h"
#import "RCTAppleHealthKit+Utils.h"

@implementation RCTAppleHealthKit (Methods_Results)


- (void)results_getBloodGlucoseSamples:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback
{
    HKQuantityType *bloodGlucoseType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodGlucose];

    HKUnit *mmolPerL = [[HKUnit moleUnitWithMetricPrefix:HKMetricPrefixMilli molarMass:HKUnitMolarMassBloodGlucose] unitDividedByUnit:[HKUnit literUnit]];

    HKUnit *unit = [RCTAppleHealthKit hkUnitFromOptions:input key:@"unit" withDefault:mmolPerL];
    NSUInteger limit = [RCTAppleHealthKit uintFromOptions:input key:@"limit" withDefault:HKObjectQueryNoLimit];
    BOOL ascending = [RCTAppleHealthKit boolFromOptions:input key:@"ascending" withDefault:false];
    NSDate *startDate = [RCTAppleHealthKit dateFromOptions:input key:@"startDate" withDefault:nil];
    NSDate *endDate = [RCTAppleHealthKit dateFromOptions:input key:@"endDate" withDefault:[NSDate date]];
    if(startDate == nil){
        callback(@[RCTMakeError(@"startDate is required in options", nil, nil)]);
        return;
    }
    NSPredicate * predicate = [RCTAppleHealthKit predicateForSamplesBetweenDates:startDate endDate:endDate];

    [self fetchQuantitySamplesOfType:bloodGlucoseType
                                unit:unit
                           predicate:predicate
                           ascending:ascending
                               limit:limit
                          completion:^(NSArray *results, NSError *error) {
        if(results){
            callback(@[[NSNull null], results]);
            return;
        } else {
            NSLog(@"An error occured while retrieving the glucose sample %@. The error was: ", error);
            callback(@[RCTMakeError(@"An error occured while retrieving the glucose sample", error, nil)]);
            return;
        }
    }];
}

- (void)results_getInsulinDeliverySamples:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback
{
    HKQuantityType *insulinDeliveryType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierInsulinDelivery];

    HKUnit *unit = [HKUnit internationalUnit];

    NSUInteger limit = [RCTAppleHealthKit uintFromOptions:input key:@"limit" withDefault:HKObjectQueryNoLimit];
    BOOL ascending = [RCTAppleHealthKit boolFromOptions:input key:@"ascending" withDefault:false];
    NSDate *startDate = [RCTAppleHealthKit dateFromOptions:input key:@"startDate" withDefault:nil];
    NSDate *endDate = [RCTAppleHealthKit dateFromOptions:input key:@"endDate" withDefault:[NSDate date]];
    if(startDate == nil){
        callback(@[RCTMakeError(@"startDate is required in options", nil, nil)]);
        return;
    }

    NSPredicate * predicate = [RCTAppleHealthKit predicateForSamplesBetweenDates:startDate endDate:endDate];

    [self fetchQuantitySamplesOfType:insulinDeliveryType
                                unit:unit
                           predicate:predicate
                           ascending:ascending
                               limit:limit
                          completion:^(NSArray *results, NSError *error) {
        if(results){
            callback(@[[NSNull null], results]);
            return;
        } else {
            NSLog(@"An error occured while retrieving the glucose sample %@. The error was: ", error);
            callback(@[RCTMakeError(@"An error occured while retrieving the glucose sample", error, nil)]);
            return;
        }
    }];
}

- (void)results_getCarbohydratesSamples:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback
{
    HKQuantityType *carbohydratesType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryCarbohydrates];
    HKUnit *unit = [RCTAppleHealthKit hkUnitFromOptions:input key:@"unit" withDefault:[HKUnit gramUnit]];
    NSUInteger limit = [RCTAppleHealthKit uintFromOptions:input key:@"limit" withDefault:HKObjectQueryNoLimit];
    BOOL ascending = [RCTAppleHealthKit boolFromOptions:input key:@"ascending" withDefault:false];
    NSDate *startDate = [RCTAppleHealthKit dateFromOptions:input key:@"startDate" withDefault:nil];
    NSDate *endDate = [RCTAppleHealthKit dateFromOptions:input key:@"endDate" withDefault:[NSDate date]];
    if(startDate == nil){
        callback(@[RCTMakeError(@"startDate is required in options", nil, nil)]);
        return;
    }
    NSPredicate * predicate = [RCTAppleHealthKit predicateForSamplesBetweenDates:startDate endDate:endDate];

    [self fetchQuantitySamplesOfType:carbohydratesType
                                unit:unit
                           predicate:predicate
                           ascending:ascending
                               limit:limit
                          completion:^(NSArray *results, NSError *error) {
        if(results){
            callback(@[[NSNull null], results]);
            return;
        } else {
            NSLog(@"An error occured while retrieving the carbohydates sample %@. The error was: ", error);
            callback(@[RCTMakeError(@"An error occured while retrieving the carbohydates sample", error, nil)]);
            return;
        }
    }];
}

- (void)results_saveInsulinDeliverySample:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback
{
    HKQuantityType *insulinDeliveryType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierInsulinDelivery];

    HKUnit *unit = [HKUnit internationalUnit];

    double value = [RCTAppleHealthKit doubleValueFromOptions:input];
    NSDate *startDate = [RCTAppleHealthKit dateFromOptions:input key:@"startDate" withDefault:[NSDate date]];
    NSDate *endDate = [RCTAppleHealthKit dateFromOptions:input key:@"endDate" withDefault:startDate];
    NSDictionary *metadata = [RCTAppleHealthKit metadataFromOptions:input withDefault:nil];

    HKQuantity *quantity = [HKQuantity quantityWithUnit:unit doubleValue:value];
    HKQuantitySample *sample = [HKQuantitySample quantitySampleWithType:insulinDeliveryType
                                                                      quantity:quantity
                                                                     startDate:startDate
                                                                       endDate:endDate
                                                                      metadata:metadata];

    [self.healthStore saveObject:sample withCompletion:^(BOOL success, NSError *error) {
        if (!success) {
            NSLog(@"An error occured while saving the insulin sample %@. The error was: ", error);
            callback(@[RCTMakeError(@"An error occured while saving the insulin sample", error, nil)]);
            return;
        }
        callback(@[[NSNull null], [sample.UUID UUIDString]]);
    }];
}

- (void)results_saveBloodGlucoseSample:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback
{
    HKQuantityType *bloodGlucoseType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodGlucose];

    HKUnit *mmolPerL = [[HKUnit moleUnitWithMetricPrefix:HKMetricPrefixMilli molarMass:HKUnitMolarMassBloodGlucose] unitDividedByUnit:[HKUnit literUnit]];

    double value = [RCTAppleHealthKit doubleValueFromOptions:input];
    // Undocumented `date` property was used before, keeping for backwards compatibility.
    NSDate *sampleDate = [RCTAppleHealthKit dateFromOptions:input key:@"date" withDefault:[NSDate date]];
    NSDate *startDate = [RCTAppleHealthKit dateFromOptions:input key:@"startDate" withDefault:sampleDate];
    NSDate *endDate = [RCTAppleHealthKit dateFromOptions:input key:@"endDate" withDefault:startDate];
    HKUnit *unit = [RCTAppleHealthKit hkUnitFromOptions:input key:@"unit" withDefault:mmolPerL];
    NSDictionary *metadata = [RCTAppleHealthKit metadataFromOptions:input withDefault:nil];

    HKQuantity *glucoseQuantity = [HKQuantity quantityWithUnit:unit doubleValue:value];
    HKQuantitySample *glucoseSample = [HKQuantitySample quantitySampleWithType:bloodGlucoseType
                                                                      quantity:glucoseQuantity
                                                                     startDate:startDate
                                                                       endDate:endDate
                                                                      metadata:metadata];

    [self.healthStore saveObject:glucoseSample withCompletion:^(BOOL success, NSError *error) {
        if (!success) {
            NSLog(@"An error occured while saving the glucose sample %@. The error was: ", error);
            callback(@[RCTMakeError(@"An error occured while saving the glucose sample", error, nil)]);
            return;
        }
        callback(@[[NSNull null], [glucoseSample.UUID UUIDString]]);
    }];
}

- (void)results_saveCarbohydratesSample:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback
{
    HKQuantityType *carbohydratesType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryCarbohydrates];

    double value = [RCTAppleHealthKit doubleValueFromOptions:input];
    NSDate *sampleDate = [RCTAppleHealthKit dateFromOptions:input key:@"date" withDefault:[NSDate date]];
    HKUnit *unit = [RCTAppleHealthKit hkUnitFromOptions:input key:@"unit" withDefault:[HKUnit gramUnit]];
    NSDictionary *metadata = [RCTAppleHealthKit metadataFromOptions:input withDefault:nil];

    HKQuantity *carbQuantity = [HKQuantity quantityWithUnit:unit doubleValue:value];
    HKQuantitySample *carbSample = [HKQuantitySample quantitySampleWithType:carbohydratesType
                                                                   quantity:carbQuantity
                                                                  startDate:sampleDate
                                                                    endDate:sampleDate
                                                                   metadata:metadata];

    [self.healthStore saveObject:carbSample withCompletion:^(BOOL success, NSError *error) {
        if (!success) {
            NSLog(@"An error occured while saving the carbohydrate sample %@. The error was: ", error);
            callback(@[RCTMakeError(@"An error occured while saving the carbohydrate sample", error, nil)]);
            return;
        }
        callback(@[[NSNull null], [carbSample.UUID UUIDString]]);
    }];
}

- (void)results_deleteBloodGlucoseSample:(NSString *)oid callback:(RCTResponseSenderBlock)callback
{
    HKQuantityType *bloodGlucoseType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodGlucose];
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:oid];
    NSPredicate *uuidPredicate = [HKQuery predicateForObjectWithUUID:uuid];
    [self.healthStore deleteObjectsOfType:bloodGlucoseType predicate:uuidPredicate withCompletion:^(BOOL success, NSUInteger deletedObjectCount, NSError * _Nullable error) {
        if (!success) {
            NSLog(@"An error occured while deleting the glucose sample %@. The error was: ", error);
            callback(@[RCTMakeError(@"An error occured while deleting the glucose sample", error, nil)]);
            return;
        }
        callback(@[[NSNull null], @(deletedObjectCount)]);
    }];
}

// ------ Delete Carbohydrates, Protein, Fat, Energy ------
- (void)results_deleteCarbohydratesSample:(NSString *)oid callback:(RCTResponseSenderBlock)callback
{
    HKQuantityType *carbohydratesType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryCarbohydrates];
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:oid];
    NSPredicate *uuidPredicate = [HKQuery predicateForObjectWithUUID:uuid];
    [self.healthStore deleteObjectsOfType:carbohydratesType predicate:uuidPredicate withCompletion:^(BOOL success, NSUInteger deletedObjectCount, NSError * _Nullable error) {
        if (!success) {
            NSLog(@"An error occured while deleting the carbohydrate sample %@. The error was: ", error);
            callback(@[RCTMakeError(@"An error occured while deleting the carbohydrate sample", error, nil)]);
            return;
        }
        callback(@[[NSNull null], @(deletedObjectCount)]);
    }];
}

- (void)results_deleteProteinSample:(NSString *)oid callback:(RCTResponseSenderBlock)callback
{
    HKQuantityType *proteinType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryProtein];
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:oid];
    NSPredicate *uuidPredicate = [HKQuery predicateForObjectWithUUID:uuid];
    [self.healthStore deleteObjectsOfType:proteinType predicate:uuidPredicate withCompletion:^(BOOL success, NSUInteger deletedObjectCount, NSError * _Nullable error) {
        if (!success) {
            NSLog(@"❌ Error deleting protein sample: %@", error);
            callback(@[RCTMakeError(@"Error deleting protein sample", error, nil)]);
            return;
        }
        callback(@[[NSNull null], @(deletedObjectCount)]);
    }];
}

- (void)results_deleteFatSample:(NSString *)oid callback:(RCTResponseSenderBlock)callback
{
    HKQuantityType *fatType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryFatTotal];
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:oid];
    NSPredicate *uuidPredicate = [HKQuery predicateForObjectWithUUID:uuid];
    [self.healthStore deleteObjectsOfType:fatType predicate:uuidPredicate withCompletion:^(BOOL success, NSUInteger deletedObjectCount, NSError * _Nullable error) {
        if (!success) {
            NSLog(@"❌ Error deleting fat sample: %@", error);
            callback(@[RCTMakeError(@"Error deleting fat sample", error, nil)]);
            return;
        }
        callback(@[[NSNull null], @(deletedObjectCount)]);
    }];
}

- (void)results_deleteEnergySample:(NSString *)oid callback:(RCTResponseSenderBlock)callback
{
    HKQuantityType *energyType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryEnergyConsumed];
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:oid];
    NSPredicate *uuidPredicate = [HKQuery predicateForObjectWithUUID:uuid];
    [self.healthStore deleteObjectsOfType:energyType predicate:uuidPredicate withCompletion:^(BOOL success, NSUInteger deletedObjectCount, NSError * _Nullable error) {
        if (!success) {
            NSLog(@"❌ Error deleting energy sample: %@", error);
            callback(@[RCTMakeError(@"Error deleting energy sample", error, nil)]);
            return;
        }
        callback(@[[NSNull null], @(deletedObjectCount)]);
    }];
}

//----------

- (void)results_deleteInsulinDeliverySample:(NSString *)oid callback:(RCTResponseSenderBlock)callback
{
    HKQuantityType *insulinDeliveryType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierInsulinDelivery];
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:oid];
    NSPredicate *uuidPredicate = [HKQuery predicateForObjectWithUUID:uuid];
    [self.healthStore deleteObjectsOfType:insulinDeliveryType predicate:uuidPredicate withCompletion:^(BOOL success, NSUInteger deletedObjectCount, NSError * _Nullable error) {
        if (!success) {
            NSLog(@"An error occured while deleting the insulin delivery sample %@. The error was: ", error);
            callback(@[RCTMakeError(@"An error occured while deleting the insulin delivery sample", error, nil)]);
            return;
        }
        callback(@[[NSNull null], @(deletedObjectCount)]);
    }];
}

- (void)results_registerObservers:(RCTBridge *)bridge hasListeners:(bool)hasListeners
{
    if (@available(iOS 11.0, *)) {
        HKSampleType* insulinType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierInsulinDelivery];
        [self setObserverForType:insulinType type:@"InsulinDelivery" bridge:bridge hasListeners:hasListeners];
    }
}

@end
