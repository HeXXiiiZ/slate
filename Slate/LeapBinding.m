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


@implementation LeapBinding {

}
@synthesize op;
@synthesize repeat;

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
    return NO;
}

- (void)setGestureFromString:(NSString *)gesture {
    performance = [Performance create:LEAP_GESTURE_TYPE_SWIPE direction:LEAP_GESTURE_DIRECTION_LEFT];
    
    // TODO parse _gesture string
    // TODO implement equals method for performance
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