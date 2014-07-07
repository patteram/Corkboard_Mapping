//
//  CBMCardViewDelegate.h
//  CorkboardMapping
//
//  Created by Ashley Patterson on 5/12/14.
//  Copyright (c) 2014 Ashley Patterson. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CBMCardViewDelegate <NSObject>
/*!Delegate called when card view is clicked*/
-(void)clicked:(id)itemClicked;
/*!
 Method called when body text is changed on card 
@param newText - the new text on the body
@param cardChanged - the actual model Card object that is associated with the view (not the card view itself).
*/
-(void)bodyTextChange:(NSString *)newText onCard:(Card*)cardChanged;
/*!Method called when title is changed on card
 @param newText - the new text on the title
 @param cardChanged - teh actual model Card object associated with the view. 
 */
-(void)titleTextChange:(NSString *)newText onCard:(Card *)cardChanged;
/*!Method called when users wishes to change card type
 @param newType- the type that was seleted
 @param cardChanged - teh actual model Card object associated with the view.
 */
-(void)typeChange:(CardType *)newType onCard:(Card *)cardChanged;

-(void)originChange:(NSPoint)newOrigin onCard:(Card*)cardChanged;
-(void)sizeChange:(NSSize)newSize onCard:(Card*)cardChanged;
@end
