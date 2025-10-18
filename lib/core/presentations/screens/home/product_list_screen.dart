import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sbms_apps/core/config/app_routes/app_routes.dart';
import 'package:sbms_apps/core/constants/app_colors.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> _allProducts = [
    'Affix-100ml (4)',
    'Affix-500 ml (4)',
    'Affix-50ml (4)',
    'Aracta 25WDG-20GM (4)',
    'Aracta 25WDG-5gm (4)',
    'BINA Dhan-17-10 Kg (2)',
    'BINA Dhan-17-2 Kg (2)',
    'BINA Dhan-25-2 Kg (2)',
    'Brinjal Special-1L (3)',
    'Sunrice 50GM (1)',
  ];

  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _allProducts
        .where((product) =>
        product.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

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
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
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
            Expanded(
              child: ListView.builder(
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
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
                      title: Text(
                        product,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () {
                        context.pushNamed(AppRoutes.createScreen);

                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
