//
//  ToDoListTableViewController.m
//  ToDoList
//
//  Created by Bethany Ekimoff on 1/7/15.
//  Copyright (c) 2015 Bethany Ekimoff. All rights reserved.
//

#import "ToDoListTableViewController.h"
#import "ToDoItem.h"
#import "AddToDoItemViewController.h"
#import "DBManager.h"

@interface ToDoListTableViewController ()

@property (nonatomic, strong) DBManager *dbManager;

@property (nonatomic, strong) NSArray *arrToDoItem;

@property (nonatomic) int recordIDToEdit;

@property (nonatomic) NSMutableArray *toDoItems;

-(void)loadData;

@end

@implementation ToDoListTableViewController

- (IBAction)unwindToList:(UIStoryboardSegue *)segue {
    AddToDoItemViewController *source = [segue sourceViewController];
    ToDoItem *item = source.toDoItem;
    if(item != nil) {
        [self.toDoItems addObject:item];
        [self.tableView reloadData];
    }
    
    //Add item to database.
    NSString *query = [NSString stringWithFormat:@"insert into todo values('%@', 'NO', null)", item.itemName];
    
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

- (IBAction)addNewRecord:(id)sender {
    // Before performing the segue, set the -1 value to the recordIDToEdit. That way we'll indicate that we want to add a new record and not to edit an existing one.
    self.recordIDToEdit = -1;
    
    // Perform the segue.
    [self performSegueWithIdentifier:@"idSegueEditInfo" sender:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tblTodo.delegate = self;
    self.tblTodo.dataSource = self;
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"todo.db"];
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData{
    // Form the query.
    NSString *query = @"select * from todo";
    
    // Get the results.
    if (self.arrToDoItem != nil) {
        self.arrToDoItem = nil;
    }
    self.arrToDoItem = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    self.toDoItems = [self.arrToDoItem mutableCopy];
    
    // Reload the table view.
    [self.tblTodo reloadData];
}


//- (void)loadInitialData {
//    
//    NSArray *array = [[self.userDefaults arrayForKey:@"toDoListArray"] mutableCopy];
//    for (NSString *name in array){
//        ToDoItem *item = [[ToDoItem alloc] init];
//        item.itemName = name;
//        [self.toDoItems addObject:item];
//    }
//        
//    if (!self.toDoItems || !self.toDoItems.count) {
//        ToDoItem *item1 = [[ToDoItem alloc] init];
//        item1.itemName = @"Buy milk";
//        [self.toDoItems addObject:item1];
//        ToDoItem *item2 = [[ToDoItem alloc] init];
//        item2.itemName = @"Buy Eggs";
//        [self.toDoItems addObject:item2];
//        ToDoItem *item3 = [[ToDoItem alloc] init];
//        item3.itemName = @"Walk Dog";
//        [self.toDoItems addObject:item3];
//    }
//    
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.arrToDoItem.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListPrototypeCell" forIndexPath:indexPath];
    
    NSInteger indexOfItemName = [self.dbManager.arrColumnNames indexOfObject:@"itemName"];
    NSInteger indexOfComplete = [self.dbManager.arrColumnNames indexOfObject:@"complete"];
    NSInteger indexOfdateCreated = [self.dbManager.arrColumnNames indexOfObject:@"dateCreated"];
    
    ToDoItem *toDoItem = [[ToDoItem alloc] init];
    toDoItem.itemName = [NSString stringWithFormat:@"%@", [[self.arrToDoItem objectAtIndex:indexPath.row] objectAtIndex:indexOfItemName]];
    //toDoItem.completed = [[self.arrToDoItem objectAtIndex:indexPath.row] objectAtIndex:indexOfComplete];
    toDoItem.completed = "NO";
    toDoItem.creationDate = [[self.arrToDoItem objectAtIndex:indexPath.row] objectAtIndex:indexOfdateCreated];
    
    cell.textLabel.text = toDoItem.itemName;
    
    if(toDoItem.completed) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.toDoItems removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
    }
}

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ToDoItem *tappedItem = [self.toDoItems objectAtIndex:indexPath.row];
    tappedItem.completed = !tappedItem.completed;
    [tableView reloadRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationNone];
    
    //Update in database
    NSString *query;
    if(tappedItem.completed){
        query = [NSString stringWithFormat:@"update todo set complete=%d where itemName=%@", 1, tappedItem.itemName];
    }else{
        query = [NSString stringWithFormat:@"update todo set complete=%d where itemName=%@", 0, tappedItem.itemName];
    }
    
    // Execute the query.
    [self.dbManager executeQuery:query];
}

@end
