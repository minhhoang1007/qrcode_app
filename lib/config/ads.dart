import 'package:firebase_admob/firebase_admob.dart';

const String testDevice = 'MobileId';
const String appId = 'ca-app-pub-3940256099942544/1033173712';
const String bannerId = 'ca-app-pub-3940256099942544/6300978111';
const String interUnitId = 'ca-app-pub-3940256099942544/1033173712';

class ADS {
  MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevice != null ? <String>[testDevice] : null,
    nonPersonalizedAds: true,
    keywords: <String>['Game', 'Mario'],
  );
}
