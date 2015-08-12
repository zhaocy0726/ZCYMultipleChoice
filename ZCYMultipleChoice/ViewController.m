//
//  ViewController.m
//  ZCYMultipleChoice
//
//  Created by zhaochunyang on 15/8/5.
//  Copyright (c) 2015年 zhaochunyang. All rights reserved.
//

#import "ViewController.h"
#import "PersonsListCell.h"
#import "SelectedPersonsCollectionCell.h"
#import "NSString+Util.h"

#define SCREEN_BOUNDS_SIZE_WIDTH [UIScreen mainScreen].bounds.size.width

@interface ViewController ()
<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewSelectedPersons;
@property (strong, nonatomic) IBOutlet UITableView *tableViewPersonsList;
@property (strong, nonatomic) IBOutlet UISearchBar *seachBarSearchPersons;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectionWidthConstraint;

@property (assign, nonatomic) BOOL showSearchResult; // 显示搜索结果列表

@property (assign, nonatomic) NSInteger showFriendsNumber; // 显示选中人的数量

#pragma mark - 数据相关
@property (strong, nonatomic) NSMutableArray *arrayIndexTitles;     // 字母索引
@property (strong, nonatomic) NSMutableArray *arrayIndexCharacter;  // 数据字典，对应索引
@property (strong, nonatomic) NSMutableArray *arraySelectedPersons; // 选中的人
@property (strong, nonatomic) NSMutableArray *arraySearchedPersons; // 搜索出来的人
@property (strong, nonatomic) NSMutableDictionary *dictionaryPerson; // 数据源字典

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//     Do any additional setup after loading the view, typically from a nib.

    [self choicePhoneModel];
    self.showSearchResult = NO;
    
    // 假数据-——————用完删除（有真数据以后就删除）
    for (NSInteger index = 0; index < 20; index++){
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"IMG_%@", @(index + 1498)]];
        NSString *title;
        if (index < 5) {
            title = [NSString stringWithFormat:@"王%@",@(index)];
        }
        else if (index < 12){
            title = [NSString stringWithFormat:@"赵%@", @(index)];
        }
        else if (index < 17){
            title = [NSString stringWithFormat:@"别%@", @(index)];
        }
        else {
            title = [NSString stringWithFormat:@"%@", @(index)];
        }
        NSDictionary *dic = @{@"image": image, @"name":title};
        [self.arrayPersons addObject:dic];
    }
    [self handleArrayToOrderWithArray:_arrayPersons];

    [self.collectionViewSelectedPersons registerClass:[SelectedPersonsCollectionCell class] forCellWithReuseIdentifier:@"CollectionCell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 去除searchbar边框线
    self.seachBarSearchPersons.layer.borderWidth = 1;
    self.seachBarSearchPersons.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    // 索引背景透明
    self.tableViewPersonsList.sectionIndexBackgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  根据手机型号获取显示选中的人的数量
 */
- (void)choicePhoneModel{
    if (SCREEN_BOUNDS_SIZE_WIDTH == 320)
        self.showFriendsNumber = 5;
    else if (SCREEN_BOUNDS_SIZE_WIDTH == 375)
        self.showFriendsNumber = 6;
    else
        self.showFriendsNumber = 7;
}

#pragma mark -
#pragma mark ---------- tableView dataSource ----------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowNumber = 0;
    if (_showSearchResult)
        rowNumber = _arraySearchedPersons.count;
    else {
        if (self.arrayIndexCharacter.count > section) {
            NSMutableArray *arrayTemp = (NSMutableArray *)[self.dictionaryPerson objectForKey:[self.arrayIndexCharacter objectAtIndex:section]];
            rowNumber = arrayTemp.count;
        }
    }
    return rowNumber;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonsListCell *cell = (PersonsListCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    NSDictionary *dic;
    if (_showSearchResult) {
        dic = _arraySearchedPersons[indexPath.row];
        
        // 解决复用问题，每次都要判断下是否选中
        cell.isSelected = [_arraySelectedPersons containsObject:_arraySearchedPersons[indexPath.row]];
    }
    else {
        if (self.arrayIndexCharacter.count > indexPath.section) {
            NSMutableArray *arrayTemp = (NSMutableArray *)[self.dictionaryPerson objectForKey:[self.arrayIndexCharacter objectAtIndex:indexPath.section]];
            if (arrayTemp.count > indexPath.row) {
                dic = [arrayTemp objectAtIndex:indexPath.row];
            }
        }
    }
    cell.isSelected = [_arraySelectedPersons containsObject:_arrayPersons[indexPath.row]];
    
    [cell configUserNameWithName:dic];
    return cell;
}

#pragma mark ---------- 索引相关 ----------

// 处理数组，按字母排序
- (void)handleArrayToOrderWithArray:(NSArray *)array
{
    if (array) {
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *dic = obj;
            if (![NSString isEmpty:dic[@"name"]]) {
                // 已经遍历过，不需要在遍历
                *stop = YES;
            }
            
            self.arrayPersons = [NSMutableArray arrayWithArray:[array sortedArrayUsingFunction:nickNameSort context:NULL]];
            
            if (_dictionaryPerson) {
                [self.dictionaryPerson removeAllObjects];
                self.dictionaryPerson = nil;
            }
            self.dictionaryPerson = [NSMutableDictionary dictionary];
            
            if (_arrayIndexCharacter) {
                [self.arrayIndexCharacter removeAllObjects];
                self.arrayIndexCharacter = nil;
            }
            self.arrayIndexCharacter = [NSMutableArray array];
            
            [self.arrayPersons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary *dictionary = obj;
                if (dictionary) {
                    NSString *firstLetter = [NSString firstLetter:dictionary[@"name"]];
                    if ([self.dictionaryPerson.allKeys containsObject:firstLetter]) {
                        NSMutableArray *arrayTemp = (NSMutableArray *)[self.dictionaryPerson objectForKey:firstLetter];
                        if (arrayTemp) {
                            [arrayTemp addObject:obj];
                        }
                    }
                    else {
                        NSMutableArray *arrayTemp = [NSMutableArray arrayWithObjects:obj, nil];
                        [self.dictionaryPerson setObject:arrayTemp forKey:firstLetter];
                        [self.arrayIndexCharacter addObject:firstLetter];
                    }
                }
            }];
        }];
    }
}

/**
 * 按 名称排序
 */
NSInteger nickNameSort(NSDictionary *contact1, NSDictionary *contact2, void *context)
{
    NSString *name1 = contact1[@"name"] ;
    NSString *name2 = contact2[@"name"] ;
    NSString *name1FirstChac = [NSString firstLetter:name1];
    NSString *name2FirstChac = [NSString firstLetter:name2];
    
    NSComparisonResult result1 = [name1 localizedCompare:name2] ;
    NSComparisonResult result2 = [name1FirstChac compare:name2FirstChac] ;
    
    if ([name1FirstChac isEqualToString:@"#"] && ![name2FirstChac isEqualToString:@"#"]) {
        return NSOrderedDescending;
    }
    else if (![name1FirstChac isEqualToString:@"#"] && [name2FirstChac isEqualToString:@"#"]) {
        return NSOrderedAscending;
    }
    
    if (result1 != result2) {
        return result2 ;
    }
    return  result1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sectionNumber = 1;
    if (_showSearchResult == NO) {
        sectionNumber = _arrayIndexCharacter.count;
    }
    return sectionNumber;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (_showSearchResult) {
        return nil;
    }
    return _arrayIndexCharacter.count <= 1 ? nil : self.arrayIndexCharacter;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSInteger count = 0;
    for (NSString *character in _arrayIndexCharacter) {
        if([character isEqualToString:title]) {
            return count;
        }
        count ++;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title;
    title = [NSString stringWithFormat:@"%@", [_arrayIndexCharacter objectAtIndex:section]];
    return title;
}

#pragma mark -
#pragma mark ---------- tableView delegate ----------

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonsListCell *cell = (PersonsListCell *)[self.tableViewPersonsList cellForRowAtIndexPath:indexPath];
    [cell configSelected:!cell.isSelected];
    if (cell.isSelected == NO) {
        if (_showSearchResult)
            [self.arraySelectedPersons removeObject:[_arraySearchedPersons objectAtIndex:indexPath.row]];
        else
            [self.arraySelectedPersons removeObject:[_arrayPersons objectAtIndex:indexPath.row]];
        
        [UIView animateWithDuration:.2f animations:^{
            [self updateCollectionUISelectedPersons];
        }];
    }
    else {
        if (_showSearchResult)
            [self.arraySelectedPersons addObject:[_arraySearchedPersons objectAtIndex:indexPath.row]];
        else
            [self.arraySelectedPersons addObject:[_arrayPersons objectAtIndex:indexPath.row]];
        
        [UIView animateWithDuration:.2f animations:^{
            [self updateCollectionUISelectedPersons];
            if (_arraySelectedPersons.count > _showFriendsNumber) {
                // 滑到最右边
                [self.collectionViewSelectedPersons scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:(_arraySelectedPersons.count - 1) inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
            }
        }];
    }
}

// 刷新添加的好友
- (void)updateCollectionUISelectedPersons
{
    if (_arraySelectedPersons.count == 0)
        self.collectionWidthConstraint.constant = 0;
    else {
        if (_arraySelectedPersons.count < _showFriendsNumber)
            self.collectionWidthConstraint.constant = _arraySelectedPersons.count*38 + (_arraySelectedPersons.count - 1)*5 + 5;
        else
            self.collectionWidthConstraint.constant = _showFriendsNumber*38 + (_showFriendsNumber - 1)*5 + 5;
    }
    
    [self.view updateConstraints];
    [self.collectionViewSelectedPersons reloadData];
}

#pragma mark -
#pragma mark ---------- collection dataSource ----------

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _arraySelectedPersons.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SelectedPersonsCollectionCell *cell = (SelectedPersonsCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    
    NSDictionary *dic = _arraySelectedPersons[indexPath.row];
    [cell configUserNameWithName:dic];

    return cell;
}

#pragma mark -
#pragma mark ---------- searchBar delegate ----------

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (self.arrayPersons && self.arrayPersons.count > 0) {
        if (searchText && searchText.length > 0) {
            [self searchPersonsWithName:searchText];
            self.showSearchResult = YES;
        }
        else
            self.showSearchResult = NO;
    }
    
    [self.tableViewPersonsList reloadData];
}


- (void)searchPersonsWithName:(NSString *)name
{
    if (self.arraySearchedPersons && self.arraySearchedPersons.count > 0) {
            [self.arraySearchedPersons removeAllObjects];
    }
    
    self.arraySearchedPersons = [NSMutableArray array];
    
    [_arrayPersons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        BOOL contrainUser = NO;
        NSDictionary *dic = obj;
        NSMutableString *customName = [NSMutableString string];
        NSString *username = dic[@"name"];
        NSString *temp = nil;
        
        for (NSInteger i = 0; i < username.length; i++) {
            temp = [username substringWithRange:NSMakeRange(i, 1)];
            if ([NSString isEmpty:temp]) {
                [customName appendString:temp];
            }
            else {
                NSString *firstLetter = [NSString firstLetter:temp];
                if ([firstLetter isEqualToString:@"#"]) {
                    [customName appendString:temp];
                }
                else {
                    [customName appendString:firstLetter];
                }
            }
        }
        contrainUser = ([username rangeOfString:name].location != NSNotFound);
        contrainUser = contrainUser || ([customName rangeOfString:[name uppercaseString]].location != NSNotFound);
        
        if (name) {
            contrainUser = contrainUser || ([customName rangeOfString:name].location != NSNotFound);
        }
        
        if (contrainUser) {
            [self.arraySearchedPersons addObject:dic];
        }
    }];
    
    NSLog(@"%@", self.arraySearchedPersons);
}

#pragma mark -
#pragma mark ---------- 属性 ----------

- (NSMutableArray *)arrayPersons
{
    if (_arrayPersons == nil) {
        _arrayPersons = [NSMutableArray array];
    }
    return _arrayPersons;
}

- (NSMutableArray *)arrayIndexTitles
{
    if (_arrayIndexTitles == nil) {
        _arrayIndexTitles = [NSMutableArray arrayWithArray:[NSString indexLetters]];
    }
    return _arrayIndexTitles;
}

- (NSMutableArray *)arraySearchedPersons
{
    if (_arraySearchedPersons == nil) {
        _arraySearchedPersons = [NSMutableArray array];
    }
    return _arraySearchedPersons;
}

- (NSMutableArray *)arraySelectedPersons
{
    if (_arraySelectedPersons == nil) {
        _arraySelectedPersons = [NSMutableArray array];
    }
    return _arraySelectedPersons;
}

- (NSMutableArray *)arrayIndexCharacter
{
    if (_arrayIndexCharacter == nil) {
        _arrayIndexCharacter = [NSMutableArray array];
    }
    return _arrayIndexCharacter;
}

@end
