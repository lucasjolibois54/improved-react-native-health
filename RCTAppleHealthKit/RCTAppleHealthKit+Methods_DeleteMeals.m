// RCTAppleHealthKit+Methods_DeleteMeals.m

#import "RCTAppleHealthKit+Methods_DeleteMeals.h"

@implementation RCTAppleHealthKit (Methods_DeleteMeals)

- (void)deleteMealById:(NSString *)mealId callback:(RCTResponseSenderBlock)callback {
    if (!mealId) {
        callback(@[@"Meal ID is required", [NSNull null]]);
        return;
    }

    NSArray *identifiers = @[
        HKQuantityTypeIdentifierDietaryEnergyConsumed,
        HKQuantityTypeIdentifierDietaryProtein,
        HKQuantityTypeIdentifierDietaryCarbohydrates,
        HKQuantityTypeIdentifierDietaryFatTotal
    ];

    dispatch_group_t group = dispatch_group_create();
    __block BOOL allSucceeded = YES;

    for (NSString *idStr in identifiers) {
        HKQuantityType *type = [HKObjectType quantityTypeForIdentifier:idStr];
        NSPredicate *predicate = [HKQuery predicateForObjectsWithMetadataKey:@"mealId" allowedValues:@[mealId]];

        dispatch_group_enter(group);

        [self.healthStore deleteObjectsOfType:type predicate:predicate withCompletion:^(BOOL success, NSUInteger deletedCount, NSError * _Nullable error) {
            if (!success || error) {
                NSLog(@"Failed to delete %@: %@", idStr, error.localizedDescription);
                allSucceeded = NO;
            }
            dispatch_group_leave(group);
        }];
    }

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (allSucceeded) {
            callback(@[[NSNull null], @(1)]);
        } else {
            callback(@[@"Failed to delete one or more nutrients", @(0)]);
        }
    });
}

@end
