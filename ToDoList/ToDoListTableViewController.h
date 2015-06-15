//
//  ToDoListTableViewController.h
//  ToDoList
//
//  Created by Bethany Ekimoff on 1/7/15.
//  Copyright (c) 2015 Bethany Ekimoff. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToDoListTableViewController : UITableViewController
- (IBAction)unwindToList:(UIStoryboardSegue *)segue;

@property (weak, nonatomic) IBOutlet UITableView *tblTodo;

- (IBAction)addNewRecord:(id)sender;

@end
