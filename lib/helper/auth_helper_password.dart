import 'package:local_auth/local_auth.dart';

class AuthHelper {
  static final LocalAuthentication _auth = LocalAuthentication();

  static Future<bool> authenticateUser({
    String reason = 'Please authenticate to access the app',
    bool biometricOnly = false,
  }) async {
    bool isAuthenticated = false;

    try {
      bool canCheckBiometrics = await _auth.canCheckBiometrics;
      bool isDeviceSupported = await _auth.isDeviceSupported();
      bool isDeviceSecure = await _auth.isDeviceSupported() &&
          await _auth.getAvailableBiometrics().then((list) => list.isNotEmpty);

      // Agar device secure nahi hai toh auth skip kardo
      if (!canCheckBiometrics || !isDeviceSupported || !isDeviceSecure) {
        print("Device not secure or no biometrics available, skipping auth.");
        // Delay to allow widget tree to stabilize
        await Future.delayed(Duration(milliseconds: 300));
        return true;
      }


      isAuthenticated = await _auth.authenticate(
        localizedReason: reason,
        options: AuthenticationOptions(
          biometricOnly: biometricOnly,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      print('Biometric auth error: $e');
    }

    return isAuthenticated;
  }

}
