import 'dart:convert';

import 'package:mac_vendor_store/global_variables.dart';
import 'package:mac_vendor_store/models/vendor.dart';
import 'package:http/http.dart' as http;
class VendorAuthController {
  Future<void> signUpVendor({
    required String fullName,
    required String email,
    required String password,
    required String context,
  }) async {
    try {
      Vendor vendor = Vendor(
        id: '',
        fullName: fullName,
        email: email,
        password: password,
        locality: '',
        city: '',
        state: '',
        role: 'vendor',
      );
      await http.post(
        Uri.parse('$uri/vendor/signup'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: vendor.toJson(),
      );
    } catch (e) {
      
    }
  }
}