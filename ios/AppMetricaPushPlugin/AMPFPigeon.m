// Autogenerated from Pigeon (v10.1.6), do not edit directly.
// See also: https://pub.dev/packages/pigeon

#import "AMPFPigeon.h"

#if TARGET_OS_OSX
#import <FlutterMacOS/FlutterMacOS.h>
#else
#import <Flutter/Flutter.h>
#endif

#if !__has_feature(objc_arc)
#error File requires ARC to be enabled.
#endif

static NSArray *wrapResult(id result, FlutterError *error) {
  if (error) {
    return @[
      error.code ?: [NSNull null], error.message ?: [NSNull null], error.details ?: [NSNull null]
    ];
  }
  return @[ result ?: [NSNull null] ];
}
static id GetNullableObjectAtIndex(NSArray *array, NSInteger key) {
  id result = array[key];
  return (result == [NSNull null]) ? nil : result;
}

@interface AMPFPermissionOptions ()
+ (AMPFPermissionOptions *)fromList:(NSArray *)list;
+ (nullable AMPFPermissionOptions *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@implementation AMPFPermissionOptions
+ (instancetype)makeWithAlert:(NSNumber *)alert
    badge:(NSNumber *)badge
    sound:(NSNumber *)sound {
  AMPFPermissionOptions* pigeonResult = [[AMPFPermissionOptions alloc] init];
  pigeonResult.alert = alert;
  pigeonResult.badge = badge;
  pigeonResult.sound = sound;
  return pigeonResult;
}
+ (AMPFPermissionOptions *)fromList:(NSArray *)list {
  AMPFPermissionOptions *pigeonResult = [[AMPFPermissionOptions alloc] init];
  pigeonResult.alert = GetNullableObjectAtIndex(list, 0);
  NSAssert(pigeonResult.alert != nil, @"");
  pigeonResult.badge = GetNullableObjectAtIndex(list, 1);
  NSAssert(pigeonResult.badge != nil, @"");
  pigeonResult.sound = GetNullableObjectAtIndex(list, 2);
  NSAssert(pigeonResult.sound != nil, @"");
  return pigeonResult;
}
+ (nullable AMPFPermissionOptions *)nullableFromList:(NSArray *)list {
  return (list) ? [AMPFPermissionOptions fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.alert ?: [NSNull null]),
    (self.badge ?: [NSNull null]),
    (self.sound ?: [NSNull null]),
  ];
}
@end

@interface AMPFAppMetricaPushPigeonCodecReader : FlutterStandardReader
@end
@implementation AMPFAppMetricaPushPigeonCodecReader
- (nullable id)readValueOfType:(UInt8)type {
  switch (type) {
    case 128: 
      return [AMPFPermissionOptions fromList:[self readValue]];
    default:
      return [super readValueOfType:type];
  }
}
@end

@interface AMPFAppMetricaPushPigeonCodecWriter : FlutterStandardWriter
@end
@implementation AMPFAppMetricaPushPigeonCodecWriter
- (void)writeValue:(id)value {
  if ([value isKindOfClass:[AMPFPermissionOptions class]]) {
    [self writeByte:128];
    [self writeValue:[value toList]];
  } else {
    [super writeValue:value];
  }
}
@end

@interface AMPFAppMetricaPushPigeonCodecReaderWriter : FlutterStandardReaderWriter
@end
@implementation AMPFAppMetricaPushPigeonCodecReaderWriter
- (FlutterStandardWriter *)writerWithData:(NSMutableData *)data {
  return [[AMPFAppMetricaPushPigeonCodecWriter alloc] initWithData:data];
}
- (FlutterStandardReader *)readerWithData:(NSData *)data {
  return [[AMPFAppMetricaPushPigeonCodecReader alloc] initWithData:data];
}
@end

NSObject<FlutterMessageCodec> *AMPFAppMetricaPushPigeonGetCodec(void) {
  static FlutterStandardMessageCodec *sSharedObject = nil;
  static dispatch_once_t sPred = 0;
  dispatch_once(&sPred, ^{
    AMPFAppMetricaPushPigeonCodecReaderWriter *readerWriter = [[AMPFAppMetricaPushPigeonCodecReaderWriter alloc] init];
    sSharedObject = [FlutterStandardMessageCodec codecWithReaderWriter:readerWriter];
  });
  return sSharedObject;
}

void AMPFAppMetricaPushPigeonSetup(id<FlutterBinaryMessenger> binaryMessenger, NSObject<AMPFAppMetricaPushPigeon> *api) {
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.appmetrica_push_plugin.AppMetricaPushPigeon.activate"
        binaryMessenger:binaryMessenger
        codec:AMPFAppMetricaPushPigeonGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(activateWithError:)], @"AMPFAppMetricaPushPigeon api (%@) doesn't respond to @selector(activateWithError:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        [api activateWithError:&error];
        callback(wrapResult(nil, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.appmetrica_push_plugin.AppMetricaPushPigeon.saveAppMetricaConfig"
        binaryMessenger:binaryMessenger
        codec:AMPFAppMetricaPushPigeonGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(saveAppMetricaConfigConfig:error:)], @"AMPFAppMetricaPushPigeon api (%@) doesn't respond to @selector(saveAppMetricaConfigConfig:error:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_config = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        [api saveAppMetricaConfigConfig:arg_config error:&error];
        callback(wrapResult(nil, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.appmetrica_push_plugin.AppMetricaPushPigeon.getTokens"
        binaryMessenger:binaryMessenger
        codec:AMPFAppMetricaPushPigeonGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(getTokensWithCompletion:)], @"AMPFAppMetricaPushPigeon api (%@) doesn't respond to @selector(getTokensWithCompletion:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        [api getTokensWithCompletion:^(NSDictionary<NSString *, NSString *> *_Nullable output, FlutterError *_Nullable error) {
          callback(wrapResult(output, error));
        }];
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.appmetrica_push_plugin.AppMetricaPushPigeon.requestPermission"
        binaryMessenger:binaryMessenger
        codec:AMPFAppMetricaPushPigeonGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(requestPermissionOptions:error:)], @"AMPFAppMetricaPushPigeon api (%@) doesn't respond to @selector(requestPermissionOptions:error:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        AMPFPermissionOptions *arg_options = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        [api requestPermissionOptions:arg_options error:&error];
        callback(wrapResult(nil, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
}
NSObject<FlutterMessageCodec> *AMPFTokenUpdateApiGetCodec(void) {
  static FlutterStandardMessageCodec *sSharedObject = nil;
  sSharedObject = [FlutterStandardMessageCodec sharedInstance];
  return sSharedObject;
}

@interface AMPFTokenUpdateApi ()
@property(nonatomic, strong) NSObject<FlutterBinaryMessenger> *binaryMessenger;
@end

@implementation AMPFTokenUpdateApi

- (instancetype)initWithBinaryMessenger:(NSObject<FlutterBinaryMessenger> *)binaryMessenger {
  self = [super init];
  if (self) {
    _binaryMessenger = binaryMessenger;
  }
  return self;
}
- (void)onTokenUpdatedNewTokens:(NSDictionary<NSString *, NSString *> *)arg_newTokens completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel =
    [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.appmetrica_push_plugin.TokenUpdateApi.onTokenUpdated"
      binaryMessenger:self.binaryMessenger
      codec:AMPFTokenUpdateApiGetCodec()];
  [channel sendMessage:@[arg_newTokens ?: [NSNull null]] reply:^(id reply) {
    completion(nil);
  }];
}
@end

