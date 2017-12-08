/*
 *  MHWDirectoryWatcher.h
 *  Created by Martin Hwasser on 12/19/11.
 */

#import <Foundation/Foundation.h>

/*
 Usage via blocks
 
 Get an instance of MHWDirectoryWatcher using the factory method +directoryWatcherAtPath:callback: and it will start monitoring the path immediately. Callback occurs after files have changed.
 
 Example:
 
 _dirWatcher = [MHWDirectoryWatcher directoryWatcherAtPath:kDocumentsFolder callback:^{
 // Actions which should be performed when the files in the directory
 [self doSomethingNice];
 }];
 Call -stopWatching / -startWatching to pause/resume.
 */
 
@interface MHWDirectoryWatcher : NSObject

// Returns an initialized MHWDirectoryWatcher and begins to watch the path, if specified
+ (MHWDirectoryWatcher *)directoryWatcherAtPath:(NSString *)watchedPath
                               startImmediately:(BOOL)startImmediately
                                       callback:(void(^)(void))cb;

// Equivalent to calling +directoryWatcherAtPath:startImmediately and passing
// YES for startImmediately.
+ (MHWDirectoryWatcher *)directoryWatcherAtPath:(NSString *)watchPath
                                       callback:(void(^)(void))cb;

// Returns YES if started watching, NO if already is watching
- (BOOL)startWatching;

// Returns YES if stopped watching, NO if not watching
- (BOOL)stopWatching;

// The path being watched
@property (nonatomic, readonly, copy) NSString *watchedPath;

@end
