//
//  LPMWeakRefArray.m
//  TestWeakRef
//
//  Created by 金龙潘 on 2017/5/5.
//  Copyright © 2017年 金龙潘. All rights reserved.
//

#import "LPMWeakRefArray.h"
#import <objc/runtime.h>

@class LPMWeakRefObject;

#pragma mark - LPMDeallocBlock
@interface LPMDeallocBlock : NSObject
@property (nonatomic, copy) void (^deallocCallback)(LPMDeallocBlock *deallocBlock);
@property (nonatomic, weak) LPMWeakRefObject *obj;
@end
@implementation LPMDeallocBlock
- (void)dealloc {
    if (self.deallocCallback) {
        self.deallocCallback(self);
    }
}

@end


#pragma mark - LPMWeakRefObject
@interface LPMWeakRefObject <ObjectType>: NSObject {
    @public
    __weak ObjectType _obj;
}
@property (nonatomic, weak) ObjectType obj;
@end
@implementation LPMWeakRefObject
@end


#pragma mark - LPMWeakRefArray
@interface LPMWeakRefArray () {
    unsigned long _count;
}
@property (nonatomic, strong) NSMutableArray *array;

@end
@implementation LPMWeakRefArray

- (instancetype)init {
    if (self = [self initWithCapacity:0]) {
    }
    return self;
}

- (instancetype)initWithCapacity:(NSUInteger)capacity {
    if (self = [super init]) {
        if (capacity == 0) {
            self.array = [NSMutableArray array];
        }else{
            self.array = [NSMutableArray arrayWithCapacity:capacity];
        }
    }
    return self;
}

+ (instancetype)array {
    return [[self alloc] init];
}

+ (instancetype)arrayWithCapacity:(NSUInteger)capacity {
    return [[self alloc] initWithCapacity:capacity];
}

- (void)addObject:(id)object {
    if (!object) {
        return;
    }
    LPMWeakRefObject *weakRef = [LPMWeakRefObject new];
    weakRef.obj = object;
    [self addDeallocBlock:weakRef];
    [self.array addObject:weakRef];
    _count = self.array.count;
}

- (void)insertObject:(id)object atIndex:(NSUInteger)index {
    if (!object) {
        return;
    }
    if (index > self.count) {
        return;
    }
    LPMWeakRefObject *weakRef = [LPMWeakRefObject new];
    weakRef.obj = object;
    [self addDeallocBlock:weakRef];
    if (self.count == index) {
        
        [self.array addObject:weakRef];
    }else{
        [self.array insertObject:object atIndex:index];
    }
    _count = self.array.count;
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)object {
    if (!object) {
        return;
    }
    if (index >= self.count) {
        return;
    }
    LPMWeakRefObject *weakRef = [LPMWeakRefObject new];
    weakRef.obj = object;
    [self addDeallocBlock:weakRef];
    [self.array replaceObjectAtIndex:index withObject:object];
}

- (void)removeObject:(id)object {
    NSUInteger index = [self indexOfObject:object];
    [self removeObjectAtIndex:index];
    _count = self.array.count;
}

- (void)removeObjectAtIndex:(NSUInteger)index {
    if (index >= self.count) {
        return;
    }
    [self.array removeObjectAtIndex:index];
    _count = self.array.count;
}

- (void)removeAllObjects {
    [self.array removeAllObjects];
    _count = self.array.count;
}

- (id)objectAtIndex:(NSUInteger)index {
    if (index >= self.count) {
        return nil;
    }
    LPMWeakRefObject *weakRef = [self.array objectAtIndex:index];
    return weakRef.obj;
}

- (id)firstObject {
    return [self objectAtIndex:0];
}

- (id)lastObject {
    return [self objectAtIndex:self.count - 1];
}

- (NSUInteger)indexOfObject:(id)object {
    if (!object) {
        return NSNotFound;
    }
    NSUInteger index = NSNotFound;
    NSUInteger i = 0;
    for (LPMWeakRefObject *weakRef in self.array) {
        if (weakRef.obj == object) {
            index = i;
            break;
        }
        i ++;
    }
    _count = self.array.count;
    return index;
}

- (NSUInteger)count {
    return self.array.count;
}

- (NSString *)description {
    NSString *desc = [NSString stringWithFormat:@"<%@: %p> [\n",NSStringFromClass([self class]), self];
    for (id obj in self) {
        desc = [desc stringByAppendingFormat:@"\t%@,\n",obj];
    }
    desc = [desc stringByAppendingString:@"]"];
    return desc;
}

- (void)addDeallocBlock:(LPMWeakRefObject *)obj {
    LPMDeallocBlock *v1 = [[LPMDeallocBlock alloc] init];
    v1.obj = obj;
    v1.deallocCallback = ^(LPMDeallocBlock *block) {
        [self.array removeObject:block.obj];
        _count = self.array.count;
    };
    
    // 核心,关键,重要!
    
    void *ptr = ((__bridge void *)v1);
    
    // v1对象必须只能由object持有,使用时注意!
    
    objc_setAssociatedObject(obj.obj, ptr, v1, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//NSCopying
- (id)copyWithZone:(nullable NSZone *)zone {
    LPMWeakRefArray *arr = [LPMWeakRefArray arrayWithCapacity:self.count];
    for (id obj in self) {
        [arr addObject:obj];
    }
    return arr;
}

//NSSecureCoding
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self.array = [aDecoder decodeObjectForKey:@"array"];
    for (LPMWeakRefObject *obj in self.array) {
        [self addDeallocBlock:obj];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.array forKey:@"array"];
}

+ (BOOL)supportsSecureCoding {
    return YES;
}


//NSFastEnumeration

- (NSUInteger )countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id  _Nullable __unsafe_unretained [])buffer count:(NSUInteger)len {
    NSUInteger count = 0;
    unsigned long countOfItemsAlreadyEnumerated = state->state;
    
    if(countOfItemsAlreadyEnumerated == 0)
    {
        state->mutationsPtr = &_count;
    }
    
    
    if(countOfItemsAlreadyEnumerated < self.count)
    {
        state->itemsPtr = buffer;
        while((countOfItemsAlreadyEnumerated < self.count) && (count < len))
        {
            buffer[count] = [self objectAtIndex:countOfItemsAlreadyEnumerated];
            countOfItemsAlreadyEnumerated++;
            
            count++;
        }
    }
    else
    {
        count = 0;
    }
    state->state = countOfItemsAlreadyEnumerated;
    return count;

}

@end
