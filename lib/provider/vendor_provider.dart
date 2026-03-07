import 'package:flutter_riverpod/legacy.dart';
import 'package:mac_vendor_store/models/vendor.dart';

class VendorProvider extends StateNotifier<Vendor?> {
  VendorProvider()
    : super(
        Vendor(
          id: '',
          fullName: '',
          email: '',
          password: '',
          locality: '',
          city: '',
          state: '',
          role: '',
        ),
      );
  Vendor? get vendor => state;
  void setVendor(String vendorJson) {
    state = Vendor.fromJson(vendorJson);
  }

  void signOut() {
    state = null;
  }
}
// 定义VendorProvider的状态提供器，用于在应用中使用VendorProvider的状态管理。
final vendorProvider = StateNotifierProvider<VendorProvider, Vendor?>(
  (ref) => VendorProvider(),
);
