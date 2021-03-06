//
//  AddToDoItemViewController.m
//  ToDoList
//
//  Created by Bethany Ekimoff on 1/7/15.
//  Copyright (c) 2015 Bethany Ekimoff. All rights reserved.
//

#import "AddToDoItemViewController.h"
#import "DBManager.h"

@interface AddToDoItemViewController ()

@property (nonatomic, strong) DBManager *dbManager;

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@end

@implementation AddToDoItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if(sender != self.saveButton) return;
    if(self.textField.text.length > 0){
        self.toDoItem = [[ToDoItem alloc] init];
        self.toDoItem.itemName = self.textField.text;
        self.toDoItem.completed = NO;
    }
    
    NSString *query = [NSString stringWithFormat:@"insert into todo values('%@', %d, null)", self.toDoItem.itemName, self.toDoItem.completed];

    // Execute the query.
    [self.dbManager executeQuery:query];
    
    // If the query was successfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
    }
    else{
        NSLog(@"Could not execute the query.");
    }

}


@end
