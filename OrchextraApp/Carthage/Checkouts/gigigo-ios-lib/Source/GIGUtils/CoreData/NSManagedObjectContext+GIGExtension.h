//
//  NSManagedObjectContext+GIGExtension.h
//  giglibrary
//
//  Created by Sergio Baró on 9/23/13.
//  Copyright (c) 2013 Gigigo. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface NSManagedObjectContext (GIGExtension)

+ (NSManagedObjectContext *)managedObjectContextWithMigrationWithName:(NSString *)name bundle:(NSBundle *)bundle;
+ (NSManagedObjectContext *)managedObjectContextInMemoryWithName:(NSString *)name bundle:(NSBundle *)bundle;
+ (NSManagedObjectContext *)managedObjectContextInFileWithName:(NSString *)name bundle:(NSBundle *)bundle;
+ (NSManagedObjectContext *)managedObjectContextWithMigrationWithName:(NSString *)name;
+ (NSManagedObjectContext *)managedObjectContextInMemoryWithName:(NSString *)name;
+ (NSManagedObjectContext *)managedObjectContextInFileWithName:(NSString *)name;

- (id)insertEntity:(Class)entityClass;
- (NSArray *)fetch:(Class)entityClass;
- (NSArray *)fetch:(Class)entityClass predicate:(id)predicate;
- (NSArray *)fetch:(Class)entityClass predicate:(id)predicate sort:(NSString *)key ascending:(BOOL)ascending;
- (NSArray *)fetch:(Class)entityClass predicate:(id)predicate sort:(NSString *)Key ascending:(BOOL)ascending limit:(NSUInteger)limit;
- (NSArray *)fetch:(Class)entityClass predicate:(id)predicate sorts:(NSArray *)sorts;
- (NSArray *)fetch:(Class)entityClass predicate:(id)predicate sorts:(NSArray *)sorts limit:(NSUInteger)limit;
- (id)fetchFirst:(Class)entityClass predicate:(id)predicate;

- (void)deleteAll;
- (void)deleteObjectsFromEntityDescription:(NSEntityDescription *)entity;
- (void)deleteObjectsFromEntity:(Class)entityClass;
- (void)deleteObjectsFromEntity:(Class)entityClass predicate:(id)predicate;
- (void)deleteObjectsFromArray:(NSArray *)objects;
- (void)deleteObjectsFromSet:(NSSet *)set;

- (NSUInteger)countForEntity:(Class)entityClass;
- (NSUInteger)countForEntity:(Class)entityClass predicate:(id)predicate;
- (NSUInteger)countForFetchRequest:(NSFetchRequest *)fetchRequest;

- (BOOL)save;

@end
