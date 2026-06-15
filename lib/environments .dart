enum Environments { hrl }

abstract class AppEnvironments {
  static late String baseurl;
  static late String title;
  static late String version;
  static late Environments environments;
  static List<String> dashBordList = <String>[];
  static Environments get _environments => environments;

  ///this method is change flavor
  static setupEvm(Environments evm) {
    environments = evm;
    switch (evm) {
      case Environments.hrl:
        // Flavor-specific configuration for Harsh
        title = "Harsh";
          baseurl = "http://103.166.62.117:44398/";///live
          // baseurl = "http://103.232.124.146:44397/";///test

        ///Harsh live.
        version = 'v 02.03.26';
        dashBordList = [
          'quickDocket',
          // 'gcn',
          // 'manifest',
          // "manifestWithoutScening",
          // "thcWithoutScening",
          // "stockUpdateWithoutScening",
          // "arrivalWithoutScening",
          // "thc",
          // 'arrival',
          // 'stockUpdate',
          // 'pod',
          // 'unloadingSheet',
          // 'attendance',
          // 'tracking',
          'drs',
          // 'prq'
        ];
        break;
    }
  }
}
