import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mac_vendor_store/controllers/product_controller.dart';
import 'package:mac_vendor_store/controllers/subcategory_controller.dart';
import 'package:mac_vendor_store/models/category.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mac_vendor_store/controllers/category_controller.dart';
import 'package:mac_vendor_store/models/subcategory.dart';
import 'package:mac_vendor_store/provider/vendor_provider.dart';
import 'package:mac_vendor_store/services/manage_http_response.dart';

class UploadScreen extends ConsumerStatefulWidget {
  const UploadScreen({super.key});

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends ConsumerState<UploadScreen> {
  final ProductController _productController = ProductController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Future<List<Category>> futureCategories;
  Future<List<Subcategory>>? futureSubcategories;
  Subcategory? selectedSubcategory;
  Category? selectedCategory;
  late String productName;
  late int productPrice;
  late int quantity;
  late String description;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    futureCategories = CategoryController().loadCategories();
  }

  final ImagePicker picker = ImagePicker();
  List<dynamic> images = [];

  chooseImage() async {
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile == null) {
      print('No image selected');
      return;
    }

    if (kIsWeb) {
      // For web platform
      final Uint8List bytes = await pickedFile.readAsBytes();
      setState(() {
        images.add(bytes);
      });
    } else {
      // For mobile platforms
      setState(() {
        images.add(File(pickedFile.path));
      });
    }
  }

  getSubcategoryByCategory(value) {
    futureSubcategories = SubcategoryController()
        .getSubCategoriesByCategoryName(value.name);
    selectedSubcategory = null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 150,
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: images.length + 1,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  childAspectRatio: 1.0,
                ),
                itemBuilder: (context, index) {
                  return index == 0
                      ? Center(
                          child: IconButton(
                            icon: Icon(Icons.add),
                            onPressed: chooseImage,
                          ),
                        )
                      : SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: kIsWeb
                              ? Image.memory(
                                  images[index - 1] as Uint8List,
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  images[index - 1] as File,
                                  fit: BoxFit.cover,
                                ),
                        );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 200,
                    child: TextFormField(
                      onChanged: (value) {
                        productName = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter product name';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Product Name',
                        hintText: 'Enter product name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: 200,
                    child: TextFormField(
                      keyboardType: TextInputType.number,

                      onChanged: (value) {
                        productPrice = int.parse(value);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter product price';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Product Price',
                        hintText: 'Enter product price',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: 200,
                    child: TextFormField(
                      keyboardType: TextInputType.number,

                      onChanged: (value) {
                        quantity = int.parse(value);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter product quantity';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Product Quantity',
                        hintText: 'Enter product quantity',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: 200,
                    child: FutureBuilder<List<Category>>(
                      future: futureCategories,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text("${snapshot.error}"));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(child: Text("No subcategories found"));
                        } else {
                          return DropdownButton<Category>(
                            hint: Text("Select a subcategory"),
                            value: selectedCategory ?? null,
                            items: snapshot.data!.map((category) {
                              return DropdownMenuItem<Category>(
                                value: category,
                                child: Text(category.name),
                              );
                            }).toList(),
                            onChanged: (Category? newValue) {
                              setState(() {
                                selectedCategory = newValue;
                              });
                              getSubcategoryByCategory(selectedCategory);
                            },
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: FutureBuilder<List<Subcategory>>(
                      future: futureSubcategories,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text("${snapshot.error}"));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(child: Text("No subcategories found"));
                        } else {
                          return DropdownButton<Subcategory>(
                            hint: Text("Select a subcategory"),
                            value: selectedSubcategory ?? null,
                            items: snapshot.data!.map((subcategory) {
                              return DropdownMenuItem<Subcategory>(
                                value: subcategory,
                                child: Text(subcategory.subcategoryName),
                              );
                            }).toList(),
                            onChanged: (Subcategory? newValue) {
                              setState(() {
                                selectedSubcategory = newValue;
                              });
                            },
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: 400,
                    child: TextFormField(
                      onChanged: (value) {
                        description = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter product description';
                        }
                        return null;
                      },
                      maxLines: 3,
                      maxLength: 500,
                      decoration: InputDecoration(
                        labelText: 'Product Description',
                        hintText: 'Enter product description',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: InkWell(
                onTap: () async {
                  final vendor = ref.read(vendorProvider);
                  if (vendor == null) {
                    showSnackBar(context, 'Please login first');
                    return;
                  }
                  final fullName = vendor.fullName;
                  final vendorId = vendor.id;
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      isLoading = true;
                    });
                    await _productController.UploadProduct(
                      productName: productName,
                      productPrice: productPrice,
                      quantity: quantity,
                      description: description,
                      category: selectedCategory!.name,
                      vendorId: vendorId,
                      fullName: fullName,
                      subCategory: selectedSubcategory!.subcategoryName,
                      pickedImages: images,
                      context: context,
                    ).whenComplete(() {
                      setState(() {
                        isLoading = false;
                      });
                      selectedCategory = null;
                      selectedSubcategory = null;
                      images.clear();
                    });
                  } else {
                    print('Please fill in all fields');
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade900,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Upload Product',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.7,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
