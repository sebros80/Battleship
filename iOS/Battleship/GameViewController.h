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
//  GameViewController.h
//  Battleship
//
//  Created by Sebastian Rosner on 20/11/2014.
//  Copyright (c) 2014 Sebastian Rosner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ViewController.h"
#import "GameCollectionViewCell.h"
#import "ViewController.h"



@interface GameViewController : UICollectionViewController<UICollectionViewDataSource,
                    UICollectionViewDelegate,
                    UICollectionViewDelegateFlowLayout,
                    UIAlertViewDelegate,
                    myBattleshipReachOutRequestReceiver,
                    myBattleshipReachOutResultReceiver> {
    
}

@property (strong, nonatomic) NSArray *myTmpPlayerHitList;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (strong, nonatomic) NSMutableDictionary* gameBoard;
@property (strong, nonatomic) NSArray* tmpPlayerHitList;
- (void)buttonPressed:(NSInteger)buttonIndex;
@end