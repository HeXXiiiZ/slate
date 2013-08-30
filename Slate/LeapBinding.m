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
//        [self setOperationAndRepeatFromString:[tokens objectAtIndex:2]];
    }

    return self;
}

- (BOOL)doOperation {
    return NO;
}

- (void)setGestureFromString:(NSString*)gesture {

}

+ (LeapGesture *)getGestureFromString:(NSString *)gesture {
    return nil;
}

@end