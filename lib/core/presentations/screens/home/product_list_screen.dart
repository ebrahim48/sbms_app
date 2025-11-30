import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
  bool _isTableView = true; // Flag to toggle between table and list view

  ProductListController productListController = Get.put(ProductListController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      productListController.getProductList();
    });
  }

  @override
  Widget build(BuildContext context) {
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
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          children: [
            /// Search Field and Toggle Button
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Search products...",
                        hintStyle: TextStyle(color: Colors.grey.shade600),
                        prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                        filled: false,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _isTableView = true;
                          });
                        },
                        icon: Icon(
                          Icons.table_rows,
                          size: 20.sp,
                          color: _isTableView ? Colors.white : Colors.grey.shade700,
                        ),
                        color: _isTableView ? AppColors.primaryColor : Colors.transparent,
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        constraints: BoxConstraints(minWidth: 36.w, minHeight: 36.h),
                        tooltip: 'Table View',
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _isTableView = false;
                          });
                        },
                        icon: Icon(
                          Icons.list,
                          size: 20.sp,
                          color: !_isTableView ? Colors.white : Colors.grey.shade700,
                        ),
                        color: !_isTableView ? AppColors.primaryColor : Colors.transparent,
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        constraints: BoxConstraints(minWidth: 36.w, minHeight: 36.h),
                        tooltip: 'List View',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            /// Product List
            Expanded(
              child: Obx(() {
                if (productListController.productListLoading.value) {
                  return const Center(child: CustomLoader());
                }

                // Filter products based on search query
                final allProducts = productListController.productList.value.productInfo ?? [];
                final filteredProducts = _searchQuery.isEmpty
                    ? allProducts
                    : allProducts.where((product) {
                  final productName = product?.productName?.toLowerCase() ?? '';
                  final productId = product?.id?.toString().toLowerCase() ?? '';
                  final query = _searchQuery.toLowerCase();
                  return productName.contains(query) || productId.contains(query);
                }).toList();

                if (filteredProducts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 60.sp,
                          color: Colors.grey.shade400,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          "No products found",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          "Try changing your search query",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (_isTableView) {
                  // Table View
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                      headingRowColor: MaterialStateProperty.all(AppColors.primaryColor),
                      dataRowColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.selected)) {
                            return AppColors.primaryColor.withOpacity(0.1);
                          }
                          return null; // Use default value
                        },
                      ),
                      columns: const [
                        DataColumn(
                          label: Text(
                            'ID',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Product Name',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Actions',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                      rows: filteredProducts.map((product) {
                        return DataRow(
                          cells: [
                            DataCell(
                              Text(
                                '${product.id ?? 'N/A'}',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                product.productName ?? 'N/A',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ),
                            DataCell(
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      // Add edit functionality
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color: AppColors.primaryColor,
                                      size: 18.sp,
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(minWidth: 28.w, minHeight: 28.h),
                                    tooltip: 'Edit',
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      // Add delete functionality
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: 18.sp,
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(minWidth: 28.w, minHeight: 28.h),
                                    tooltip: 'Delete',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  );
                } else {
                  // List View
                  return ListView.builder(
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return Container(
                        margin: EdgeInsets.only(bottom: 8.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: ExpansionTile(
                          title: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  '${product.id ?? 'N/A'}',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Text(
                                  product.productName ?? 'N/A',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        // Add edit functionality
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: AppColors.primaryColor,
                                        size: 20.sp,
                                      ),
                                      padding: EdgeInsets.zero,
                                      constraints: BoxConstraints(minWidth: 32.w, minHeight: 32.h),
                                      tooltip: 'Edit',
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        // Add delete functionality
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                        size: 20.sp,
                                      ),
                                      padding: EdgeInsets.zero,
                                      constraints: BoxConstraints(minWidth: 32.w, minHeight: 32.h),
                                      tooltip: 'Delete',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'ID: ${product.id ?? 'N/A'}',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    'Product Name: ${product.productName ?? 'N/A'}',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              }),
            ),
            
            SizedBox(height: 8.h),
            
            /// Product Count
            Obx(() {
              final allProducts = productListController.productList.value.productInfo ?? [];
              final filteredProducts = _searchQuery.isEmpty
                  ? allProducts
                  : allProducts.where((product) {
                final productName = product?.productName?.toLowerCase() ?? '';
                final productId = product?.id?.toString().toLowerCase() ?? '';
                final query = _searchQuery.toLowerCase();
                return productName.contains(query) || productId.contains(query);
              }).toList();
              
              return Text(
                "Showing ${filteredProducts.length} of ${allProducts.length} products",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey.shade600,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}