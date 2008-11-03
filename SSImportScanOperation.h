//
//  SSImportScanOperation.h
//  technicolor-file-importer
//
//  Created by Steve Streza on 11/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SSImportScanOperation : NSObject {
	NSString *sourcePath;
}

@property (copy) NSString *sourcePath;
-(BOOL)parseName:(NSString *)name withSeasonNumber:(NSUInteger *)seasonNumber episodeNumber:(NSUInteger *)episodeNumber title:(NSString **)title;
-(void)run;
@end
