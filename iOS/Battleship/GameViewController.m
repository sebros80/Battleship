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
//  GameViewController.m
//  Battleship
//
//  Created by Sebastian Rosner on 20/11/2014.
//  Copyright (c) 2014 Sebastian Rosner. All rights reserved.
//

#import "GameViewController.h"
#import "BattleshipSvcGen.h"


@interface GameViewController () {
    NSArray *itemsArray;
    NSString *player1;
    NSString *player2;
    NSMutableArray *tmpItems;
    int hitShipsCnt;
    Boolean turn;
    Boolean isHit;
    NSString *hitedShip;
    NSUserDefaults *userDefaults;
    NSMutableDictionary *myGameBoard;
    NSMutableSet *tmpSet;
}

@end

@implementation GameViewController

@synthesize gameBoard;
@synthesize tmpPlayerHitList;
@synthesize statusLabel;
@synthesize myTmpPlayerHitList;

- (void)buttonPressed:(NSInteger)buttonIndex
{
    [self worker:buttonIndex];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.collectionView registerNib:[UINib nibWithNibName:@"GameCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"MyCustomCell"];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        ViewController *startVC = (ViewController *)[storyboard instantiateViewControllerWithIdentifier:@"startVC"];

        [self.navigationController pushViewController:startVC animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    myGameBoard = [[NSMutableDictionary alloc] initWithDictionary:gameBoard copyItems:YES];
    myTmpPlayerHitList = [[NSArray alloc] initWithArray:tmpPlayerHitList copyItems:YES];
    
    tmpSet = [[NSMutableSet alloc]init];
    
    self.collectionView.delegate = self;
    
    [myBattleshipSvc registerReachOutRequestReceiver:self];
    
    [myBattleshipSvc registerReachOutRequestHandler:^void(id<myBattleshipReachOutResultSender> resultsender, Battleship *myMsg2u)
     {
         NSLog(@"Message recieved %@", [myMsg2u getMyMsg]);
         if([[myMsg2u getMyMsg] containsString:@"is the winner"]){
             UIAlertView* info = [[UIAlertView alloc] init];
             [info setTitle:@"Sorry"];
             [info setMessage:[NSString stringWithFormat:@"%@ !!!",[myMsg2u getMyMsg]]];
             [info addButtonWithTitle:@"New Game"];
             [info show];
         }
         
         [resultsender success];
         
         for(int i = 0; i<= [itemsArray count]-1; i++){
             if([[myMsg2u getMyMsg] isEqualToString:[itemsArray objectAtIndex:i]]){
                 hitedShip = [myMsg2u getMyMsg];
                 [tmpItems addObject:[myMsg2u getMyMsg]];
                 
                 if([tmpItems count] != 0){
                     for(NSString * item in tmpItems){
                         if([item isEqualToString: [itemsArray objectAtIndex:i] ]){
                             if(myGameBoard != nil && [myGameBoard count]>0 ){
                                 for(NSString* key in myGameBoard) {
                                     
                                     NSMutableSet *shipsArray = [myGameBoard objectForKey:key];
                                     
                                     if( [shipsArray count] > 0){
  
                                         for(NSString * ship in shipsArray){
                                             if([ship isEqualToString:[itemsArray objectAtIndex:i]]){
                                                 if([item isEqualToString:ship]){
                                                     turn = NO;
                                                 }
                                             }
                                         }
                                         [self.statusLabel setText:@"Your turn"];
                                     }
                                 }
                             }
                         }
                     }
                 }
             }
         }
     }];
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    
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
    
    
    tmpItems = [[NSMutableArray alloc] init];
    hitShipsCnt = 1;
    turn = NO;
    isHit = NO;
    hitedShip = @"";
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
    
    NSLog(@"Index path : %d",indexPath.row );
    
    GameCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyCustomCell" forIndexPath:indexPath];
    
    cell.itemButton = (UIButton*)[cell.contentView viewWithTag:100];
    cell.itemButton.layer.borderWidth = 0.8;
    cell.itemButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.buttonId = indexPath.row;
    
    if([[itemsArray objectAtIndex:cell.buttonId] isEqualToString:@" "] || [[itemsArray objectAtIndex:cell.buttonId] isEqualToString:@"1"] ||
       [[itemsArray objectAtIndex:cell.buttonId] isEqualToString:@"2"] || [[itemsArray objectAtIndex:cell.buttonId] isEqualToString:@"3"] ||
       [[itemsArray objectAtIndex:cell.buttonId] isEqualToString:@"4"] || [[itemsArray objectAtIndex:cell.buttonId] isEqualToString:@"5"] ||
       [[itemsArray objectAtIndex:cell.buttonId] isEqualToString:@"6"] || [[itemsArray objectAtIndex:cell.buttonId] isEqualToString:@"7"] ||
       [[itemsArray objectAtIndex:cell.buttonId] isEqualToString:@"8"] || [[itemsArray objectAtIndex:cell.buttonId] isEqualToString:@"9"] ||
       [[itemsArray objectAtIndex:cell.buttonId] isEqualToString:@"10"] || [[itemsArray objectAtIndex:cell.buttonId] isEqualToString:@"A"] ||
       [[itemsArray objectAtIndex:cell.buttonId] isEqualToString:@"B"] || [[itemsArray objectAtIndex:cell.buttonId] isEqualToString:@"C"] ||
       [[itemsArray objectAtIndex:cell.buttonId] isEqualToString:@"D"] || [[itemsArray objectAtIndex:cell.buttonId] isEqualToString:@"E"] ||
       [[itemsArray objectAtIndex:cell.buttonId] isEqualToString:@"F"] || [[itemsArray objectAtIndex:cell.buttonId] isEqualToString:@"G"] ||
       [[itemsArray objectAtIndex:cell.buttonId] isEqualToString:@"H"] || [[itemsArray objectAtIndex:cell.buttonId] isEqualToString:@"I"] ||
       [[itemsArray objectAtIndex:cell.buttonId] isEqualToString:@"J"]){

        [cell.itemButton setEnabled:NO];
        [cell.itemButton setBackgroundColor:[UIColor lightTextColor]];
        [cell.itemButton setTintColor:[UIColor redColor]];
        
        NSString *str = @"";
        str =[itemsArray objectAtIndex:cell.buttonId];
        
        [cell.itemButton setTitle:str forState:UIControlStateNormal];

    } else {
        cell.viewController = self;
        [cell.itemButton setEnabled:YES];
        
        for(NSString* key in myGameBoard) {
            
            NSMutableSet *value = [myGameBoard objectForKey:key];
            
            for(NSString* s in value) {
                
                if([[itemsArray objectAtIndex:indexPath.row] isEqualToString:s]){
                    
                    [cell.itemButton setTitle:s forState:UIControlStateNormal];
                    
                    //NSLog(@"BBBB item : %d, %@ ",cell.buttonId, s);
                    
                    if([key isEqualToString:@"blueColor"]){
                        cell.backgroundColor =[UIColor blueColor];
                    } else if([key isEqualToString:@"redColor"]){
                        cell.backgroundColor =[UIColor redColor];
                    } else if([key isEqualToString:@"yellowColor"]){
                        cell.backgroundColor =[UIColor yellowColor];
                    } else if([key isEqualToString:@"greenColor"]){
                        cell.backgroundColor =[UIColor greenColor];
                    } else if([key isEqualToString:@"blackColor"]){
                        [cell.itemButton setTitle:@"+" forState:UIControlStateNormal];
                        [cell.itemButton setBackgroundColor:[UIColor blackColor]];
                    }
                }
            }
        }
        [cell.itemButton setBackgroundColor:[UIColor whiteColor]];
    }

    return cell;
}


- (void) worker:(NSInteger) index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    
    UICollectionViewCell *datasetCell =[self.collectionView cellForItemAtIndexPath:indexPath];
    datasetCell.backgroundColor = [UIColor blackColor]; // highlight selection
    
    NSLog(@"didSelectItemAtIndexPath %@", [itemsArray objectAtIndex:indexPath.row]);

    [tmpSet addObject:[itemsArray objectAtIndex:indexPath.row]];
    [myGameBoard setObject:tmpSet forKey:@"blackColor"];

    [self.collectionView cellForItemAtIndexPath:indexPath];

    Battleship *battleship = [[Battleship alloc] init];
    [battleship setMyMsg:[itemsArray objectAtIndex:indexPath.row]];
    
    NSString * nameplayer2= [[NSUserDefaults standardUserDefaults] objectForKey:@"PLAYER2"];
    
    [myBattleshipSvc sendReachOutUsingResultReceiver:self andDestination:nameplayer2 withMsg:battleship];
    
    
    NSString *message = [itemsArray objectAtIndex:indexPath.row];
    
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
    datasetCell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bomb_icon.png"]];
    
    for(NSString *s in myTmpPlayerHitList){
        NSString * tmp =[itemsArray objectAtIndex:indexPath.row];
       
        if([s isEqualToString:tmp]){
            
            if(hitShipsCnt == 20){
                //new game
                Battleship *b = [[Battleship alloc]init];
                NSString * nameplayer1= [[NSUserDefaults standardUserDefaults] objectForKey:@"PLAYER1"];
                NSString *msg = [NSString stringWithFormat:@"%@ is the winner",nameplayer1];
                [b setMyMsg:msg];
            
                [myBattleshipSvc sendReachOutUsingResultReceiver:self andDestination:nameplayer2 withMsg:b];
            }

            datasetCell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bomb_icon.png"]];
            isHit = YES;
            hitShipsCnt++;
        }
    }
    
    if(isHit && !turn){
        isHit = NO;
    }
    
    [self.statusLabel setText:[NSString stringWithFormat:@"Now %@",nameplayer2]];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}

- (IBAction)itemPressed:(UIButton *)sender {
    NSLog(@"The button title is %@",sender.titleLabel.text);
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

-(void) reachOutWithResultSender:(id<myBattleshipReachOutResultSender>)resultSender andMsg:(Battleship *)msg{
    
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
}

@end