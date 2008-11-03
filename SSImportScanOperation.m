//
//  SSImportScanOperation.m
//  technicolor-file-importer
//
//  Created by Steve Streza on 11/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SSImportScanOperation.h"
#import "TCTVShow.h"
#import "TCTVEpisode.h"
#import "TCVideoFile.h"

@implementation SSImportScanOperation
@synthesize sourcePath;

#define IsDSStore(__nm) ([(__nm) isEqualToString:@".DS_Store"])

-(void)run{
	NSFileManager *fm = [NSFileManager defaultManager];
	
	NSArray *shows = [fm directoryContentsAtPath:self.sourcePath];
	for(NSString *showName in shows){
		if(IsDSStore(showName)) continue;
		
		TCTVShow *show = [TCTVShow showWithName:showName];
		
		NSString *showPath = [self.sourcePath stringByAppendingPathComponent:showName];
		NSArray *seasons = [fm directoryContentsAtPath:showPath];
		for(NSString *seasonName in seasons){
			if(IsDSStore(seasonName)) continue;
			
			NSString *seasonPath = [showPath stringByAppendingPathComponent:seasonName];
			
			NSArray *episodes = [fm directoryContentsAtPath:seasonPath];
			for(NSString *episodeInfo in episodes){
				if(IsDSStore(episodeInfo)) continue;
				
				NSUInteger seasonNumber  = 0;
				NSUInteger episodeNumber = 0;
				NSString * title = nil;
				
				if([self parseName:episodeInfo 
				  withSeasonNumber:&seasonNumber
					 episodeNumber:&episodeNumber
							 title:&title]){
					
					TCTVEpisode *episode = [TCTVEpisode showVideoWithEpisodeName:title 
																		  season:seasonNumber 
																   episodeNumber:episodeNumber 
																			show:show];
					
					NSLog(@"Adding season %i episode %i named %@ of show %@",seasonNumber, episodeNumber, title, showName);
					
					NSString *filePath = [seasonPath stringByAppendingPathComponent:episodeInfo];
					
					TCVideoFile *videoFile = [TCVideoFile videoFileForPath:filePath];
					[episode addFile:videoFile];
				}
			}
		}
	}
}

-(BOOL)parseName:(NSString *)name withSeasonNumber:(NSUInteger *)seasonNumber episodeNumber:(NSUInteger *)episodeNumber title:(NSString **)title{
	NSRange infoSplit = [name rangeOfString:@" - "];
	if(infoSplit.location == NSNotFound) return NO;
	
	NSString *episodeInfo = [name substringToIndex:infoSplit.location];
	*seasonNumber  = (NSUInteger)([[episodeInfo substringToIndex:  episodeInfo.length - 2] intValue]);
	*episodeNumber = (NSUInteger)([[episodeInfo substringFromIndex:episodeInfo.length - 2] intValue]);
	
	*title = [[name substringFromIndex:infoSplit.location + infoSplit.length] stringByDeletingPathExtension];
	return YES;
}

@end
