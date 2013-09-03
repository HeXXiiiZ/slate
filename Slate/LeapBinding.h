//
//  LeapBinding.h
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

#import <Foundation/Foundation.h>

@class Operation;

@interface LeapBinding : NSObject {
@private
    Operation *op;
    BOOL repeat;
}

@property(nonatomic, strong) Operation *op;
@property(assign) BOOL repeat;

- (id)initWithString:(NSString *)binding;
- (BOOL)doOperation;

+ (NSString *)getGestureFromString:(NSString *)gesture;

@end