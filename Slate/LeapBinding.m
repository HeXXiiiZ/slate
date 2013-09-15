//
//  LeapBinding.m
//  Slate
//
//  Created by Ömer Yildiz  on 8/28/13.
//  Copyright 2013 Ömer Yildiz. All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see http://www.gnu.org/licenses

#import "LeapBinding.h"
#import "StringTokenizer.h"
#import "LeapObjectiveC.h"
#import "SlateLogger.h"
#import "Performance.h"
#import "Operation.h"
#import "SwitchOperation.h"
#import "Constants.h"
#import "Performance.h"
#import "LeapConstants.h"
#import "SlateConfig.h"


@implementation LeapBinding {

}
@synthesize op;
@synthesize repeat;
@synthesize performance;

- (id)initWithString:(NSString *)binding {
    self = [self init];
    if (self) {
        // leap <gesture> <op> <parameters>
        NSMutableArray *tokens = [[NSMutableArray alloc] initWithCapacity:10];
        [StringTokenizer tokenize:binding into:tokens maxTokens:3];
        if ([tokens count] <=2) {
            @throw([NSException exceptionWithName:@"Unrecognized Bind" reason:binding userInfo:nil]);
        }

        [self setGestureFromString:[tokens objectAtIndex:1]];
        [self setOperationFromString:[tokens objectAtIndex:2]];
    }

    return self;
}

- (BOOL)doOperation {
    // TODO avoid code duplication
    @try {
        return [op doOperation];
    } @catch (NSException *ex) {
        SlateLogger(@"   ERROR %@",[ex name]);
        NSAlert *alert = [SlateConfig warningAlertWithKeyEquivalents: [NSArray arrayWithObjects:@"Quit", @"Skip", nil]];
        [alert setMessageText:[ex name]];
        [alert setInformativeText:[ex reason]];
        if ([alert runModal] == NSAlertFirstButtonReturn) {
            SlateLogger(@"User selected exit");
            [NSApp terminate:nil];
        }
    }

    return NO;
}

- (void)setGestureFromString:(NSString *)gStr {
    NSArray *comps = [gStr componentsSeparatedByString:COLON];
    
    if (comps.count != 2) {
        NSString *reason = [NSString stringWithFormat:@"Unrecognized gesture \"%@\"", gStr];
        SlateLogger(@"ERROR: %@", reason);
        @throw([NSException exceptionWithName:@"Unrecognized gesture" reason:reason userInfo:nil]);
    } 
    
    NSString *gesture = [comps objectAtIndex:0];
    NSString *modifiers = [comps objectAtIndex:1];
    NSArray *modifiersArray = [modifiers componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@",;"]];
    LeapGestureType gestureType = [self getGestureTypeFromString:gesture];
    
//    performance = [[Performance alloc] initWithGestureType:gestureType modifiers:modifiersArray];
    performance = [[Performance alloc] initWithGestureType:gestureType direction:[modifiersArray objectAtIndex:0]]; 
}

- (LeapGestureType)getGestureTypeFromString:(NSString *)type {
    if ([@"swipe" isEqualToString:type]) {
        return LEAP_GESTURE_TYPE_SWIPE;
    } else if ([@"screenTap" isEqualToString:type]) {
        return LEAP_GESTURE_TYPE_SCREEN_TAP;
    } else if ([@"keyTap" isEqualToString:type]) {
        return LEAP_GESTURE_TYPE_KEY_TAP;
    } else if ([@"circle" isEqualToString:type]) {
        return LEAP_GESTURE_TYPE_CIRCLE;
    }

    NSString *reason = [NSString stringWithFormat:@"Unrecognized leap gesture type '%@'", type];
    SlateLogger(@"ERROR: %@", reason);
    @throw([NSException exceptionWithName:@"Unrecognized gesture type" reason:reason userInfo:nil]);
}

- (void)setOperationFromString:(NSString *)token {
    NSMutableString *opStr = [[NSMutableString alloc] initWithCapacity:10];
    [StringTokenizer firstToken:token into:opStr];

    // TODO avoid code duplication: copied from Binding.m
    Operation *theOp = [Operation operationFromString:token];
    if (theOp == nil) {
        SlateLogger(@"ERROR: Unable to create binding");
        @throw([NSException exceptionWithName:@"Unable To Create Binding" reason:[NSString stringWithFormat:@"Unable to create '%@'", token] userInfo:nil]);
    }

    @try {
        [theOp testOperation];
    } @catch (NSException *ex) {
        SlateLogger(@"ERROR: Unable to test binding '%@'", token);
        @throw([NSException exceptionWithName:@"Unable To Parse Binding" reason:[NSString stringWithFormat:@"Unable to parse '%@' in '%@'", [ex reason], token] userInfo:nil]);
    }

    op = theOp;
}

@end