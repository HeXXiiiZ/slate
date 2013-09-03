//
//  Performance.h
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


#import <Foundation/Foundation.h>
#import "LeapObjectiveC.h"

@class LeapGesture;
@class LeapVector;
@class LeapSwipeGesture;

@interface Performance : NSObject {
    int _id;
    LeapGesture *gesture;
    int capturedFrames;
    LeapVector *averageDirection;
    NSString *_direction;
}

@property(nonatomic, strong) LeapGesture *gesture;
@property(nonatomic, copy) NSString *direction;

//@property(nonatomic) int capturedFrames;
//@property(nonatomic, strong) LeapVector *averageDirection;
//@property(nonatomic, readonly) int id;


+ (NSString *)directionOf:(LeapVector *)dirVector;

- (id)initWithSwipeGesture:(LeapSwipeGesture *)g;
- (void)update:(LeapSwipeGesture *)g;

+ (id)create:(LeapGestureType)type direction:(NSString *)direction;

@end