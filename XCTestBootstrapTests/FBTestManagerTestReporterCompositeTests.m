/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import <OCMock/OCMock.h>
#import <XCTest/XCTest.h>

#import "FBTestManagerAPIMediator.h"
#import "FBTestManagerResultSummary.h"
#import "FBTestManagerTestReporter.h"
#import "FBTestManagerTestReporterComposite.h"

@interface FBTestManagerTestReporterCompositeTests : XCTestCase

@property (nonatomic) id testManagerAPIMediator;
@property (nonatomic) NSArray<OCMockObject<FBTestManagerTestReporter> *> *reporters;
@property (nonatomic) FBTestManagerTestReporterComposite *compositeReporter;

@end

@implementation FBTestManagerTestReporterCompositeTests

- (void)setUp
{
  [super setUp];

  self.testManagerAPIMediator = [OCMockObject mockForClass:[FBTestManagerAPIMediator class]];

  self.reporters = @[
    [OCMockObject mockForProtocol:@protocol(FBTestManagerTestReporter)],
    [OCMockObject mockForProtocol:@protocol(FBTestManagerTestReporter)],
  ];

  XCTAssertGreaterThan(self.reporters.count, 0u);

  self.compositeReporter = [FBTestManagerTestReporterComposite withTestReporters:self.reporters];
}

- (void)testTestManagerMediatorDidBeginExecutingTestPlan
{
  for (OCMockObject<FBTestManagerTestReporter> *reporter in self.reporters) {
    [[reporter expect] testManagerMediatorDidBeginExecutingTestPlan:self.testManagerAPIMediator];
  }

  [self.compositeReporter testManagerMediatorDidBeginExecutingTestPlan:self.testManagerAPIMediator];

  for (OCMockObject<FBTestManagerTestReporter> *reporter in self.reporters) {
    [reporter verify];
  }
}

- (void)testTestManagerMediatorTestSuiteDidStart
{
  for (OCMockObject<FBTestManagerTestReporter> *reporter in self.reporters) {
    [[reporter expect] testManagerMediator:self.testManagerAPIMediator testSuite:@"testSuite" didStartAt:@"123"];
  }

  [self.compositeReporter testManagerMediator:self.testManagerAPIMediator testSuite:@"testSuite" didStartAt:@"123"];

  for (OCMockObject<FBTestManagerTestReporter> *reporter in self.reporters) {
    [reporter verify];
  }
}

- (void)testTestManagerMediatorTestCaseDidFinishForTestClass
{
  for (OCMockObject<FBTestManagerTestReporter> *reporter in self.reporters) {
    [[reporter expect] testManagerMediator:self.testManagerAPIMediator
             testCaseDidFinishForTestClass:@"testClass"
                                    method:@"method"
                                withStatus:FBTestReportStatusPassed
                                  duration:123.5f];
  }

  [self.compositeReporter testManagerMediator:self.testManagerAPIMediator
                testCaseDidFinishForTestClass:@"testClass"
                                       method:@"method"
                                   withStatus:FBTestReportStatusPassed
                                     duration:123.5f];

  for (OCMockObject<FBTestManagerTestReporter> *reporter in self.reporters) {
    [reporter verify];
  }
}

- (void)testTestManagerMediatorTestCaseDidFailForTestClass
{
  for (OCMockObject<FBTestManagerTestReporter> *reporter in self.reporters) {
    [[reporter expect] testManagerMediator:self.testManagerAPIMediator
               testCaseDidFailForTestClass:@"testClass"
                                    method:@"method"
                               withMessage:@"message"
                                      file:@"file"
                                      line:42];
  }

  [self.compositeReporter testManagerMediator:self.testManagerAPIMediator
                  testCaseDidFailForTestClass:@"testClass"
                                       method:@"method"
                                  withMessage:@"message"
                                         file:@"file"
                                         line:42];
  for (OCMockObject<FBTestManagerTestReporter> *reporter in self.reporters) {
    [reporter verify];
  }
}

- (void)testTestManagerMediatorTestBundleReadyWithProtocolVersion
{
  for (OCMockObject<FBTestManagerTestReporter> *reporter in self.reporters) {
    [[reporter expect] testManagerMediator:self.testManagerAPIMediator
        testBundleReadyWithProtocolVersion:16
                            minimumVersion:8];
  }

  [self.compositeReporter testManagerMediator:self.testManagerAPIMediator
           testBundleReadyWithProtocolVersion:16
                               minimumVersion:8];

  for (OCMockObject<FBTestManagerTestReporter> *reporter in self.reporters) {
    [reporter verify];
  }
}

- (void)testTestManagerMediatorTestCaseDidStartForTestClass
{
  for (OCMockObject<FBTestManagerTestReporter> *reporter in self.reporters) {
    [[reporter expect] testManagerMediator:self.testManagerAPIMediator
              testCaseDidStartForTestClass:@"testClass"
                                    method:@"method"];
  }

  [self.compositeReporter testManagerMediator:self.testManagerAPIMediator
                 testCaseDidStartForTestClass:@"testClass"
                                       method:@"method"];

  for (OCMockObject<FBTestManagerTestReporter> *reporter in self.reporters) {
    [reporter verify];
  }
}

- (void)testTestManagerMediatorFinishedWithSummary
{
  id summary = [OCMockObject mockForClass:[FBTestManagerResultSummary class]];

  for (OCMockObject<FBTestManagerTestReporter> *reporter in self.reporters) {
    [[reporter expect] testManagerMediator:self.testManagerAPIMediator finishedWithSummary:summary];
  }

  [self.compositeReporter testManagerMediator:self.testManagerAPIMediator finishedWithSummary:summary];

  for (OCMockObject<FBTestManagerTestReporter> *reporter in self.reporters) {
    [reporter verify];
  }
}

- (void)testTestManagerMediatorDidFinishExecutingTestPlan
{
  for (OCMockObject<FBTestManagerTestReporter> *reporter in self.reporters) {
    [[reporter expect] testManagerMediatorDidFinishExecutingTestPlan:self.testManagerAPIMediator];
  }

  [self.compositeReporter testManagerMediatorDidFinishExecutingTestPlan:self.testManagerAPIMediator];

  for (OCMockObject<FBTestManagerTestReporter> *reporter in self.reporters) {
    [reporter verify];
  }
}

@end
