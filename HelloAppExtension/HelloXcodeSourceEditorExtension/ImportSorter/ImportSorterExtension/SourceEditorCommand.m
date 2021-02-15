//
//  SourceEditorCommand.m
//  ImportSorterExtension
//
//  Created by wesley_chen on 2020/12/25.
//

#import "SourceEditorCommand.h"

@implementation SourceEditorCommand

- (void)performCommandWithInvocation:(XCSourceEditorCommandInvocation *)invocation completionHandler:(void (^)(NSError * _Nullable nilOrError))completionHandler
{
    // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.
    
    // Retrieve the contents of the current source editor.
//            let lines = invocation.buffer.lines
//            // Reverse the order of the lines in a copy.
//            let updatedText = Array(lines.reversed())
//            lines.removeAllObjects()
//            lines.addObjects(from: updatedText)
//            // Signal to Xcode that the command has completed.
    
    completionHandler(nil);
}

@end
