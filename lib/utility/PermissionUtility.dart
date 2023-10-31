import 'package:permission_handler/permission_handler.dart';

class PermissionUtility{
  Future<void> requestPermission() async {
    final permission = Permission.camera;

    if (await permission.isDenied) {
      await permission.request();
    }
  }

  Future<bool> checkPermissionStatus() async {
    final permission = Permission.camera;

    return await permission.status.isGranted;
  }
}