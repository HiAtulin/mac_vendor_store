import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mac_vendor_store/global_variables.dart';
import 'package:mac_vendor_store/models/vendor.dart';
import 'package:http/http.dart' as http;
import 'package:mac_vendor_store/provider/vendor_provider.dart';
import 'package:mac_vendor_store/services/manage_http_response.dart';
import 'package:mac_vendor_store/views/main_vendor_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

final ProviderContainer providerContainer = ProviderContainer();

class VendorAuthController {
  Future<void> signUpVendor({
    required String fullName,
    required String email,
    required String password,
    required context,
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
      http.Response response = await http.post(
        Uri.parse('$uri/api/vendor/signup'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: vendor.toJson(),
      );
      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Vendor signed up successfully');
        },
      );
    } catch (e) {
      showSnackBar(context, '${e.toString()}');
    }
  }

  Future<void> signInVendor({
    required String email,
    required String password,
    required context,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse('$uri/api/vendor/signin'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );
      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String token = jsonDecode(response.body)['token'];
          await prefs.setString('auth_token', token);
          final vendorJson = jsonDecode(response.body)['vendor'];
          providerContainer
              .read(vendorProvider.notifier)
              .setVendor(jsonEncode(vendorJson));

          await prefs.setString('vendor', jsonEncode(vendorJson));

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainVendorScreen()),
            (route) => false,
          );
          showSnackBar(context, 'Vendor signed in successfully');
        },
      );
    } catch (e) {
      showSnackBar(context, '${e.toString()}');
    }
  }
}
