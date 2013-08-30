//
//  Performance.m
//  Slate
//
//  Created by Ömer Yildiz  on 8/29/13.
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


#import "Performance.h"
#import "LeapObjectiveC.h"
#import "SlateLogger.h"


@implementation Performance {
    NSMutableArray *directionHistory;
}

@synthesize gesture;
@synthesize capturedFrames;

@synthesize averageDirection;

@synthesize id = _id;

- (id)initWithSwipeGesture:(LeapSwipeGesture *)g {
    self = [super init];
    if (self) {
        _id = g.id;
        self.averageDirection = g.direction;
        directionHistory = [[NSMutableArray alloc] initWithCapacity:50];
        [self update:g];

        SlateLogger(@"Performance(swipe, %d)", g.id);
    }
    return self;
}

- (void)update:(LeapSwipeGesture *)g {
    if (g.id != self.id) SlateLogger(@"Invalid update object %d != %d", g.id, self.id);

    self.gesture = g;
    self.capturedFrames++;

    [directionHistory addObject:g.direction];

    if (g.state == LEAP_GESTURE_STATE_STOP) {
        LeapVector *sum = [[LeapVector alloc] init];
        for (int i = 0; i < [directionHistory count]; i++) {
            sum = [sum plus:[directionHistory objectAtIndex:i]];
        }

        self.averageDirection = [sum divide:[directionHistory count]];
        [directionHistory removeAllObjects];

        SlateLogger(@"  Performed(swipe, %d): averageDirection=%@", self.id, self.averageDirection);
    }
}


@end