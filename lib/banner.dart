import 'package:flutter_applovin_max/flutter_applovin_max.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

enum BannerAdSize {
  banner,
  mrec,
  leader,
}

class BannerPx {
  final double width;
  final double height;
  BannerPx(this.width, this.height);
}

class BannerMaxView extends StatelessWidget {
  final AppLovinListener listener;
  final Map<BannerAdSize, String> sizes = {
    BannerAdSize.banner: 'BANNER',
    BannerAdSize.leader: 'LEADER',
    BannerAdSize.mrec: 'MREC'
  };
  final Map<BannerAdSize, BannerPx> sizesNumMobile = {
    BannerAdSize.banner:  BannerPx(320, 50),
    BannerAdSize.leader: BannerPx(double.infinity, 50),
    BannerAdSize.mrec: BannerPx(300, 250)
  };
  final Map<BannerAdSize, BannerPx> sizesNumIpad = {
    BannerAdSize.banner:  BannerPx(320, 90),
    BannerAdSize.leader: BannerPx(double.infinity, 90),
    BannerAdSize.mrec: BannerPx(300, 250)
  };
  final BannerAdSize size;
  final String adUnitId;

  BannerMaxView(this.listener, this.size, this.adUnitId,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AndroidView androidView = AndroidView(
        viewType: '/Banner',
        key: UniqueKey(),
        creationParams: {'Size': sizes[size], 'UnitId' : adUnitId},
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: (int i) {
          const MethodChannel channel = MethodChannel('AppLovin');
          channel.setMethodCallHandler(
                  (MethodCall call) async => FlutterApplovinMax.handleMethod(call, listener));
        });

    final UiKitView uiKitView = UiKitView(
        viewType: '/Banner',
        creationParams: {'Size': sizes[size], 'UnitId' : adUnitId},
        layoutDirection: TextDirection.ltr,
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: (int i) {
          const MethodChannel channel = MethodChannel('AppLovin');
          channel.setMethodCallHandler(
          (MethodCall call) async => FlutterApplovinMax.handleMethod(call, listener));
        });
    final bool ipad =  MediaQuery.of(context).size.shortestSide > 600 && Platform.isIOS;
    return Container(
      width: sizesNumMobile[size]?.width,
      height: ipad ? sizesNumIpad[size]?.height : sizesNumMobile[size]?.height,
      child: Platform.isAndroid ? androidView : uiKitView
    );
  }
}
