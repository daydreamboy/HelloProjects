//
//  AppDelegate.m
//  AppTest
//
//  Created by wesley chen on 16/4/13.
//
//

#import "AppDelegate.h"

#import "RootViewController.h"
#import "WCFileTool.h"

@interface AppDelegate ()
@property (nonatomic, strong) RootViewController *rootViewController;
@property (nonatomic, strong) UINavigationController *navController;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.rootViewController = [RootViewController new];
    self.navController = [[UINavigationController alloc] initWithRootViewController:self.rootViewController];
    self.window.rootViewController = self.navController;
    
    [self.window makeKeyAndVisible];
    [self test];
    
    return YES;
}

- (void)test {
    NSLog(@"Home: %@", NSHomeDirectory());
    
    NSString *currentPath = [[NSFileManager defaultManager] currentDirectoryPath];
    NSLog(@"%@", currentPath);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directoryPath = ([paths count] > 0) ? paths[0] : nil;
    
    NSString *filePath1 = [NSString stringWithFormat:@"%@/%@", directoryPath, @"file3"];
    //    NSString *filePath2 = [NSString stringWithFormat:@"%@/%@", directoryPath, @"file2"];
    
    NSString *fileContent1 = @"fileContent1";
    NSString *fileContent2 = @"fileContent2";
    
    [fileContent1 writeToFile:filePath1 atomically:YES encoding:NSUTF8StringEncoding error:nil];
    //    [fileContent2 writeToFile:filePath2 atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    NSArray *fileNames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:nil];
    
    fileNames = [fileNames sortedArrayUsingComparator:^NSComparisonResult(NSString *fileName1, NSString *fileName2) {
        NSString *filePath1 = [NSString stringWithFormat:@"%@/%@", directoryPath, fileName1];
        NSString *filePath2 = [NSString stringWithFormat:@"%@/%@", directoryPath, fileName2];
        
        NSDictionary *attributes1 = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath1 error:nil];
        NSDictionary *attributes2 = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath2 error:nil];
        
        return attributes1[NSFileCreationDate] < attributes2[NSFileCreationDate];
    }];
    
    NSLog(@"fileNames: %@", fileNames);
    
    NSString *filePath3 = [NSString stringWithFormat:@"%@/test/test.txt", directoryPath];
    BOOL succeeded = [WCFileTool createNewFileAtPath:filePath3 overwrite:YES error:nil];
    if (succeeded) {
        NSLog(@"Ok");
    }
    
    NSString *filePath4 = [NSString stringWithFormat:@"%@/test2/tt.txt", directoryPath];
    succeeded = [[NSFileManager defaultManager] createFileAtPath:filePath4 contents:nil attributes:nil];
    NSLog(@"%@", succeeded ? @"OKK" : @"Failed");
}

@end
