//
//  BNRImageStore.m
//  Homepwner
//
//  Created by Eric Kim on 12/7/12.
//  Copyright (c) 2012 Eric Kim. All rights reserved.
//

#import "BNRImageStore.h"

@implementation BNRImageStore

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

+ (BNRImageStore *)sharedStore
{
    static BNRImageStore *sharedStore = nil;
    
    if (!sharedStore) {
        sharedStore = [[super allocWithZone:NULL] init];
    }
    return sharedStore;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        dictionary = [[NSMutableDictionary alloc] init];
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(clearCache:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}


- (void)setImage:(UIImage *)i forKey:(NSString *)s
{
    [dictionary setObject:i forKey:s];
    
    NSString *imagePath = [self imagePathForKey:s];
    
    NSData *d = UIImageJPEGRepresentation(i, 0.5);
    
    [d writeToFile:imagePath atomically:YES];
}

- (UIImage *)imageForKey:(NSString *)s
{
    UIImage *result = [dictionary objectForKey:s];
    
    if (!result) {
        result = [UIImage imageWithContentsOfFile:[self imagePathForKey:s]];
        
        if (result) {
            [dictionary setObject:result forKey:s];
        } else {
            NSLog(@"Error: unable to find path: %@", [self imagePathForKey:s]);
        }
    }
    
    return result;
}

- (void)deleteImageForKey:(NSString *)s
{
    if (!s) return;
    [dictionary removeObjectForKey:s];
    
    NSString *path = [self imagePathForKey:s];
    [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
}


- (NSString *)imagePathForKey:(NSString *)key
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:key];
}

- (void)clearCache:(NSNotification *)note
{
    NSLog(@"flushing %d images out of cache", [dictionary count]);
    [dictionary removeAllObjects];
}

@end
