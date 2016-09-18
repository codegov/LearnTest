//
//  LeetcodeViewController.m
//  LearnTest
//
//  Created by syq on 15/8/12.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import "LeetcodeViewController.h"

@interface LeetcodeViewController ()

@end

@implementation LeetcodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    int a[] = {1, 1, 1, 2, 2, 3};
//    int length = removeDuplicates(a, sizeof(a)/sizeof(int));
//    NSLog(@"length = %@", @(length));
//    for (int i = 0; i < length; i++) {
//        NSLog(@"%@", @(a[i]));
//    }

//    int a[] = {1, 1, 1, 2, 2, 3};
//    int length = removeDuplicates2(a, sizeof(a)/sizeof(int));
//    NSLog(@"length = %@", @(length));
//    for (int i = 0; i < length; i++) {
//        NSLog(@"%@", @(a[i]));
//    }
    
    
//    int a[] = {5,6,7,8,0,1,2,3,4};
//    int index = searchValue(a, sizeof(a)/sizeof(int), 1);
//    NSLog(@"index==%d", index);
    
//    int a[] = {5,5,5,6,7,8,0,1,2,3,4,5};
//    int index = searchValue2(a, sizeof(a)/sizeof(int), 1);
//    NSLog(@"index==%d", index);
    
//    int a[] = {18};
//    int b[] = {2,4,5,6,7,10,12,13};
//    double value = findMedianSoortedArrays(a, sizeof(a)/sizeof(int), b, sizeof(b)/sizeof(int));
//    NSLog(@"value == %@", @(value).stringValue);
    
//    NSArray *array = [[NSArray alloc] initWithObjects:@"100", @"4", @"200", @"1", @"3", @"2", nil];
//    NSInteger length = [self longestConsecutive:array];
//    NSInteger length = [self longestConsecutive2:array];
//    NSLog(@"length == %@", @(length).stringValue);
    
    
//    NSArray *array = [[NSArray alloc] initWithObjects:@"2", @"7", @"5", @"4", @"5", @"11", @"15", nil];
//    NSArray *list = [self twoSum:array target:9];
//    NSLog(@"list==%@", list);
    
//    NSArray *array = [[NSArray alloc] initWithObjects:@"-1", @"0", @"1", @"2", @"-1", @"-4", nil];
//    NSArray *res = [self threeSum:array];
//    NSLog(@"res ===%@",res);
    
//    NSArray *array = @[@"-1", @"2", @"1", @"-4"];
//    NSInteger target = 1;
//    NSInteger num = [self threeSumClosest:array target:target];
//    NSLog(@"num = %@", @(num).stringValue);
    
//    NSArray *array = @[@"1", @"0", @"-1", @"0", @"-2", @"2"];
//    int target = 0;
//    NSArray *res = [self fourSum:array target:target];
//    NSLog(@"res==%@", res);
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:@"1", @"2", @"1", @"1", @"4", @"3", @"5", nil];
    int length = [self removeElement:array elem:@"1"];
    NSLog(@"length === %@", @(length).stringValue);
}





/**
 2.1.1 Remove Duplicates from Sorted Array 从排序数组中删除重复
 描述
 Given a sorted array, remove the duplicates in place such that each element appear only once and return the new length.
 Do not allocate extra space for another array, you must do this in place with constant memory.
 For example, Given input array A = [1,1,2],
 Your function should return length = 2, and A is now [1,2].
 给定一个排序的数组，删除重复的地方，这样，每个元素只出现一次，并返回新的长度。要求时间复杂度O(n),空间复杂度O(1)
 例如，给定的输入数组a[1,1,2]，你的函数应该返回length= 2，和now[1,2]。
 */

int removeDuplicates(int a[], int count)
{
    if (count <= 0) return 0;
    int index = 0;
    for (int i = 1; i < count; i++)
    {
        if (a[i] != a[index])
        {
            a[++index] = a[i];
        }
    }
    return index+1;
}

/**
 2.1.2 Remove Duplicates from Sorted Array II
 描述
 Follow up for ”Remove Duplicates”: What if duplicates are allowed at most twice? For example, Given sorted array A = [1,1,1,2,2,3],
 Your function should return length = 5, and A is now [1,1,2,2,3]
 */

int removeDuplicates2(int a[], int count)
{
    int num = 2;
    if (count <= num) return count;
    
    int index = num;
    for (int i = num; i < count; i++)
    {
        if (a[i] != a[index - num])
        {
            a[index++] = a[i];
        }
    }
    return index;
}

/**
 2.1.3 Search in Rotated Sorted Array 在一个被旋转的排序数组中搜索
 描述
 Suppose a sorted array is rotated at some pivot unknown to you beforehand.
 ￼
 2.1 数组 5
 ￼(i.e., 0 1 2 4 5 6 7 might become 4 5 6 7 0 1 2).
 You are given a target value to search. If found in the array return its index, otherwise return -1. You may assume no duplicate exists in the array.
 */

int searchValue(int a[], int count, int searchValue)
{
    int first = 0;
    int last = count;
    while (first != last)
    {
        int mid = first  + (last - first) / 2;
        if (a[mid] == searchValue) return mid;
        
        if (a[first] <= a[mid])
        {
            if (a[first] <= searchValue && searchValue < a[mid])
                last = mid;
            else
                first = mid + 1;
        } else
        {
            if (a[mid] < searchValue && searchValue <= a[last-1])
                first = mid + 1;
            else
                last = mid;
        }
    }
    return -1;
}

/**
 2.1.4 Search in Rotated Sorted Array II
 描述
 Follow up for ”Search in Rotated Sorted Array”: What if duplicates are allowed? Would this affect the run-time complexity? How and why?
 Write a function to determine if a given target is in the array.
 */

int searchValue2(int a[], int count, int searchValue)
{
    int first = 0;
    int last = count;
    while (first != last)
    {
        int mid = first  + (last - first) / 2;
        if (a[mid] == searchValue) return mid;
        
        if (a[first] < a[mid])
        {
            if (a[first] <= searchValue && searchValue < a[mid])
                last = mid;
            else
                first = mid + 1;
        } else if (a[first] > a[mid])
        {
            if (a[mid] < searchValue && searchValue <= a[last-1])
                first = mid + 1;
            else
                last = mid;
        } else
        {
            first ++;
        }
    }
    return -1;
}

/**
 2.1.5 Median of Two Sorted Arrays
 描述
 There are two sorted arrays A and B of size m and n respectively. Find the median of the two sorted arrays. The overall run time complexity should be O(log(m + n)).
 */
double findMedianSoortedArrays(int A[], int m, int B[], int n)
{
    int total = m + n;
    if (total & 0x1) { // 奇数
        return find_kth(A, m, B, n, total/2 + 1);
    } else
    {
        return (find_kth(A, m, B, n, total/2) + find_kth(A, m, B, n, total/2 + 1)) / 2.0;
    }
}

int find_kth(int A[], int m, int B[], int n, int k)
{
    if (m > n)  return find_kth(B, n, A, m, k);
    if (m == 0) return B[k - 1];
    if (k == 1) return MIN(A[0], B[0]);
    
    int ia = MIN(k/2, m), ib = k - ia;
    if (A[ia - 1] < B[ib - 1]) {
        return find_kth(A + ia, m - ia, B, n, k - ia);
    } else if (A[ia - 1] > B[ib - 1])
    {
        return find_kth(A, m, B + ib, n - ib, k - ib);
    } else
    {
        return A[ia - 1];
    }
}

/**
 2.1.6 Longest Consecutive Sequence
 描述
 Given an unsorted array of integers, find the length of the longest consecutive elements sequence.
 For example, Given [100, 4, 200, 1, 3, 2], The longest consecutive elements sequence is [1, 2, 3, 4]. Return its length: 4.
 Your algorithm should run in O(n) complexity.
 在一个非排序的数组中，找出元素连续最长的个数。比如，数组[100, 4, 200, 1, 3, 2]，最长的连续元素为[1, 2, 3, 4],返回长度为4.要求复杂度O(n)
 */

- (NSInteger)longestConsecutive:(NSArray *)array
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    NSInteger longest = 0;
    for (NSString *key in array)
    {
        [dic setObject:@(YES) forKey:key];
        
        NSInteger length = 1;
        for (NSInteger j = key.integerValue + 1; [dic objectForKey:@(j).stringValue]; ++j) ++length;
        for (NSInteger j = key.integerValue - 1; [dic objectForKey:@(j).stringValue]; --j) ++length;
        
        longest = MAX(longest, length);
    }
    return longest;
}

- (NSInteger)longestConsecutive2:(NSArray *)array
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSInteger size = array.count;
    NSInteger l = 1;
    for (NSInteger i = 0; i < size; i++)
    {
        NSString *key = [array objectAtIndex:i];
        [dic setObject:@(1) forKey:key];

        NSString *left = @(key.integerValue - 1).stringValue;
        if ([dic objectForKey:left])
        {
            l = MAX(l, [self mergeCluster:dic left:left right:key]);
        }
        
        NSString *right = @(key.integerValue + 1).stringValue;
        if ([dic objectForKey:right])
        {
            l = MAX(l, [self mergeCluster:dic left:key right:right]);
        }
    }
    return size == 0 ? 0 : l;
}


- (NSInteger)mergeCluster:(NSDictionary *)dic left:(NSString *)left right:(NSString *)right
{
    NSInteger upper = right.integerValue + [[dic objectForKey:right] integerValue] - 1;
    NSInteger lower = left.integerValue - [[dic objectForKey:left] integerValue] + 1;
    NSInteger length = upper - lower + 1;
    [dic setValue:@(length) forKey:@(upper).stringValue];
    [dic setValue:@(length) forKey:@(lower).stringValue];
    return length;
}


/**
 2.1.7 Two Sum
 描述
 Given an array of integers, find two numbers such that they add up to a specific target number.
 The function twoSum should return indices of the two numbers such that they add up to the target, where index1 must be less than index2. Please note that your returned answers (both index1 and index2) are not zero-based.
 You may assume that each input would have exactly one solution. Input: numbers={2, 7, 11, 15}, target=9
 Output: index1=1, index2=2
 从数组中找出两个元素，它们之和为target，返回它们的下标。例如：Input: numbers={2, 7, 11, 15}, target=9 Output: index1=1, index2=2 要求复杂度为O(n)。
 */

- (NSArray *)twoSum:(NSArray *)array target:(NSInteger)target
{
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    for (NSInteger i = 0; i < array.count; i++) {
        NSString *key = [array objectAtIndex:i];
        [dic setObject:@(i) forKey:key];
    }
    for (NSInteger i = 0; i < array.count; i++) {
        NSString *key = [array objectAtIndex:i];
        NSInteger gap = target - key.integerValue;
        NSInteger find = [[dic objectForKey:@(gap).stringValue] integerValue];
        if (find > i)
        {
            [resultList addObject:@(i + 1)];
            [resultList addObject:@(find + 1)];
        }
    }
    return resultList;
}

/**
 2.1.8 3Sum
 描述
 Given an array S of n integers, are there elements a,b,c in S such that a + b + c = 0? Find all unique triplets in the array which gives the sum of zero.
 Note:
 • Elements in a triplet (a, b, c) must be in non-descending order. (ie, a ≤ b ≤ c) • Thesolutionsetmustnotcontainduplicatetriplets.
 For example, given array S = {-1 0 1 2 -1 -4}.
 A solution set is:
 (-1, 0, 1)
 (-1, -1, 2)
 */

- (NSArray *)threeSum:(NSArray *)array
{
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    
    if (array.count < 3) {
        return resultList;
    }
    array = [array sortedArrayUsingSelector:@selector(compare:)];

    int target = 0;
    
    NSInteger last = array.count;
    for (NSInteger i = 0; i < last - 2; ++i)
    {
        NSInteger j = i + 1;
        if (i > 0 && array[i] == array[i - 1]) continue; // 将开始相同的数，过滤掉
        
        NSInteger k = last -1;
        while (j < k)
        {
            NSInteger res = [array[i] integerValue] + [array[j] integerValue] + [array[k] integerValue];
            if (res < target) {
                ++j;
                while (array[j] == array[j - 1] && j < k) ++j;
            } else if (res > target)
            {
                --k;
                while (array[k] == array[k + 1] && j < k) --k;
            } else
            {
                [resultList addObject:@[array[i], array[j], array[k]]];
                ++j;
                --k;
                while (array[j] == array[j - 1] && array[k] == array[k + 1] && j < k) ++j;
            }
        }
    }
    return resultList;
}


/**
 2.1.9 3Sum Closest
 描述
 Given an array S of n integers, find three integers in S such that the sum is closest to a given number, target. Return the sum of the three integers. You may assume that each input would have exactly one solution.
 For example, given array S = {-1 2 1 -4}, and target = 1. Thesumthatisclosesttothetargetis2. (-1+2+1=2).
 */

- (NSInteger)threeSumClosest:(NSArray *)array target:(NSInteger)target
{
    NSInteger result = 0;
    NSInteger min_gap = INT_MAX;
    
    array = [array sortedArrayUsingSelector:@selector(compare:)];
    for (int a = 0; a < array.count -  2; a++)
    {
        NSInteger b = a + 1;
        NSInteger c = array.count - 1;
        
        while (b < c)
        {
            NSInteger sum = [array[a] integerValue] + [array[b] integerValue] + [array[c] integerValue];
            NSInteger gap = labs(sum - target);
            
            if (gap < min_gap)
            {
                result = sum;
                min_gap = gap;
            }
            
            if (sum < target)
            {
                ++b;
            } else
            {
                --c;
            }
        }
    }
    return result;
}

/**
 2.1.10 4Sum
 描述
 Given an array S of n integers, are there elements a, b, c, and d in S such that a + b + c + d = target? Find all unique quadruplets in the array which gives the sum of target.
 Note:
 • Elements in a quadruplet (a, b, c, d) must be in non-descending order. (ie, a ≤ b ≤ c ≤ d) • Thesolutionsetmustnotcontainduplicatequadruplets.
 For example, given array S = {1 0 -1 0 -2 2}, and target = 0.
 A solution set is:
 (-1,  0, 0, 1)
 (-2, -1, 1, 2)
 (-2,  0, 0, 2)
 */

- (NSArray *)fourSum:(NSArray *)array target:(int)target
{
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    if (array.count < 4) return resultList;
    
    array = [array sortedArrayUsingSelector:@selector(compare:)];
    
    NSInteger last = array.count;
    for (int a = 0; a < last - 3; ++a)
    {
        for (int b = a + 1; b < last - 2; ++b)
        {
            NSInteger c = b + 1;
            NSInteger d = last - 1;
            while (c < d)
            {
                NSInteger sum = [array[a] integerValue] + [array[b] integerValue] + [array[c] integerValue] + [array[d] integerValue];
                if (sum < target) {
                    ++c;
                } else if (sum > target)
                {
                    --d;
                } else
                {
                    NSArray *res = @[array[a], array[b], array[c], array[d]];
                    res = [res sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                        if ([obj1 integerValue] > [obj2 integerValue]) {
                            return NSOrderedDescending;
                        } else
                        {
                            return NSOrderedAscending;
                        }
                    }];
                    NSString *str = [res componentsJoinedByString:@","];
                    if (![resultList containsObject:str]) {
                        [resultList addObject:[str componentsSeparatedByString:@","]];
                    }
                    ++c;
                    --d;
                }
            }
        }
    }
    return resultList;
}

/**
 2.1.11 Remove Element
 描述
 Given an array and a value, remove all instances of that value in place and return the new length. The order of elements can be changed. It doesn’t matter what you leave beyond the new length.
 */

- (int)removeElement:(NSMutableArray *)array elem:(id)elem
{
    int index = 0;
    for (int i = 0; i < array.count; i++)
    {
        if (array[i] != elem)
        {
            array[index++] = array[i];
        }
    }
    return index;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
