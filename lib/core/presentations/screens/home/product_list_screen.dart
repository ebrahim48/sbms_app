import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:sbms_apps/core/config/app_routes/app_routes.dart';
import 'package:sbms_apps/core/constants/app_colors.dart';

import '../../../../controllers/product_list_controller.dart';
import '../../widgets/custom_loader.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final TextEditingController _searchController = TextEditingController();


  String _searchQuery = '';


  ProductListController productListController = Get.put(ProductListController());

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      productListController.getProductList();
    });
  }

  @override
  Widget build(BuildContext context) {

    // final filteredProducts = _allProducts
    //     .where((product) =>
    //     product.toLowerCase().contains(_searchQuery.toLowerCase()))
    //     .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          "Product List",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          children: [
            /// Search Field
            TextField(
              controller: _searchController,
              // onChanged: (value) {
              //   setState(() {
              //     _searchQuery = value;
              //   });
              // },
              decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 16.h),

            /// Product List
            Obx((){
              if (productListController.productListLoading.value) {
                return const Center(child: CustomLoader());
              }
             return Expanded(
                child: ListView.builder(
                  itemCount: productListController.productList.value.productInfo?.length,
                  itemBuilder: (context, index) {
                    final product = productListController.productList.value.productInfo?[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 10.h),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Row(
                          children: [
                            Text(
                              '${product?.id ?? 'N/A'}',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              product?.productName ?? 'N/A',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          context.pushNamed(AppRoutes.createScreen);

                        },
                      ),
                    );
                  },
                ),
              );
            }

            ),
          ],
        ),
      ),
    );
  }
}
