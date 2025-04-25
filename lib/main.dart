import 'package:Jamanvav/model/connectivity_viewmodel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:Jamanvav/firebase_options.dart';
import 'package:Jamanvav/service/language%20transaction.dart';
import 'package:Jamanvav/utils/color_utils.dart';
import 'package:Jamanvav/utils/string_utils.dart';
import 'package:Jamanvav/view/generalScreen/nointernet_screen.dart';
import 'package:Jamanvav/view/maintenance/maintaince_screen.dart';
import 'package:Jamanvav/view/splashScreen/splash_screen.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      name: 'edupulsemilan', options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await Firebase.initializeApp(); // ✅ Ensure this is here

  PackageInfo info = await PackageInfo.fromPlatform();
  StringUtils.appV = info.version;
  StringUtils.appVersion = info.version.replaceAll('.', '');
  print(" StringUtils.appVersion ..> ${StringUtils.appVersion}");
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var metaData;

  // bool appHaveSubScription = true;

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    metaData = await connectivityViewModel.getAppMetaData();
    // DateTime subscriptionDate =
    //     DateTime.parse("${metaData['subscriptionDate']}");
    // print("metaData['subscriptionDate'] == ${subscriptionDate}");
    // print("DateTime.now == ${DateTime.now()}");
    // print("Con == ${subscriptionDate.isBefore(DateTime.now())}");
    // appHaveSubScription = !(subscriptionDate.isBefore(DateTime.now()));
    // print("appHaveSubScription == ${appHaveSubScription}");
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return GetMaterialApp(
            title: StringUtils.appName,
            debugShowCheckedModeBanner: false,
            locale: const Locale('en'),
            translations: LanguageTranslation(),
            theme: ThemeData(
                scaffoldBackgroundColor: ColorUtils.appBackgroundColor),
            home: GetBuilder<ConnectivityViewModel>(
              initState: (setState) async {
                connectivityViewModel.startMonitoring();
              },
              builder: (connectivityViewModel) {
                if (connectivityViewModel.isOnline != null) {
                  return
                    connectivityViewModel.isOnline!
                      ?
                    // appHaveSubScription == false
                    //       ? const MaintenanceScreen()
                    //       :
                  const SplashScreen()
                      : const NoInterNetConnected();
                } else {
                  return const Material();
                }
              },
            ),
          );
        },
      ),
    );
  }

  final connectivityViewModel = Get.put(ConnectivityViewModel());
}
