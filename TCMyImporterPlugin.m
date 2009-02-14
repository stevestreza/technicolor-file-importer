//
//  TCMyImporterPlugin.m
//  technicolor-file-importer
//
//  Created by Steve Streza on 11/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TCMyImporterPlugin.h"
#import "SSImportScanOperation.h"
#import "TCTVShow.h"
#import "TCTVEpisode.h"

@implementation TCMyImporterPlugin

TCUUID(@"17D87DBB-846A-46FF-B624-0A72736E1BB0")

-(void)awake{
	NSArray *paths = [NSArray arrayWithObjects:
					  @"/Volumes/Lavos/Video/TV Shows/",
					  @"/Volumes/Kerrigan/Video/TV Shows/",
					  @"/Volumes/Kefka/Video/TV Shows/",
					  @"/Volumes/Cortana/Video/TV Shows/",
					  nil];
	
	for(NSString *path in paths){
		SSImportScanOperation *scanOp = [[SSImportScanOperation alloc] init];
		scanOp.sourcePath = path;
		[scanOp run];
		[scanOp release];
	}
	
	NSArray *allShows = [TCTVShow allShows:YES];
	NSArray *allEpisodes = [TCTVEpisode allEpisodes:YES];
	
	NSLog(@"All shows! %i",[allShows count]);
	for(TCTVShow *show in allShows){
		NSArray *episodes = [show episodes];
		NSLog(@"  - Show %@ has %i episodes",[show valueForKey:@"showName"], [episodes count]);
	}
	NSLog(@"All episodes! %i",[allEpisodes count]);
}

@end
