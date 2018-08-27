//
//  ViewController.m
//  ToDoList
//
//  Created by Khiet Ly on 24/8/18.
//  Copyright © 2018 Khiet Ly. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@property (nonatomic) NSMutableArray *items;
@property (nonatomic) NSArray *categories;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.items = @[@{@"name":@"Take out the trash",@"category": @"Home"},@{@"name":@"Cleaning the house",@"category": @"Home"},@{@"name":@"Reply to important email",@"category":@"Work"}].mutableCopy;
    self.categories=@[@"Home",@"Work",@"Shopping"];
    [self.tableView setContentInset:UIEdgeInsetsMake(50,0,0,0)];
    
    self.navigationItem.title =@"To-do list";
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(toggleEditing:)];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Editing

-(void)toggleEditing:(UIBarButtonItem *)sender{
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    
    
    if (self.tableView.editing)
    {
        sender.title =@"Done";
        sender.style = UIBarButtonItemStylePlain;
    }else{
        sender.title = @"Edit";
        sender.style = UIBarButtonItemStylePlain;
    }
}

#pragma mark - Adding items

-(void)addNewItem:(UIBarButtonItem *)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"New to-do item" message:@"Please enter the name of the new to-do item" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add item", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
    
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex != alertView.cancelButtonIndex)
    {
        UITextField *itemNameField = [alertView textFieldAtIndex:0];
        NSString *itemName = itemNameField.text;
        NSDictionary *item = @{@"name": itemName, @"category": @"Home"};
        
        [self.items addObject:item];
        NSInteger numHomeItems = [self numberofItemsInCategory:@"Home"];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:numHomeItems -1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
    NSInteger index = [self itemIndexForIndexPath:indexPath];
    NSMutableDictionary *item = [self.items[index] mutableCopy];
    BOOL completed = [item[@"completed"] boolValue];
    item[@"completed"] = @(!completed);
    self.items[index] = item;
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = ([item[@"completed"] boolValue]) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - Datasource helper methods
-(NSArray *)itemsInCategories:(NSString *)targetCategory{
    NSPredicate *matchingPredicate = [NSPredicate predicateWithFormat:@"category == %@", targetCategory];
    NSArray *categoryItems = [self.items filteredArrayUsingPredicate:matchingPredicate];
    return categoryItems;
}

-(NSInteger)numberofItemsInCategory:(NSString *)targetCategory{
    return [self itemsInCategories:targetCategory].count;
}

-(NSDictionary *)ItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *category = self.categories[indexPath.section];
    NSArray *categoryItems = [self itemsInCategories:category];
    NSDictionary *item = categoryItems[indexPath.row];
    
    return item;
}

-(NSInteger)itemIndexForIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *item = [self ItemAtIndexPath:indexPath];
    NSInteger index = [self.items indexOfObjectIdenticalTo:item];
    return index;
}

-(void)removeItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = [self itemIndexForIndexPath:indexPath];
    [self.items removeObjectAtIndex:index];
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.categories[section];
}




#pragma mark - Table view datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.categories.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self numberofItemsInCategory:self.categories[section]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TodoItemRow";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *item = [self ItemAtIndexPath:indexPath];
    
    cell.textLabel.text = item[@"name"];
    
    if([item[@"completed"] boolValue])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}



-(UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        [self removeItemAtIndexPath:indexPath];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

@end
