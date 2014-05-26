//
//  ACTableView.m
//  AltConfData
//
//  Created by Alexander v. Below on 25.05.14.
//  Copyright (c) 2014 Alexander von Below. All rights reserved.
//

#import "ACTableView.h"

@implementation ACTableView
- (BOOL)validateMenuItem:(NSMenuItem *)menuItem {
    if (menuItem.action == @selector(copy:)) {
        
        NSIndexSet *selectedRows = self.selectedRowIndexes;
        return selectedRows.count != 0;
    }
    return YES;
}

- (void) copy:(id) sender {
    NSLog(@"foo");
}
@end
