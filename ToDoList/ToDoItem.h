//
//  ToDoItem.h
//  ToDoList
//
//  Created by Bethany Ekimoff on 1/7/15.
//  Copyright (c) 2015 Bethany Ekimoff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToDoItem : NSObject

@property NSString *itemName;
@property BOOL completed;
@property NSDate *creationDate;

@end
