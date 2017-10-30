//
//  NSManagedObjectContext+GIGExtension.m
//  giglibrary
//
//  Created by Sergio Baró on 9/23/13.
//  Copyright (c) 2013 Gigigo. All rights reserved.
//

#import "NSManagedObjectContext+GIGExtension.h"


@implementation NSManagedObjectContext (GIGExtension)

#pragma mark - Factory

+ (NSManagedObjectContext *)managedObjectContextWithMigrationWithName:(NSString *)name bundle:(NSBundle *)bundle
{
    return [self managedObjectContextWithCoordinator:[self coordinatorWithMigrationWithName:name bundle:bundle]];
}

+ (NSManagedObjectContext *)managedObjectContextInMemoryWithName:(NSString *)name bundle:(NSBundle *)bundle
{
	return [self managedObjectContextWithCoordinator:[self coordinatorInMemoryWithName:name bundle:bundle]];
}

+ (NSManagedObjectContext *)managedObjectContextInFileWithName:(NSString *)name bundle:(NSBundle *)bundle
{
	return [self managedObjectContextWithCoordinator:[self coordinatorInFileWithName:name bundle:bundle]];
}

+ (NSManagedObjectContext *)managedObjectContextWithCoordinator:(NSPersistentStoreCoordinator *)coordinator
{
	NSManagedObjectContext *managedContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
	
	managedContext.persistentStoreCoordinator = coordinator;
	managedContext.undoManager = nil;
	
	return managedContext;
}

+ (NSManagedObjectContext *)managedObjectContextWithMigrationWithName:(NSString *)name {
    return [self managedObjectContextWithMigrationWithName:name bundle:[NSBundle mainBundle]];
}
+ (NSManagedObjectContext *)managedObjectContextInMemoryWithName:(NSString *)name {
    return [self managedObjectContextInMemoryWithName:name bundle:[NSBundle mainBundle]];
}
+ (NSManagedObjectContext *)managedObjectContextInFileWithName:(NSString *)name {
    return [self managedObjectContextInFileWithName:name bundle:[NSBundle mainBundle]];
}

#pragma mark - Insert

- (id)insertEntity:(Class)entityClass
{
	return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(entityClass) inManagedObjectContext:self];
}

#pragma mark - Fetch

- (NSArray *)fetch:(Class)entityClass
{
    return [self fetch:entityClass predicate:nil sort:nil ascending:NO limit:0];
}

- (NSArray *)fetch:(Class)entityClass predicate:(id)predicate
{
    return [self fetch:entityClass predicate:predicate sort:nil ascending:NO limit:0];
}

- (NSArray *)fetch:(Class)entityClass predicate:(id)predicate sort:(NSString *)key ascending:(BOOL)ascending
{
    return [self fetch:entityClass predicate:predicate sort:key ascending:ascending limit:0];
}

- (NSArray *)fetch:(Class)entityClass predicate:(id)predicate sort:(NSString *)sortKey ascending:(BOOL)ascending limit:(NSUInteger)limit
{
    NSArray *sorts = nil;
    if (sortKey.length > 0)
    {
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:ascending];
        sorts = @[sort];
    }
    
    return [self fetch:entityClass predicate:predicate sorts:sorts limit:limit];
}

- (NSArray *)fetch:(Class)entityClass predicate:(id)predicate sorts:(NSArray *)sorts
{
    return [self fetch:entityClass predicate:predicate sorts:sorts limit:0];
}

- (NSArray *)fetch:(Class)entityClass predicate:(id)predicate sorts:(NSArray *)sorts limit:(NSUInteger)limit
{
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass(entityClass)];
    fetch.predicate = [self predicateFrom:predicate];
    if (sorts.count > 0)
    {
        fetch.sortDescriptors = sorts;
    }
    
    if (limit > 0)
    {
        fetch.fetchLimit = limit;
    }
	
	NSError *error = nil;
	NSArray *fetchResult = [self executeFetchRequest:fetch error:&error];
	
	if (error)
	{
        NSLog(@"%@", error.localizedDescription);
	}
	
	return fetchResult;
}

- (id)fetchFirst:(Class)entityClass predicate:(id)predicate
{
    NSArray *fetchResult = [self fetch:entityClass predicate:predicate sort:nil ascending:NO limit:1];
	
	NSManagedObject *result = nil;
	if (fetchResult.count > 0)
	{
		result = fetchResult[0];
	}
	
	return result;
}

#pragma mark - Delete

- (void)deleteAll
{
    NSArray *entities = [self.persistentStoreCoordinator.managedObjectModel entities];
    
    for (NSEntityDescription *entity in entities)
    {
        [self deleteObjectsFromEntityDescription:entity];
    }
}

- (void)deleteObjectsFromEntityDescription:(NSEntityDescription *)entity
{
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:entity.name];
    fetch.includesPropertyValues = NO;
    NSArray *objects = [self executeFetchRequest:fetch error:nil];
    
    [self deleteObjectsFromArray:objects];
}

- (void)deleteObjectsFromEntity:(Class)entityClass
{
	NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass(entityClass)];
    fetch.includesPropertyValues = NO;
    NSArray *objects = [self executeFetchRequest:fetch error:nil];
    
    [self deleteObjectsFromArray:objects];
}

- (void)deleteObjectsFromEntity:(Class)entityClass predicate:(id)predicate
{
	NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass(entityClass)];
    fetch.includesPropertyValues = NO;
    fetch.predicate = [self predicateFrom:predicate];
    
    NSArray *objects = [self executeFetchRequest:fetch error:nil];
    
    [self deleteObjectsFromArray:objects];
}

- (void)deleteObjectsFromArray:(NSArray *)objects
{
	for (NSManagedObject *object in objects)
	{
		[self deleteObject:object];
	}
}

- (void)deleteObjectsFromSet:(NSSet *)objects
{
    for (NSManagedObject *object in objects)
    {
        [self deleteObject:object];
    }
}

#pragma mark - Count

- (NSUInteger)countForEntity:(Class)entityClass
{
	NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass(entityClass)];
    
    return [self countForFetchRequest:fetch];
}

- (NSUInteger)countForEntity:(Class)entityClass predicate:(id)predicate
{
	NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass(entityClass)];
    fetch.predicate = [self predicateFrom:predicate];
    
    return [self countForFetchRequest:fetch];
}

- (NSUInteger)countForFetchRequest:(NSFetchRequest *)fetchRequest
{
    NSError *error = nil;
    NSUInteger result = [self countForFetchRequest:fetchRequest error:&error];
    if (result == NSNotFound)
    {
        result = 0;
        NSLog(@"%@", error.localizedDescription);
    }
    
    return result;
}

#pragma mark - Save

- (BOOL)save
{
	BOOL result = YES;
	
	if ([self hasChanges])
	{
		NSError *error = nil;
		result = [self save:&error];
		
		if (error)
		{
            NSLog(@"%@", error.localizedDescription);
		}
	}
	
	return result;
}

#pragma mark - Private

+ (NSManagedObjectModel *)modelWithName:(NSString *)name bundle:(NSBundle *)bundle
{
    NSURL *modelURL = [bundle URLForResource:name withExtension:@"momd"];
    
    //NSURL *modelURL = [[NSBundle mainBundle] URLForResource:name withExtension:@"momd"];
    return [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
}

+ (NSPersistentStoreCoordinator *)coordinatorWithMigrationWithName:(NSString *)name bundle:(NSBundle *)bundle
{
    NSManagedObjectModel *model = [self modelWithName:name bundle:bundle];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    NSURL *documentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [documentsDirectory URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", name]];
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption: @(YES),
                              NSInferMappingModelAutomaticallyOption: @(YES)};
    
    NSError *error = nil;
    if (![coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error])
    {
        NSLog(@"%@", error.localizedDescription);
    }
    
    return coordinator;
}

+ (NSPersistentStoreCoordinator *)coordinatorInMemoryWithName:(NSString *)name  bundle:(NSBundle *)bundle
{
	NSManagedObjectModel *model = [self modelWithName:name bundle:bundle];
	NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
	
	NSError *error = nil;
    if (![coordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:&error])
    {
        NSLog(@"%@", error.localizedDescription);
    }
	
	return coordinator;
}

+ (NSPersistentStoreCoordinator *)coordinatorInFileWithName:(NSString *)name bundle:(NSBundle *)bundle
{
	NSManagedObjectModel *model = [self modelWithName:name bundle:bundle];
	
	NSURL *documentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [documentsDirectory URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", name]];
    NSError *error = nil;
	NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    if (![coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        NSLog(@"%@", error.localizedDescription);
    }
	
	return coordinator;
}

- (NSPredicate *)predicateFrom:(id)predicate
{
    if ([predicate isKindOfClass:[NSPredicate class]])
    {
        return predicate;
    }
    else if ([predicate isKindOfClass:[NSString class]])
    {
        return [NSPredicate predicateWithFormat:predicate];
    }
    else
    {
        return nil;
    }
}

@end
