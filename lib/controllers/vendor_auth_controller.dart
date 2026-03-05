import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mac_vendor_store/global_variables.dart';
import 'package:mac_vendor_store/models/vendor.dart';
import 'package:http/http.dart' as http;
import 'package:mac_vendor_store/services/manage_http_response.dart';
import 'package:mac_vendor_store/views/main_vendor_screen.dart';

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
        onSuccess: () {
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
