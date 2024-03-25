

// Example Usage

// BackgroundService backgroundService = BackgroundService(
// androidOnStart: onStart,
// );

//   void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await backgroundService.initService();
//   runApp(MyApp());
// }

// Future<void> onStart(ServiceInstance service) async {
//   DartPluginRegistrant.ensureInitialized();
//   var count = 1;
//   // bring to foreground
//   Timer.periodic(const Duration(seconds: 10), (timer) async {
//     log(count.toString());
//     count++;
//   });
// }