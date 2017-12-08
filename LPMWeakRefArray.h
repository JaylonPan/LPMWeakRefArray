//
//  LPMWeakRefArray.h
//  TestWeakRef
//
//  Created by 金龙潘 on 2017/5/5.
//  Copyright © 2017年 金龙潘. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPMWeakRefArray<ObjectType>: NSObject<NSCopying, NSSecureCoding, NSFastEnumeration>
- (instancetype)initWithCapacity:(NSUInteger)capacity;
+ (instancetype)array;
+ (instancetype)arrayWithCapacity:(NSUInteger)capacity;

- (void)addObject:(ObjectType)object;
- (void)insertObject:(ObjectType)object atIndex:(NSUInteger)index;
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(ObjectType)object;
- (void)removeObject:(ObjectType)object;
- (void)removeObjectAtIndex:(NSUInteger)index;
- (void)removeAllObjects;
- (ObjectType)objectAtIndex:(NSUInteger)index;
- (ObjectType)firstObject;
- (ObjectType)lastObject;
- (NSUInteger)indexOfObject:(ObjectType)object;
- (NSUInteger)count;
@end
