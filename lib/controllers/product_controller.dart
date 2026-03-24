import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:mac_vendor_store/global_variables.dart';
import 'package:mac_vendor_store/models/product.dart';
import 'package:mac_vendor_store/services/manage_http_response.dart';

class ProductController {
  Future<void> UploadProduct({
    required String productName,
    required int productPrice,
    required int quantity,
    required String description,
    required String category,
    required String vendorId,
    required String fullName,
    required String subCategory,
    required List<dynamic>? pickedImages,
    required BuildContext context,
  }) async {
    if (pickedImages != null) {
      final cloudinary = CloudinaryPublic("dfkrdzklj", "lfzswfk4");
      List<String> images = [];
      for (var i = 0; i < pickedImages.length; i++) {
        CloudinaryResponse cloudinaryResponse;
        if (kIsWeb) {
          // For web platform (Uint8List)
          var fileBytes = pickedImages[i] as Uint8List;
          cloudinaryResponse = await cloudinary.uploadFile(
            CloudinaryFile.fromBytesData(
              fileBytes,
              identifier: '${productName}_${i}',
            ),
          );
        } else {
          // For mobile platforms (File)
          cloudinaryResponse = await cloudinary.uploadFile(
            CloudinaryFile.fromFile((pickedImages[i] as File).path),
          );
        }
        images.add(cloudinaryResponse.secureUrl);
      }
      if (category.isNotEmpty && subCategory.isNotEmpty) {
        final product = Product(
          id: "",
          productName: productName,
          productPrice: productPrice,
          quantity: quantity,
          description: description,
          category: category,
          vendorId: vendorId,
          fullName: fullName,
          subCategory: subCategory,
          images: images,
        );
        print(images);
        http.Response response = await http.post(
          Uri.parse("$uri/api/add-product"),
          body: product.toJson(),
          headers: {"Content-Type": "application/json;charset=utf-8"},
        );
        manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, "Product uploaded successfully");
          },
        );
      } else {
        showSnackBar(context, "Please select category and subCategory");
      }
    } else {
      showSnackBar(context, "Please select images");
    }
  }
}
