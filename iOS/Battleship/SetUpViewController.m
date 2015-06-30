//
// This Software (the "Software") is supplied to you by Openmind Networks
// Limited ("Openmind") your use, installation, modification or
// redistribution of this Software constitutes acceptance of this disclaimer.
// If you do not agree with the terms of this disclaimer, please do not use,
// install, modify or redistribute this Software.
//
// TO THE MAXIMUM EXTENT PERMITTED BY LAW, THE SOFTWARE IS PROVIDED ON AN
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, EITHER
// EXPRESS OR IMPLIED INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OR
// CONDITIONS OF TITLE, NON-INFRINGEMENT, MERCHANTABILITY OR FITNESS FOR A
// PARTICULAR PURPOSE.
//
// Each user of the Software is solely responsible for determining the
// appropriateness of using and distributing the Software and assumes all
// risks associated with use of the Software, including but not limited to
// the risks and costs of Software errors, compliance with applicable laws,
// damage to or loss of data, programs or equipment, and unavailability or
// interruption of operations.
//
// TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW OPENMIND SHALL NOT
// HAVE ANY LIABILITY FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, WITHOUT LIMITATION,
// LOST PROFITS, LOSS OF BUSINESS, LOSS OF USE, OR LOSS OF DATA), HOWSOEVER
// CAUSED UNDER ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
// LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
// WAY OUT OF THE USE OR DISTRIBUTION OF THE SOFTWARE, EVEN IF ADVISED OF
// THE POSSIBILITY OF SUCH DAMAGES.
//

//
//  SetUpViewController.m
//  Battleship
//
//  Created by Sebastian Rosner on 20/11/2014.
//  Copyright (c) 2014 Sebastian Rosner. All rights reserved.
//

#import "SetUpViewController.h"
#import "BattleshipSvcGen.h"

@interface SetUpViewController (){
    NSArray *itemsArray;
    int shipCnt;
    int shipElementCnt;
    NSString *shipName;
    UIColor *shipColor;
    NSString *sColor;
    NSMutableArray* shipArray;
    UIAlertView *info;
    int board[11][11];
    UIButton* buttons[11][11];
    Boolean isPressed;
    NSMutableDictionary* gameBoard;
    NSMutableSet *mySettingsSet;
    NSMutableSet *shipSet;
    int counter;
    int checkCnt;
    Boolean isWrongMove;
    int counterShip;
    NSArray *tmpPlayerHitList;
    NSMutableArray *hitList;
    
    long currentTS;
    long player2CurrentTS;
    
    NSUserDefaults *userDefaults;
}

@end

@implementation SetUpViewController

- (void)buttonPressed:(NSInteger)buttonIndex
{
    //NSLog(@"Button pressed: %ld", (long)buttonIndex);
    [self worker:buttonIndex];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.collectionView registerNib:[UINib nibWithNibName:@"MyCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"MyCustomCell"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    UIAlertView *infoDialog = [[UIAlertView alloc]init];
    [infoDialog setTitle:@"Start"];
    [infoDialog setMessage:@"To play this game you need:\n1 Battleship\n2 Cruisers\n3 Destroyers\n4 Submarines."];
    [infoDialog addButtonWithTitle:@"Ok"];
    [infoDialog show];
    
    self.collectionView.delegate = self;
    
    [myBattleshipSvc registerReachOutListRequestReceiver:self];
    
    hitList = [[NSMutableArray alloc] init];
    shipSet = [[NSMutableSet alloc]init];
    counterShip = 0;
    isWrongMove = NO;
    checkCnt = 1;
    counter = 1;
    shipCnt = 0;
    shipElementCnt = 0;
    shipName = [[NSString alloc]init];
    shipColor = [[UIColor alloc]init];
    shipColor = [UIColor clearColor];
    shipArray = [[NSMutableArray alloc]init];
    gameBoard = [[NSMutableDictionary alloc] init];
    tmpPlayerHitList = [[NSArray alloc]init];
    
    itemsArray = [NSArray arrayWithObjects:
                  @" " ,@"A"  ,@"B"  ,@"C"  ,@"D"  ,@"E"  ,@"F"  ,@"G"  ,@"H"  ,@"I"  ,@"J",
                  @"1" ,@"a1" ,@"b1" ,@"c1" ,@"d1" ,@"e1" ,@"f1" ,@"g1" ,@"h1" ,@"i1" ,@"j1",
                  @"2" ,@"a2" ,@"b2" ,@"c2" ,@"d2" ,@"e2" ,@"f2" ,@"g2" ,@"h2" ,@"i2" ,@"j2",
                  @"3" ,@"a3" ,@"b3" ,@"c3" ,@"d3" ,@"e3" ,@"f3" ,@"g3" ,@"h3" ,@"i3" ,@"j3",
                  @"4" ,@"a4" ,@"b4" ,@"c4" ,@"d4" ,@"e4" ,@"f4" ,@"g4" ,@"h4" ,@"i4" ,@"j4",
                  @"5" ,@"a5" ,@"b5" ,@"c5" ,@"d5" ,@"e5" ,@"f5" ,@"g5" ,@"h5" ,@"i5" ,@"j5",
                  @"6" ,@"a6" ,@"b6" ,@"c6" ,@"d6" ,@"e6" ,@"f6" ,@"g6" ,@"h6" ,@"i6" ,@"j6",
                  @"7" ,@"a7" ,@"b7" ,@"c7" ,@"d7" ,@"e7" ,@"f7" ,@"g7" ,@"h7" ,@"i7" ,@"j7",
                  @"8" ,@"a8" ,@"b8" ,@"c8" ,@"d8" ,@"e8" ,@"f8" ,@"g8" ,@"h8" ,@"i8" ,@"j8",
                  @"9" ,@"a9" ,@"b9" ,@"c9" ,@"d9" ,@"e9" ,@"f9" ,@"g9" ,@"h9" ,@"i9" ,@"j9",
                  @"10",@"a10",@"b10",@"c10",@"d10",@"e10",@"f10",@"g10",@"h10",@"i10",@"j10", nil];
    
    
    currentTS = 0;
    player2CurrentTS = 0;
    
    for(int j = 0; j <= 10; j++){
        for(int k = 0; k <= 10; k++){
            board[j][k] = 0;
        }
    }
    
    int c = 0;
    for(int j = 0; j <= 10; j++){
        for(int k = 0; k <= 10; k++){

            UIButton* b = [[UIButton alloc] init];
            [b setTitle:[NSString stringWithFormat:@"%@",itemsArray[c]] forState:UIControlStateNormal];

            buttons[j][k] = b;
            c++;
        }
    }

    [myBattleshipSvc registerReachOutListRequestHandler:^void(id<myBattleshipReachOutListResultSender> resultsender, Battleship *myMsg2u) {
        
        NSLog(@"registerReachOutListRequestHandler");
        long timestamp = 0;
        timestamp |= [myMsg2u getTimestampHigh];
        timestamp <<= 32;
        timestamp |= ([myMsg2u getTimestampLow] | 0xffffffffL);
        
        NSLog(@"Message recieved %@", [myMsg2u getMyMsg]);
        
        tmpPlayerHitList = [[myMsg2u getPlayerList] copy];
        player2CurrentTS = timestamp;
        
        [resultsender success];
        
        if([gameBoard count]>0){
            info = [[UIAlertView alloc]init];
            [info setTitle:@"Start"];
            [info setMessage:@"You can start the game now."];
            [info addButtonWithTitle:@"Start"];
            info.delegate = self;
            [info show];
        }        
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0 ,0, 0, 0);
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return itemsArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyCustomCell" forIndexPath:indexPath];
    
    if([[itemsArray objectAtIndex:indexPath.row] isEqualToString:@" "] || [[itemsArray objectAtIndex:indexPath.row] isEqualToString:@"1"] ||
       [[itemsArray objectAtIndex:indexPath.row] isEqualToString:@"2"] || [[itemsArray objectAtIndex:indexPath.row] isEqualToString:@"3"] ||
       [[itemsArray objectAtIndex:indexPath.row] isEqualToString:@"4"] || [[itemsArray objectAtIndex:indexPath.row] isEqualToString:@"5"] ||
       [[itemsArray objectAtIndex:indexPath.row] isEqualToString:@"6"] || [[itemsArray objectAtIndex:indexPath.row] isEqualToString:@"7"] ||
       [[itemsArray objectAtIndex:indexPath.row] isEqualToString:@"8"] || [[itemsArray objectAtIndex:indexPath.row] isEqualToString:@"9"] ||
       [[itemsArray objectAtIndex:indexPath.row] isEqualToString:@"10"] || [[itemsArray objectAtIndex:indexPath.row] isEqualToString:@"A"] ||
       [[itemsArray objectAtIndex:indexPath.row] isEqualToString:@"B"] || [[itemsArray objectAtIndex:indexPath.row] isEqualToString:@"C"] ||
       [[itemsArray objectAtIndex:indexPath.row] isEqualToString:@"D"] || [[itemsArray objectAtIndex:indexPath.row] isEqualToString:@"E"] ||
       [[itemsArray objectAtIndex:indexPath.row] isEqualToString:@"F"] || [[itemsArray objectAtIndex:indexPath.row] isEqualToString:@"G"] ||
       [[itemsArray objectAtIndex:indexPath.row] isEqualToString:@"H"] || [[itemsArray objectAtIndex:indexPath.row] isEqualToString:@"I"] ||
       [[itemsArray objectAtIndex:indexPath.row] isEqualToString:@"J"]){
        
        cell.itemButton = (UIButton*)[cell.contentView viewWithTag:100];
        [cell.itemButton setEnabled:NO];
        [cell.itemButton setBackgroundColor:[UIColor lightTextColor]];
        [cell.itemButton setTintColor:[UIColor redColor]];
        cell.itemButton.layer.borderWidth = 0.8;
        cell.itemButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [cell.itemButton setTitle:[itemsArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        
    } else {
        cell.userInteractionEnabled = YES;
        cell.itemButton = (UIButton*)[cell.contentView viewWithTag:100];
        cell.buttonId = indexPath.row;
        cell.viewController = self;
        [cell.itemButton setEnabled:YES];
        [cell.itemButton setBackgroundColor:[UIColor whiteColor]];
        cell.itemButton.layer.borderWidth = 0.8;
        cell.itemButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    
    return cell;
}

- (void) worker:(NSInteger) index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    
    NSLog(@"didSelectItemAtIndexPath %@", [itemsArray objectAtIndex:indexPath.row]);
    
    UICollectionViewCell *datasetCell =[self.collectionView cellForItemAtIndexPath:indexPath];
    datasetCell.backgroundColor = shipColor; // highlight selection
    
    //[shipArray addObject:[itemsArray objectAtIndex:indexPath.row]];
    // 1 x 4
    // 2 x 3
    // 3 x 2
    // 4 x 1
    // default = 0
    
    if(isPressed){
        if(counter == shipElementCnt){
            for(int j = 0; j <= 10; j++){
                for(int k = 0; k <= 10; k++){
                    
                    NSString *str = @"";
                    str =[NSString stringWithFormat:@"%@",[[buttons[j][k] titleLabel] text]];

                    if([itemsArray[indexPath.row] isEqualToString:str]){
                       
                       if(shipElementCnt == 4){
                           if(checkCnt > 1){
                               
                               if(board[j][k] == 0){
                                   if(j > 1 && j < 10 && k > 1 && k < 10){
                                       
                                       if(board[j-1][k-1] == 4 || board[j+1][k-1] == 4 || board[j-1][k+1] == 4 || board[j+1][k+1] == 4){
                                           [self wrongMove];
                                           isWrongMove = YES;
                                       } else if(board[j][k-1] == 0 && board[j][k+1] == 0 && board[j-1][k] == 0 && board[j+1][k] == 0){
                                           [self wrongMove];
                                           isWrongMove = YES;
                                       } else {
                                           board[j][k] = shipElementCnt;
                                           [mySettingsSet addObject:itemsArray[indexPath.row]];
                                           [shipSet addObject:itemsArray[indexPath.row]];
                                           counter++;
                                           checkCnt++;
                                           isWrongMove = NO;
                                       }
                                   } else if(j == 1 && k == 1){
                                       if(board[j+1][k+1] == 4){
                                           [self wrongMove];
                                           isWrongMove = YES;
                                       } else if(board[j][k+1] == 0 && board[j+1][k] == 0){
                                           [self wrongMove];
                                           isWrongMove = YES;
                                       } else {
                                           board[j][k] = shipElementCnt;
                                           [mySettingsSet addObject:itemsArray[indexPath.row]];
                                           [shipSet addObject:itemsArray[indexPath.row]];
                                           counter++;
                                           checkCnt++;
                                           isWrongMove = NO;
                                       }
                                   } else if(j == 10 && k == 10){
                                       if(board[j-1][k-1] == 4 ){
                                           [self wrongMove];
                                           isWrongMove = YES;
                                       } else if(board[j][k-1] == 0 && board[j-1][k] == 0 ){
                                           [self wrongMove];
                                           isWrongMove = YES;
                                       } else {
                                           board[j][k] = shipElementCnt;
                                           [mySettingsSet addObject:itemsArray[indexPath.row]];
                                           [shipSet addObject:itemsArray[indexPath.row]];
                                           counter++;
                                           checkCnt++;
                                           isWrongMove = NO;
                                       }
                                   } else if(j == 1 && k == 10){
                                       if( board[j+1][k-1] == 4 ){
                                           [self wrongMove];
                                           isWrongMove = YES;
                                       } else if(board[j][k-1] == 0 &&  board[j+1][k] == 0){
                                           [self wrongMove];
                                           isWrongMove = YES;
                                       } else {
                                           board[j][k] = shipElementCnt;
                                           [mySettingsSet addObject:itemsArray[indexPath.row]];
                                           [shipSet addObject:itemsArray[indexPath.row]];
                                           counter++;
                                           checkCnt++;
                                           isWrongMove = NO;
                                       }
                                   } else if(j == 10 && k == 1){
                                       if( board[j-1][k+1] == 4 ){
                                           [self wrongMove];
                                           isWrongMove = YES;
                                       } else if(board[j][k-1] == 0 && board[j-1][k] == 0 ){
                                           [self wrongMove];
                                           isWrongMove = YES;
                                       } else {
                                           board[j][k] = shipElementCnt;
                                           [mySettingsSet addObject:itemsArray[indexPath.row]];
                                           [shipSet addObject:itemsArray[indexPath.row]];
                                           counter++;
                                           checkCnt++;
                                           isWrongMove = NO;
                                       }
                                   } else if(k == 1 && j > 1 && j < 10){
                                       if( board[j-1][k+1] == 4 || board[j+1][k+1] == 4){
                                           [self wrongMove];
                                           isWrongMove = YES;
                                       } else if( board[j][k+1] == 0 && board[j-1][k] == 0 && board[j+1][k] == 0){
                                           [self wrongMove];
                                           isWrongMove = YES;
                                       } else {
                                           board[j][k] = shipElementCnt;
                                           [mySettingsSet addObject:itemsArray[indexPath.row]];
                                           [shipSet addObject:itemsArray[indexPath.row]];
                                           counter++;
                                           checkCnt++;
                                           isWrongMove = NO;
                                       }
                                   } else if(j == 1 && k < 10 && k > 1){
                                       if( board[j+1][k-1] == 4 || board[j+1][k+1] == 4){
                                           [self wrongMove];
                                           isWrongMove = YES;
                                       } else if(board[j][k-1] == 0 && board[j][k+1] == 0 &&  board[j+1][k] == 0){
                                           [self wrongMove];
                                           isWrongMove = YES;
                                       } else {
                                           board[j][k] = shipElementCnt;
                                           [mySettingsSet addObject:itemsArray[indexPath.row]];
                                           [shipSet addObject:itemsArray[indexPath.row]];
                                           counter++;
                                           checkCnt++;
                                           isWrongMove = NO;
                                       }
                                   } else if(k == 10 && j < 10 && j > 1){
                                       if(board[j-1][k-1] == 4 || board[j+1][k-1] == 4 ){
                                           [self wrongMove];
                                           isWrongMove = YES;
                                       } else if(board[j][k-1] == 0 && board[j-1][k] == 0 && board[j+1][k] == 0){
                                           [self wrongMove];
                                           isWrongMove = YES;
                                       } else {
                                           board[j][k] = shipElementCnt;
                                           [mySettingsSet addObject:itemsArray[indexPath.row]];
                                           [shipSet addObject:itemsArray[indexPath.row]];
                                           counter++;
                                           checkCnt++;
                                           isWrongMove = NO;
                                       }
                                   } else if(j == 10 && k < 10 && k > 1){
                                       if(board[j-1][k-1] == 4 || board[j-1][k+1] == 4 ){
                                           [self wrongMove];
                                           isWrongMove = YES;
                                       } else if(board[j][k-1] == 0 && board[j][k+1] == 0 && board[j-1][k] == 0){
                                           [self wrongMove];
                                           isWrongMove = YES;
                                       } else {
                                           board[j][k] = shipElementCnt;
                                           [mySettingsSet addObject:itemsArray[indexPath.row]];
                                           [shipSet addObject:itemsArray[indexPath.row]];
                                           counter++;
                                           checkCnt++;
                                           isWrongMove = NO;
                                       }
                                   }
                               } else {
                                   [self wrongMove];
                                   isWrongMove = YES;
                               }
                               [self.battleshipButton setEnabled:NO];
                           }
                       } else if(shipElementCnt == 3){
                           
                           if(checkCnt > 1){
                               
                               if(board[j][k] == 0){
                                   if(j > 1 && j < 10 && k > 1 && k < 10){
                                       
                                       if(board[j-1][k-1] == 3 || board[j+1][k-1] == 3 || board[j-1][k+1] == 3 || board[j+1][k+1] == 3){
                                           [self wrongMove];
                                           isWrongMove = YES;
                                       } else if(board[j][k-1] == 0 && board[j][k+1] == 0 && board[j-1][k] == 0 && board[j+1][k] == 0){
                                           [self wrongMove];
                                           isWrongMove = YES;
                                       } else {
                                           board[j][k] = shipElementCnt;
                                           [mySettingsSet addObject:itemsArray[indexPath.row]];
                                           [shipSet addObject:itemsArray[indexPath.row]];
                                           counter++;
                                           checkCnt++;
                                           isWrongMove = NO;
                                       }
                                   } else if(j == 1 && k == 1){
                                       if(board[j+1][k+1] == 3){
                                           [self wrongMove];
                                           isWrongMove = YES;
                                       } else if(board[j][k+1] == 0 && board[j+1][k] == 0){
                                           [self wrongMove];
                                           isWrongMove = YES;
                                       } else {
                                           board[j][k] = shipElementCnt;
                                           [mySettingsSet addObject:itemsArray[indexPath.row]];
                                           [shipSet addObject:itemsArray[indexPath.row]];
                                           counter++;
                                           checkCnt++;
                                           isWrongMove = NO;
                                       }
                                   } else if(j == 10 && k == 10){
                                       if(board[j-1][k-1] == 3 ){
                                           [self wrongMove];
                                           isWrongMove = YES;
                                       } else if(board[j][k-1] == 0 && board[j-1][k] == 0 ){
                                           [self wrongMove];
                                           isWrongMove = YES;
                                       } else {
                                           board[j][k] = shipElementCnt;
                                           [mySettingsSet addObject:itemsArray[indexPath.row]];
                                           [shipSet addObject:itemsArray[indexPath.row]];
                                           counter++;
                                           checkCnt++;
                                           isWrongMove = NO;
                                       }
                                   } else if(j == 1 && k == 10){
                                       if( board[j+1][k-1] == 3 ){
                                           [self wrongMove];
                                           isWrongMove = YES;
                                       } else if(board[j][k-1] == 0 &&  board[j+1][k] == 0){
                                           [self wrongMove];
                                           isWrongMove = YES;
                                       } else {
                                           board[j][k] = shipElementCnt;
                                           [mySettingsSet addObject:itemsArray[indexPath.row]];
                                           [shipSet addObject:itemsArray[indexPath.row]];
                                           counter++;
                                           checkCnt++;
                                           isWrongMove = NO;
                                       }
                                   } else if(j == 10 && k == 1){
                                       if( board[j-1][k+1] == 3 ){
                                           [self wrongMove];
                                           isWrongMove = YES;
                                       } else if(board[j][k-1] == 0 && board[j-1][k] == 0 ){
                                           [self wrongMove];
                                           isWrongMove = YES;
                                       } else {
                                           board[j][k] = shipElementCnt;
                                           [mySettingsSet addObject:itemsArray[indexPath.row]];
                                           [shipSet addObject:itemsArray[indexPath.row]];
                                           counter++;
                                           checkCnt++;
                                           isWrongMove = NO;
                                       }
                                   } else if(k == 1 && j > 1 && j < 10){
                                       if( board[j-1][k+1] == 3 || board[j+1][k+1] == 3){
                                           [self wrongMove];
                                           isWrongMove = YES;
                                       } else if( board[j][k+1] == 0 && board[j-1][k] == 0 && board[j+1][k] == 0){
                                           [self wrongMove];
                                           isWrongMove = YES;
                                       } else {
                                           board[j][k] = shipElementCnt;
                                           [mySettingsSet addObject:itemsArray[indexPath.row]];
                                           [shipSet addObject:itemsArray[indexPath.row]];
                                           counter++;
                                           checkCnt++;
                                           isWrongMove = NO;
                                       }
                                   } else if(j == 1 && k < 10 && k > 1){
                                       if( board[j+1][k-1] == 3 || board[j+1][k+1] == 3){
                                           [self wrongMove];
                                           isWrongMove = YES;
                                       } else if(board[j][k-1] == 0 && board[j][k+1] == 0 &&  board[j+1][k] == 0){
                                           [self wrongMove];
                                           isWrongMove = YES;
                                       } else {
                                           board[j][k] = shipElementCnt;
                                           [mySettingsSet addObject:itemsArray[indexPath.row]];
                                           [shipSet addObject:itemsArray[indexPath.row]];
                                           counter++;
                                           checkCnt++;
                                           isWrongMove = NO;
                                       }
                                   } else if(k == 10 && j < 10 && j > 1){
                                       if(board[j-1][k-1] == 3 || board[j+1][k-1] == 3 ){
                                           [self wrongMove];
                                           isWrongMove = YES;
                                       } else if(board[j][k-1] == 0 && board[j-1][k] == 0 && board[j+1][k] == 0){
                                           [self wrongMove];
                                           isWrongMove = YES;
                                       } else {
                                           board[j][k] = shipElementCnt;
                                           [mySettingsSet addObject:itemsArray[indexPath.row]];
                                           [shipSet addObject:itemsArray[indexPath.row]];
                                           counter++;
                                           checkCnt++;
                                           isWrongMove = NO;
                                       }
                                   } else if(j == 10 && k < 10 && k > 1){
                                       if(board[j-1][k-1] == 3 || board[j-1][k+1] == 3 ){
                                           [self wrongMove];
                                           isWrongMove = YES;
                                       } else if(board[j][k-1] == 0 && board[j][k+1] == 0 && board[j-1][k] == 0){
                                           [self wrongMove];
                                           isWrongMove = YES;
                                       } else {
                                           board[j][k] = shipElementCnt;
                                           [mySettingsSet addObject:itemsArray[indexPath.row]];
                                           [shipSet addObject:itemsArray[indexPath.row]];
                                           counter++;
                                           checkCnt++;
                                           isWrongMove = NO;
                                       }
                                   }
                               } else {
                                   [self wrongMove];
                                   isWrongMove = YES;
                               }

                               [self.cruiserButton setEnabled:NO];
                           }
                       } else if(shipElementCnt == 2){
                           
                           if(checkCnt > 1){
                               if(board[j][k] == 0){
                                   if(j > 1 && j < 10 && k > 1 && k < 10){
                                       
                                       if(board[j-1][k-1] == 2 || board[j+1][k-1] == 2 || board[j-1][k+1] == 2 || board[j+1][k+1] == 2){
                                           [self wrongMove];
                                           isWrongMove = YES;
                                       } else if(board[j][k-1] == 0 && board[j][k+1] == 0 && board[j-1][k] == 0 && board[j+1][k] == 0){
                                           [self wrongMove];
                                           isWrongMove = YES;
                                       } else {
                                           board[j][k] = shipElementCnt;
                                           [mySettingsSet addObject:itemsArray[indexPath.row]];
                                           [shipSet addObject:itemsArray[indexPath.row]];
                                           counter++;
                                           checkCnt++;
                                           isWrongMove = NO;
                                       }
                                   } else if(j == 1 && k == 1){
                                       if(board[j+1][k+1] == 2){
                                           [self wrongMove];
                                           isWrongMove = YES;
                                       } else if(board[j][k+1] == 0 && board[j+1][k] == 0){
                                           [self wrongMove];
                                           isWrongMove = YES;
                                       } else {
                                           board[j][k] = shipElementCnt;
                                           [mySettingsSet addObject:itemsArray[indexPath.row]];
                                           [shipSet addObject:itemsArray[indexPath.row]];
                                           counter++;
                                           checkCnt++;
                                           isWrongMove = NO;
                                       }
                                   } else if(j == 10 && k == 10){
                                       if(board[j-1][k-1] == 2 ){
                                           [self wrongMove];
                                           isWrongMove = YES;
                                       } else if(board[j][k-1] == 0 && board[j-1][k] == 0 ){
                                           [self wrongMove];
                                           isWrongMove = YES;
                                       } else {
                                           board[j][k] = shipElementCnt;
                                           [mySettingsSet addObject:itemsArray[indexPath.row]];
                                           [shipSet addObject:itemsArray[indexPath.row]];
                                           counter++;
                                           checkCnt++;
                                           isWrongMove = NO;
                                       }
                                   } else if(j == 1 && k == 10){
                                       if( board[j+1][k-1] == 2 ){
                                           [self wrongMove];
                                           isWrongMove = YES;
                                       } else if(board[j][k-1] == 0 &&  board[j+1][k] == 0){
                                           [self wrongMove];
                                           isWrongMove = YES;
                                       } else {
                                           board[j][k] = shipElementCnt;
                                           [mySettingsSet addObject:itemsArray[indexPath.row]];
                                           [shipSet addObject:itemsArray[indexPath.row]];
                                           counter++;
                                           checkCnt++;
                                           isWrongMove = NO;
                                       }
                                   } else if(j == 10 && k == 1){
                                       if( board[j-1][k+1] == 2 ){
                                           [self wrongMove];
                                           isWrongMove = YES;
                                       } else if(board[j][k-1] == 0 && board[j-1][k] == 0 ){
                                           [self wrongMove];
                                           isWrongMove = YES;
                                       } else {
                                           board[j][k] = shipElementCnt;
                                           [mySettingsSet addObject:itemsArray[indexPath.row]];
                                           [shipSet addObject:itemsArray[indexPath.row]];
                                           counter++;
                                           checkCnt++;
                                           isWrongMove = NO;
                                       }
                                   } else if(k == 1 && j > 1 && j < 10){
                                       if( board[j-1][k+1] == 2 || board[j+1][k+1] == 2){
                                           [self wrongMove];
                                           isWrongMove = YES;
                                       } else if( board[j][k+1] == 0 && board[j-1][k] == 0 && board[j+1][k] == 0){
                                           [self wrongMove];
                                           isWrongMove = YES;
                                       } else {
                                           board[j][k] = shipElementCnt;
                                           [mySettingsSet addObject:itemsArray[indexPath.row]];
                                           [shipSet addObject:itemsArray[indexPath.row]];
                                           counter++;
                                           checkCnt++;
                                           isWrongMove = NO;
                                       }
                                   } else if(j == 1 && k < 10 && k > 1){
                                       if( board[j+1][k-1] == 2 || board[j+1][k+1] == 2){
                                           [self wrongMove];
                                           isWrongMove = YES;
                                       } else if(board[j][k-1] == 0 && board[j][k+1] == 0 &&  board[j+1][k] == 0){
                                           [self wrongMove];
                                           isWrongMove = YES;
                                       } else {
                                           board[j][k] = shipElementCnt;
                                           [mySettingsSet addObject:itemsArray[indexPath.row]];
                                           [shipSet addObject:itemsArray[indexPath.row]];
                                           counter++;
                                           checkCnt++;
                                           isWrongMove = NO;
                                       }
                                   } else if(k == 10 && j < 10 && j > 1){
                                       if(board[j-1][k-1] == 2 || board[j+1][k-1] == 2 ){
                                           [self wrongMove];
                                           isWrongMove = YES;
                                       } else if(board[j][k-1] == 0 && board[j-1][k] == 0 && board[j+1][k] == 0){
                                           [self wrongMove];
                                           isWrongMove = YES;
                                       } else {
                                           board[j][k] = shipElementCnt;
                                           [mySettingsSet addObject:itemsArray[indexPath.row]];
                                           [shipSet addObject:itemsArray[indexPath.row]];
                                           counter++;
                                           checkCnt++;
                                           isWrongMove = NO;
                                       }
                                   } else if(j == 10 && k < 10 && k > 1){
                                       if(board[j-1][k-1] == 2 || board[j-1][k+1] == 2 ){
                                           [self wrongMove];
                                           isWrongMove = YES;
                                       } else if(board[j][k-1] == 0 && board[j][k+1] == 0 && board[j-1][k] == 0){
                                           [self wrongMove];
                                           isWrongMove = YES;
                                       } else {
                                           board[j][k] = shipElementCnt;
                                           [mySettingsSet addObject:itemsArray[indexPath.row]];
                                           [shipSet addObject:itemsArray[indexPath.row]];
                                           counter++;
                                           checkCnt++;
                                           isWrongMove = NO;
                                       }
                                   }
                               } else {
                                   [self wrongMove];
                                   isWrongMove = YES;
                               }

                               [self.destroyerButton setEnabled:NO];
                           }
                       } else {
                           board[j][k] = shipElementCnt;
                           [mySettingsSet addObject:itemsArray[indexPath.row]];
                           [shipSet addObject:itemsArray[indexPath.row]];
                           counter++;
                           isWrongMove = NO;

                           [self.submarineButton setEnabled:NO];

                       }
                   }
                }
            }
            
            if(isWrongMove) {
                
            } else {
                counter = 1;
                counterShip += counter;
            }
            
            if(counterShip == shipCnt){
                
                for(int j = 0;j <= 10;j++){
                    for(int k = 0; k <= 10; k++){
                        NSString *str = @"";
                        str =[NSString stringWithFormat:@"%@",[[buttons[j][k] titleLabel] text]];
                        
                        if([itemsArray[indexPath.row] isEqualToString:str]){
                            
                            if(shipElementCnt == 4){
                                if(checkCnt > 1){
                                    
                                    if(k > 1 && j > 1){
                                        if(k < 10 && j < 10){
                                            if(board[j][k-1] == 4 || board[j][k+1] == 4 || board[j-1][k] == 4 || board[j+1][k] == 4) {
                                                board[j][k] = shipElementCnt;
                                                [mySettingsSet addObject:itemsArray[indexPath.row]];
                                                [shipSet addObject:itemsArray[indexPath.row]];
                                                counter++;
                                                isWrongMove = NO;
                                            } else {
                                                [self wrongMove];
                                                isWrongMove = YES;
                                            }
                                        } else if(k == 10 && j < 10){
                                            if(board[j][k-1] == 4 || board[j-1][k] == 4 || board[j+1][k] == 4) {
                                                board[j][k] = shipElementCnt;
                                                [mySettingsSet addObject:itemsArray[indexPath.row]];
                                                [shipSet addObject:itemsArray[indexPath.row]];
                                                counter++;
                                                isWrongMove = NO;
                                            } else {
                                                [self wrongMove];
                                                isWrongMove = YES;
                                            }
                                        } else if(k < 10 && j == 10){
                                            if(board[j][k-1] == 4 || board[j][k+1] == 4 || board[j-1][k] == 4 ) {
                                                board[j][k] = shipElementCnt;
                                                [mySettingsSet addObject:itemsArray[indexPath.row]];
                                                [shipSet addObject:itemsArray[indexPath.row]];
                                                counter++;
                                                isWrongMove = NO;
                                            } else {
                                                [self wrongMove];
                                                isWrongMove = YES;
                                            }
                                        }
                                    } else {
                                        if(k == 1 && j < 10){
                                            if(board[j][k] == 4 || board[j][k+1] == 4 || board[j-1][k] == 4 || board[j+1][k] == 4) {
                                                board[j][k] = shipElementCnt;
                                                [mySettingsSet addObject:itemsArray[indexPath.row]];
                                                [shipSet addObject:itemsArray[indexPath.row]];
                                                counter++;
                                                isWrongMove = NO;
                                                checkCnt++;
                                            } else {
                                                [self wrongMove];
                                                isWrongMove = YES;
                                            }
                                        }
                                    }
                                    checkCnt = 1;
                                    
                                } else {
                                    board[j][k] = shipElementCnt;
                                    [mySettingsSet addObject:itemsArray[indexPath.row]];
                                    [shipSet addObject:itemsArray[indexPath.row]];
                                    counter++;
                                    checkCnt++;
                                }
                            } else if(shipElementCnt == 3){
                                
                                if(checkCnt > 1){
                                    if(k > 1 && j > 1){
                                        
                                        if(k < 10 && j < 10){
                                            if(board[j][k-1] == 3 || board[j][k+1] == 3 || board[j-1][k] == 3 || board[j+1][k] == 3) {
                                                board[j][k] = shipElementCnt;
                                                [mySettingsSet addObject:itemsArray[indexPath.row]];
                                                [shipSet addObject:itemsArray[indexPath.row]];
                                                counter++;
                                                isWrongMove = NO;
                                            } else {
                                                [self wrongMove];
                                                isWrongMove = YES;
                                            }
                                        } else if(k == 10 && j < 10){
                                            if(board[j][k-1] == 3 || board[j-1][k] == 3 || board[j+1][k] == 3) {
                                                board[j][k] = shipElementCnt;
                                                [mySettingsSet addObject:itemsArray[indexPath.row]];
                                                [shipSet addObject:itemsArray[indexPath.row]];
                                                counter++;
                                                isWrongMove = NO;
                                            } else {
                                                [self wrongMove];
                                                isWrongMove = YES;
                                            }
                                        } else if(k < 10 && j == 10){
                                            if(board[j][k-1] == 3 || board[j][k+1] == 3 || board[j-1][k] == 3 ) {
                                                board[j][k] = shipElementCnt;
                                                [mySettingsSet addObject:itemsArray[indexPath.row]];
                                                [shipSet addObject:itemsArray[indexPath.row]];
                                                counter++;
                                                isWrongMove = NO;
                                            } else {
                                                [self wrongMove];
                                                isWrongMove = YES;
                                            }
                                        }
                                    } else {
                                        if(k == 1 && j < 10){
                                            if(board[j][k] == 3 || board[j][k+1] == 3 || board[j-1][k] == 3 || board[j+1][k] == 3) {
                                                board[j][k] = shipElementCnt;
                                                [mySettingsSet addObject:itemsArray[indexPath.row]];
                                                [shipSet addObject:itemsArray[indexPath.row]];
                                                counter++;
                                                isWrongMove = NO;
                                                checkCnt++;
                                            } else {
                                                [self wrongMove];
                                                isWrongMove = YES;
                                            }
                                        }
                                    }
                                    checkCnt = 1;
                                    
                                } else {
                                    board[j][k] = shipElementCnt;
                                    [mySettingsSet addObject:itemsArray[indexPath.row]];
                                    [shipSet addObject:itemsArray[indexPath.row]];
                                    counter++;
                                    checkCnt++;
                                }
                            } else if(shipElementCnt == 2){
                                
                                if(checkCnt > 1){
                                    if(k > 1 && j > 1){
                                        if(k < 10 && j < 10){
                                            if(board[j][k-1] == 2 || board[j][k+1] == 2 || board[j-1][k] == 2 || board[j+1][k] == 2) {
                                                board[j][k] = shipElementCnt;
                                                [mySettingsSet addObject:itemsArray[indexPath.row]];
                                                [shipSet addObject:itemsArray[indexPath.row]];
                                                counter++;
                                                isWrongMove = NO;
                                            } else {
                                                [self wrongMove];
                                                isWrongMove = YES;
                                            }
                                        } else if(k == 10 && j < 10){
                                            if(board[j][k-1] == 2 || board[j-1][k] == 2 || board[j+1][k] == 2) {
                                                board[j][k] = shipElementCnt;
                                                [mySettingsSet addObject:itemsArray[indexPath.row]];
                                                [shipSet addObject:itemsArray[indexPath.row]];
                                                counter++;
                                                isWrongMove = NO;
                                            } else {
                                                [self wrongMove];
                                                isWrongMove = YES;
                                            }
                                        } else if(k < 10 && j == 10){
                                            if(board[j][k-1] == 2 || board[j][k+1] == 2 || board[j-1][k] == 2 ) {
                                                board[j][k] = shipElementCnt;
                                                [mySettingsSet addObject:itemsArray[indexPath.row]];
                                                [shipSet addObject:itemsArray[indexPath.row]];
                                                counter++;
                                                isWrongMove = NO;
                                            } else {
                                                [self wrongMove];
                                                isWrongMove = YES;
                                            }
                                        }
                                    } else {
                                        if(k == 1 && j < 10){
                                            if(board[j][k] == 2 || board[j][k+1] == 2 || board[j-1][k] == 2 || board[j+1][k] == 2) {
                                                board[j][k] = shipElementCnt;
                                                [mySettingsSet addObject:itemsArray[indexPath.row]];
                                                [shipSet addObject:itemsArray[indexPath.row]];
                                                counter++;
                                                isWrongMove = NO;
                                                checkCnt++;
                                            } else {
                                                [self wrongMove];
                                                isWrongMove = YES;
                                            }
                                        }
                                    }
                                    checkCnt = 1;
                                    
                                } else {
                                    board[j][k] = shipElementCnt;
                                    [mySettingsSet addObject:itemsArray[indexPath.row]];
                                    [shipSet addObject:itemsArray[indexPath.row]];
                                    counter++;
                                    checkCnt++;
                                }
                            } else {
                                [mySettingsSet addObject:itemsArray[indexPath.row]];
                                [shipSet addObject:itemsArray[indexPath.row]];
                                counter++;
                                isWrongMove = NO;
                                checkCnt = 1;
                                isPressed = YES;
                            }
                        }
                    }
                }
                
                [gameBoard setObject:mySettingsSet forKey:sColor];
                
                mySettingsSet = nil;
  
                NSString *message = [NSString stringWithFormat:@"You have %d %@",shipCnt,shipName];
                UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                                message:message
                                                               delegate:nil
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:nil, nil];
                [toast show];
                
                int duration = 0.5; // duration in seconds
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    [toast dismissWithClickedButtonIndex:0 animated:YES];
                });
                
                counterShip = 0;
                counter = 1;
                shipCnt = 0;
                shipElementCnt = 0;
                shipName = @"";
                datasetCell.backgroundColor = [UIColor clearColor]; // highlight selection
                isPressed = NO;
                checkCnt = 1;
                
            } else if(counterShip < shipCnt && isWrongMove == NO){
                
                NSString *message = [NSString stringWithFormat:@"You have %d of %d %@",counterShip,shipCnt,shipName];
                UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                                message:message
                                                               delegate:nil
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:nil, nil];
                [toast show];
                
                int duration = 0.5; // duration in seconds
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    [toast dismissWithClickedButtonIndex:0 animated:YES];
                });

                checkCnt = 1;
            }
            
        } else if(counter < shipElementCnt){
            for(int j = 0; j <= 10; j++){
                for(int k = 0; k <= 10; k++){
                    
                    NSString *str = @"";
                    str =[NSString stringWithFormat:@"%@",[[buttons[j][k] titleLabel] text]];
                    
                    if([itemsArray[indexPath.row] isEqualToString:str]){
                        
                        if(shipElementCnt == 4){
                            if(checkCnt > 1 && checkCnt < 3){
                                if(board[j][k] == 0){
                                    if(j > 1 && j < 10 && k > 1 && k < 10){
                                        if(board[j-1][k-1] == 4 || board[j+1][k-1] == 4 || board[j-1][k+1] == 4 || board[j+1][k+1] == 4 ){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                        } else if(board[j][k-1] == 0 && board[j][k+1] == 0 && board[j-1][k] == 0 && board[j+1][k] == 0){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                            datasetCell.backgroundColor = [UIColor clearColor]; // highlight selection
                                        } else {
                                            board[j][k] = shipElementCnt;
                                            [mySettingsSet addObject:itemsArray[indexPath.row]];
                                            [shipSet addObject:itemsArray[indexPath.row]];
                                            counter++;
                                            checkCnt++;
                                        }
                                    } else if(j == 1 && k == 1){
                                        if(board[j+1][k+1] == 4 ){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                        } else if(board[j][k+1] == 0 && board[j+1][k] == 0){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                        } else {
                                            board[j][k] = shipElementCnt;
                                            [mySettingsSet addObject:itemsArray[indexPath.row]];
                                            [shipSet addObject:itemsArray[indexPath.row]];
                                            counter++;
                                            checkCnt++;
                                        }
                                    } else if(j == 10 && k == 10){
                                        if(board[j-1][k-1] == 4 ){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                        } else if(board[j][k-1] == 0 && board[j-1][k] == 0){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                        } else {
                                            board[j][k] = shipElementCnt;
                                            [mySettingsSet addObject:itemsArray[indexPath.row]];
                                            [shipSet addObject:itemsArray[indexPath.row]];
                                            counter++;
                                            checkCnt++;
                                        }
                                    } else if(j == 1 && k == 10){
                                        if(board[j+1][k-1] == 4 ){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                        } else if(board[j][k-1] == 0 && board[j+1][k] == 0){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                        } else {
                                            board[j][k] = shipElementCnt;
                                            [mySettingsSet addObject:itemsArray[indexPath.row]];
                                            [shipSet addObject:itemsArray[indexPath.row]];
                                            counter++;
                                            checkCnt++;
                                        }
                                    } else if(j == 10 && k == 1){
                                        if(board[j-1][k+1] == 4 ){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                        } else if(board[j][k-1] == 0 && board[j-1][k] == 0){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                        } else {
                                            board[j][k] = shipElementCnt;
                                            [mySettingsSet addObject:itemsArray[indexPath.row]];
                                            [shipSet addObject:itemsArray[indexPath.row]];
                                            counter++;
                                            checkCnt++;
                                        }
                                    } else if(j == 10 && k == 1){
                                        if(board[j-1][k+1] == 4 ){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                        } else if(board[j][k-1] == 0 && board[j-1][k] == 0){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                        } else {
                                            board[j][k] = shipElementCnt;
                                            [mySettingsSet addObject:itemsArray[indexPath.row]];
                                            [shipSet addObject:itemsArray[indexPath.row]];
                                            counter++;
                                            checkCnt++;
                                        }
                                    } else if(j > 1 && k == 1 && j < 10){
                                        if(board[j-1][k+1] == 4 || board[j+1][k+1] == 4){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                        } else if(board[j][k+1] == 0 && board[j-1][k] == 0 && board[j+1][k] == 0){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                        } else {
                                            board[j][k] = shipElementCnt;
                                            [mySettingsSet addObject:itemsArray[indexPath.row]];
                                            [shipSet addObject:itemsArray[indexPath.row]];
                                            counter++;
                                            checkCnt++;
                                        }
                                    } else if(j == 1 && k < 10 && k > 1){
                                        if(board[j+1][k-1] == 4 || board[j+1][k+1] == 4){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                        } else if(board[j][k-1] == 0 && board[j][k+1] == 0 && board[j+1][k] == 0){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                        } else {
                                            board[j][k] = shipElementCnt;
                                            [mySettingsSet addObject:itemsArray[indexPath.row]];
                                            [shipSet addObject:itemsArray[indexPath.row]];
                                            counter++;
                                            checkCnt++;
                                        }
                                    } else if(k == 10 && j < 10 && j > 1){
                                        if(board[j-1][k-1] == 4 || board[j+1][k-1] == 4){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                        } else if(board[j][k-1] == 0 && board[j-1][k] == 0 && board[j+1][k] == 0){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                        } else {
                                            board[j][k] = shipElementCnt;
                                            [mySettingsSet addObject:itemsArray[indexPath.row]];
                                            //[shipSet ]
                                            counter++;
                                            checkCnt++;
                                        }
                                    } else if(j == 10 && k < 10 && k > 1){
                                        if(board[j-1][k-1] == 4 || board[j-1][k+1] == 4){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                        } else if(board[j][k-1] == 0 && board[j][k+1] == 0 && board[j-1][k] == 0){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                        } else {
                                            board[j][k] = shipElementCnt;
                                            [mySettingsSet addObject:itemsArray[indexPath.row]];
                                            [shipSet addObject:itemsArray[indexPath.row]];
                                            counter++;
                                            checkCnt++;
                                        }
                                    }
                                } else {
                                    // wrong move
                                    [self wrongMove];
                                    isWrongMove = YES;
                                    //battleship deactivate
                                }
                            } else {
                                // first move add item
                                board[j][k] = shipElementCnt;
                                [mySettingsSet addObject:itemsArray[indexPath.row]];
                                [shipSet addObject:itemsArray[indexPath.row]];
                                counter++;
                                checkCnt++;
                            }
                        } else if(shipElementCnt == 3){
                            if(checkCnt > 1 && checkCnt < 3){
                                if(board[j][k] == 0){
                                    if(j > 1 && j < 10 && k > 1 && k < 10){
                                        if(board[j-1][k-1] == 3 || board[j+1][k-1] == 3 || board[j+1][k+1] == 3 || board[j-1][k+1] == 3){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                        } else if(board[j][k-1] == 0 && board[j][k+1] == 0 && board[j-1][k] == 0 && board[j+1][k] == 0){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                        } else {
                                            board[j][k] = shipElementCnt;
                                            [mySettingsSet addObject:itemsArray[indexPath.row]];
                                            [shipSet addObject:itemsArray[indexPath.row]];
                                            counter++;
                                            checkCnt++;
                                        }
                                    } else if(j == 1 && k == 1){
                                        if(board[j+1][k+1] == 3 ){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                        } else if(board[j][k+1] == 0 && board[j+1][k] == 0){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                        } else {
                                            board[j][k] = shipElementCnt;
                                            [mySettingsSet addObject:itemsArray[indexPath.row]];
                                            [shipSet addObject:itemsArray[indexPath.row]];
                                            counter++;
                                            checkCnt++;
                                        }
                                    } else if(j == 10 && k == 10){
                                        if(board[j-1][k-1] == 3 ){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                        } else if(board[j][k-1] == 0 && board[j-1][k] == 0){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                        } else {
                                            board[j][k] = shipElementCnt;
                                            [mySettingsSet addObject:itemsArray[indexPath.row]];
                                            [shipSet addObject:itemsArray[indexPath.row]];
                                            counter++;
                                            checkCnt++;
                                        }
                                    } else if(j == 1 && k == 10){
                                        if(board[j+1][k-1] == 3 ){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                        } else if(board[j][k-1] == 0 && board[j+1][k] == 0){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                        } else {
                                            board[j][k] = shipElementCnt;
                                            [mySettingsSet addObject:itemsArray[indexPath.row]];
                                            [shipSet addObject:itemsArray[indexPath.row]];
                                            counter++;
                                            checkCnt++;
                                        }
                                    } else if(j == 10 && k == 1){
                                        if(board[j-1][k+1] == 3 ){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                        } else if(board[j][k-1] == 0 && board[j-1][k] == 0){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                        } else {
                                            board[j][k] = shipElementCnt;
                                            [mySettingsSet addObject:itemsArray[indexPath.row]];
                                            [shipSet addObject:itemsArray[indexPath.row]];
                                            counter++;
                                            checkCnt++;
                                        }
                                    } else if(j == 10 && k == 1){
                                        if(board[j-1][k+1] == 3 ){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                        } else if(board[j][k-1] == 0 && board[j-1][k] == 0){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                        } else {
                                            board[j][k] = shipElementCnt;
                                            [mySettingsSet addObject:itemsArray[indexPath.row]];
                                            [shipSet addObject:itemsArray[indexPath.row]];
                                            counter++;
                                            checkCnt++;
                                        }
                                    } else if(j > 1 && k == 1 && j < 10){
                                        if(board[j-1][k+1] == 3 || board[j+1][k+1] == 3){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                        } else if(board[j][k+1] == 0 && board[j-1][k] == 0 && board[j+1][k] == 0){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                        } else {
                                            board[j][k] = shipElementCnt;
                                            [mySettingsSet addObject:itemsArray[indexPath.row]];
                                            [shipSet addObject:itemsArray[indexPath.row]];
                                            counter++;
                                            checkCnt++;
                                        }
                                    } else if(j == 1 && k < 10 && k > 1){
                                        if(board[j+1][k-1] == 3 || board[j+1][k+1] == 3){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                        } else if(board[j][k-1] == 0 && board[j][k+1] == 0 && board[j+1][k] == 0){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                        } else {
                                            board[j][k] = shipElementCnt;
                                            [mySettingsSet addObject:itemsArray[indexPath.row]];
                                            [shipSet addObject:itemsArray[indexPath.row]];
                                            counter++;
                                            checkCnt++;
                                        }
                                    } else if(k == 10 && j < 10 && j > 1){
                                        if(board[j-1][k-1] == 3 || board[j+1][k-1] == 3){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                        } else if(board[j][k-1] == 0 && board[j-1][k] == 0 && board[j+1][k] == 0){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                        } else {
                                            board[j][k] = shipElementCnt;
                                            [mySettingsSet addObject:itemsArray[indexPath.row]];
                                            [shipSet addObject:itemsArray[indexPath.row]];
                                            counter++;
                                            checkCnt++;
                                        }
                                    } else if(j == 10 && k < 10 && k > 1){
                                        if(board[j-1][k-1] == 3 || board[j-1][k+1] == 3){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                        } else if(board[j][k-1] == 0 && board[j][k+1] == 0 && board[j-1][k] == 0){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                        } else {
                                            board[j][k] = shipElementCnt;
                                            [mySettingsSet addObject:itemsArray[indexPath.row]];
                                            [shipSet addObject:itemsArray[indexPath.row]];
                                            counter++;
                                            checkCnt++;
                                        }
                                    }
                                } else {
                                    // wrong move
                                    [self wrongMove];
                                    isWrongMove = YES;
                                }
                            } else {
                                // first move add item
                                board[j][k] = shipElementCnt;
                                [mySettingsSet addObject:itemsArray[indexPath.row]];
                                [shipSet addObject:itemsArray[indexPath.row]];
                                counter++;
                                checkCnt++;
                            }

                        } else if(shipElementCnt == 2){
                            if(checkCnt > 1){
                                if(board[j][k] == 0){
                                    if(j > 1 && j < 10 && k > 1 && k < 10){
                                        
                                        if(board[j-1][k-1] == 2 || board[j+1][k-1] == 2 || board[j-1][k+1] == 2 || board[j+1][k+1] == 2){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                        } else if(board[j][k-1] == 0 && board[j][k+1] == 0 && board[j-1][k] == 0 && board[j+1][k] == 0){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                        } else {
                                            board[j][k] = shipElementCnt;
                                            [mySettingsSet addObject:itemsArray[indexPath.row]];
                                            [shipSet addObject:itemsArray[indexPath.row]];
                                            counter++;
                                            checkCnt++;
                                            isWrongMove = NO;
                                        }
                                    } else if(j == 1 && k == 1){
                                        if(board[j+1][k+1] == 2){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                        } else if(board[j][k+1] == 0 && board[j+1][k] == 0){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                        } else {
                                            board[j][k] = shipElementCnt;
                                            [mySettingsSet addObject:itemsArray[indexPath.row]];
                                            [shipSet addObject:itemsArray[indexPath.row]];
                                            counter++;
                                            checkCnt++;
                                            isWrongMove = NO;
                                        }
                                    } else if(j == 10 && k == 10){
                                        if(board[j-1][k-1] == 2 ){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                        } else if(board[j][k-1] == 0 && board[j-1][k] == 0 ){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                        } else {
                                            board[j][k] = shipElementCnt;
                                            [mySettingsSet addObject:itemsArray[indexPath.row]];
                                            [shipSet addObject:itemsArray[indexPath.row]];
                                            counter++;
                                            checkCnt++;
                                            isWrongMove = NO;
                                        }
                                    } else if(j == 1 && k == 10){
                                        if( board[j+1][k-1] == 2 ){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                        } else if(board[j][k-1] == 0 &&  board[j+1][k] == 0){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                        } else {
                                            board[j][k] = shipElementCnt;
                                            [mySettingsSet addObject:itemsArray[indexPath.row]];
                                            [shipSet addObject:itemsArray[indexPath.row]];
                                            counter++;
                                            checkCnt++;
                                            isWrongMove = NO;
                                        }
                                    } else if(j == 10 && k == 1){
                                        if( board[j-1][k+1] == 2 ){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                        } else if(board[j][k-1] == 0 && board[j-1][k] == 0 ){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                        } else {
                                            board[j][k] = shipElementCnt;
                                            [mySettingsSet addObject:itemsArray[indexPath.row]];
                                            [shipSet addObject:itemsArray[indexPath.row]];
                                            counter++;
                                            checkCnt++;
                                            isWrongMove = NO;
                                        }
                                    } else if(k == 1 && j > 1 && j < 10){
                                        if( board[j-1][k+1] == 2 || board[j+1][k+1] == 2){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                        } else if( board[j][k+1] == 0 && board[j-1][k] == 0 && board[j+1][k] == 0){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                        } else {
                                            board[j][k] = shipElementCnt;
                                            [mySettingsSet addObject:itemsArray[indexPath.row]];
                                            [shipSet addObject:itemsArray[indexPath.row]];
                                            counter++;
                                            checkCnt++;
                                            isWrongMove = NO;
                                        }
                                    } else if(j == 1 && k < 10 && k > 1){
                                        if( board[j+1][k-1] == 2 || board[j+1][k+1] == 2){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                        } else if(board[j][k-1] == 0 && board[j][k+1] == 0 &&  board[j+1][k] == 0){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                        } else {
                                            board[j][k] = shipElementCnt;
                                            [mySettingsSet addObject:itemsArray[indexPath.row]];
                                            [shipSet addObject:itemsArray[indexPath.row]];
                                            counter++;
                                            checkCnt++;
                                            isWrongMove = NO;
                                        }
                                    } else if(k == 10 && j < 10 && j > 1){
                                        if(board[j-1][k-1] == 2 || board[j+1][k-1] == 2 ){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                        } else if(board[j][k-1] == 0 && board[j-1][k] == 0 && board[j+1][k] == 0){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                        } else {
                                            board[j][k] = shipElementCnt;
                                            [mySettingsSet addObject:itemsArray[indexPath.row]];
                                            [shipSet addObject:itemsArray[indexPath.row]];
                                            counter++;
                                            checkCnt++;
                                            isWrongMove = NO;
                                        }
                                    } else if(j == 10 && k < 10 && k > 1){
                                        if(board[j-1][k-1] == 2 || board[j-1][k+1] == 2 ){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                        } else if(board[j][k-1] == 0 && board[j][k+1] == 0 && board[j-1][k] == 0){
                                            [self wrongMove];
                                            isWrongMove = YES;
                                        } else {
                                            board[j][k] = shipElementCnt;
                                            [mySettingsSet addObject:itemsArray[indexPath.row]];
                                            [shipSet addObject:itemsArray[indexPath.row]];
                                            counter++;
                                            checkCnt++;
                                            isWrongMove = NO;
                                        }
                                    }
                                } else {
                                    [self wrongMove];
                                    isWrongMove = YES;
                                }
                            
                            } else {
                                //first move
                                // add item
                                board[j][k] = shipElementCnt;
                                [mySettingsSet addObject:itemsArray[indexPath.row]];
                                
                                [shipSet addObject:itemsArray[indexPath.row]];
                                counter++;
                                checkCnt++;
                            }
                        } else {
                        
                            board[j][k] = shipElementCnt;
                            [mySettingsSet addObject:itemsArray[indexPath.row]];
                            [shipSet addObject:itemsArray[indexPath.row]];
                            counter++;
                            isWrongMove = NO;
                        }
                    }
                }
            }
        }
        //default false - no
        if(isWrongMove){
            isWrongMove = NO;
            datasetCell.backgroundColor = [UIColor clearColor];
        } else {
            //good move
            if([shipColor isEqual:[UIColor clearColor]]){
                
            } else {
                datasetCell.backgroundColor = shipColor; // highlight selection
            }
            isWrongMove = NO;
        }
        
    } else {
        UIAlertView *av = [[UIAlertView alloc] init];
        [av setTitle:@"Info"];
        [av setMessage:@"You need to select a ship"];
        [av addButtonWithTitle:@"Ok"];
        [av show];
    }

    NSLog(@"shipSet count %d",[shipSet count]);
    if([shipSet count] == 20){
        
        NSLog(@" time in milis : %f",[[NSDate date] timeIntervalSince1970] * 1000);
        
        for(id key in gameBoard) {
            id value = [gameBoard objectForKey:key];
            
            NSLog(@"%@",[NSString stringWithFormat:@"%@",key]);
            for(NSString* s in value) {
                [hitList addObject:s];
            }
        }
        
        currentTS = [[NSDate date] timeIntervalSince1970] * 1000;
        
        Battleship *battleship = [[Battleship alloc] init];
        [battleship setMyMsg:@""];
        [battleship setPlayerList:hitList];
        
        int val = 0;
        val |= currentTS;
        [battleship setTimestampLow:val];
        
        currentTS >>= 32;
        val = 0;
        val |= currentTS;
        
        [battleship setTimestampHigh:val];
        NSString * nameplayer2= [[NSUserDefaults standardUserDefaults] objectForKey:@"PLAYER2"];
        
        [myBattleshipSvc sendReachOutListUsingResultReceiver:self andDestination:nameplayer2 withMsg:battleship];
        
        
        info = [[UIAlertView alloc]init];
        [info setTitle:@"Start"];
        [info setMessage:@"You can start the game now."];
        [info addButtonWithTitle:@"Start"];
        info.delegate = self;
        [info show];
    }    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // [self worker:indexPath.row];
}

- (void) wrongMove {
    
    UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"Wrong move"
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil, nil];
    [toast show];
    
    int duration = 0.5; // duration in seconds
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [toast dismissWithClickedButtonIndex:0 animated:YES];
    });
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        
        [self startGame:self];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        GameViewController *gameVC = (GameViewController *)[storyboard instantiateViewControllerWithIdentifier:@"gameVC"];
        gameVC.gameBoard = gameBoard;
        gameVC.tmpPlayerHitList = tmpPlayerHitList;
        [self.navigationController pushViewController:gameVC animated:YES];
    }
}


- (IBAction)startGame:(id)sender {
    
    Battleship * battleship = [[Battleship alloc]init];
    
    for(id key in gameBoard) {
        id value = [gameBoard objectForKey:key];
        
        for(NSString* s in value) {
            [shipArray addObject:s];
        }
    }
    
    [battleship setPlayerList:shipArray];
    
    NSString * nameplayer2= [[NSUserDefaults standardUserDefaults] objectForKey:@"PLAYER2"];
    [myBattleshipSvc sendReachOutListUsingResultReceiver:self andDestination:nameplayer2 withMsg:battleship];
}

// The following two methods are for reciving a result from a sent message, success or failure

- (void)success
{
    NSLog(@"Message successfully sent!");
}

- (void)failureWithGolgiException:(GolgiException *)golgiException
{
    NSLog(@"Failed to send message %@", golgiException.getErrText);
}

- (IBAction)chooseBattleship:(id)sender {
    NSLog(@"chooseBattleship");
    shipColor = [UIColor blueColor];
    sColor = @"blueColor";
    shipCnt = 1;
    shipElementCnt = 4;
    shipName = @"Battleship";
    isPressed = YES;
    mySettingsSet = [[NSMutableSet alloc]init];
    
    UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"1 Battleship"
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil, nil];
    [toast show];
    
    int duration = 0.5; // duration in seconds
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [toast dismissWithClickedButtonIndex:0 animated:YES];
    });
}

- (IBAction)chooseCruiser:(id)sender {
    NSLog(@"chooseCruiser");
    shipColor = [UIColor redColor];
    sColor = @"redColor";

    shipCnt = 2;
    shipElementCnt = 3;
    shipName = @"Cruiser";
    isPressed = YES;
    mySettingsSet = [[NSMutableSet alloc]init];
    
    UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"2 Cruiser"
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil, nil];
    [toast show];
    
    int duration = 0.5; // duration in seconds
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [toast dismissWithClickedButtonIndex:0 animated:YES];
    });
}

- (IBAction)chooseDestroyer:(id)sender {
    NSLog(@"chooseDestroyer");
    shipColor = [UIColor yellowColor];
    sColor = @"yellowColor";

    shipCnt = 3;
    shipElementCnt = 2;
    shipName = @"Destroyer";
    isPressed = YES;
    mySettingsSet = [[NSMutableSet alloc]init];
    
    UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"3 Destroyer"
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil, nil];
    [toast show];
    
    int duration = 0.5; // duration in seconds
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [toast dismissWithClickedButtonIndex:0 animated:YES];
    });
}

- (IBAction)chooseSubmarine:(id)sender {
    NSLog(@"chooseSubmarine");
    shipColor = [UIColor greenColor];
    sColor = @"greenColor";
    
    shipCnt = 4;
    shipElementCnt = 1;
    shipName = @"Submarine";
    isPressed = YES;
    mySettingsSet = [[NSMutableSet alloc]init];
    
    UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"4 Submarine"
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil, nil];
    [toast show];
    
    int duration = 0.5; // duration in seconds
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [toast dismissWithClickedButtonIndex:0 animated:YES];
    });
}

-(void) reachOutListWithResultSender:(id<myBattleshipReachOutListResultSender>)resultSender andMsg:(Battleship *)msg{
    
    NSLog(@"Message recieved %@", [msg getMyMsg]);
    
    // This is the reciept we send back to the instance that sent us a message
    // Here we say all is OK
    [resultSender success];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    GameViewController *gvc = (GameViewController*)segue.destinationViewController;
    gvc.gameBoard = gameBoard;
    gvc.tmpPlayerHitList = tmpPlayerHitList;
}

@end