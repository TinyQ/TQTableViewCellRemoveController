//
//  TQTableViewCellRemoveController.h
//  TQTableViewCellRemoveController
//
//  Created by qfu on 8/11/14.
//  Copyright (c) 2014 qfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TQTableViewCellRemoveControllerDelegate <NSObject>

- (void)didRemoveTableViewCellWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface TQTableViewCellRemoveController : NSObject

@property (weak) id<TQTableViewCellRemoveControllerDelegate> delegate;

- (instancetype)initWithTableView:(UITableView *)tableView;

@end
