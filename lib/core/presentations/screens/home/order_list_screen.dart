import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sbms_apps/core/presentations/widgets/custom_button.dart';
import '../../../../controllers/product_list_controller.dart';
import '../../../constants/app_colors.dart';
import '../../../helpers/toast_message_helper.dart';
import '../../../models/product_list_model.dart';
import '../../../models/warehouselist_model.dart';
import '../../widgets/custom_loader.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {

  ProductListController productListController = Get.put(ProductListController());

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      productListController.getDealerList();
      productListController.getWareHouseList();
      productListController.getProductWisePrice();
      productListController.getOrderInvoice();
      productListController.getProductList().then((_) async {
        // After getting product list, fetch prices for each product
        final products = productListController.productList.value.productInfo ?? [];
        for (var product in products) {
          if (product?.id != null) {
            await productListController.getProductWisePriceForProduct(product.id!);
          }
        }
      });
    });
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // State variables for order management
  List<Map<String, dynamic>> _selectedProducts = []; // Stores products added to the order
  List<double> _productQuantities = []; // Stores quantities for all available products
  List<double> _selectedProductQuantities = []; // Stores quantities for selected products only
  List<bool> _productSelections = [];
  bool _isProductListVisible = false; // To control visibility of product list
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _narrationController = TextEditingController();
  DateTime? _selectedDate;
  String? _vendorName;
  int? _vendorId;
  String? _branch;
  int? _warehouseId;
  String? _type;
  final List<String> _types = ["Finished Goods"];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          "Order Create",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ========================> Row 1: Date, Vendor, Invoice ===========================>
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: _pickDate,
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "Date",
                            border: const OutlineInputBorder(),
                            suffixIcon:
                            const Icon(Icons.calendar_today, color: AppColors.primaryColor),
                          ),
                          controller: TextEditingController(
                            text: _selectedDate == null
                                ? ''
                                : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),



                  /// =============================> order vendor with search ==========================>
                  Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Custom vendor selection field
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: ListTile(
                            leading: Icon(Icons.business, color: AppColors.primaryColor),
                            title: Text(
                              _vendorName ?? "Select Vendor",
                              style: TextStyle(
                                color: _vendorName != null ? Colors.black : Colors.grey.shade600,
                              ),
                            ),
                            trailing: Icon(Icons.arrow_drop_down),
                            onTap: () {
                              _showSearchableDealerDialog();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),



                  // Obx(()=>
                  //   Expanded(
                  //     flex: 3,
                  //     child: DropdownButtonFormField<String>(
                  //       decoration: const InputDecoration(
                  //         labelText: "Vendor Name",
                  //         border: OutlineInputBorder(),
                  //       ),
                  //       value: _vendorName,
                  //       items: productListController.dealerList.value.dealerInfo
                  //           ?.map((dealer) => DropdownMenuItem(
                  //         value: dealer.dealerName,
                  //         child: Row(
                  //           children: [
                  //             Text(
                  //               '${dealer.id ?? 'N/A'} - ',
                  //               style: TextStyle(
                  //                 fontSize: 12.sp,
                  //                 fontWeight: FontWeight.w500,
                  //               ),
                  //             ),
                  //             Text(
                  //               dealer.dealerName ?? 'N/A',
                  //               style: TextStyle(
                  //                 fontSize: 12.sp,
                  //                 fontWeight: FontWeight.w500,
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ))
                  //           .toList() ?? [],
                  //       onChanged: (val) => setState(() => _vendorName = val),
                  //       isExpanded: true,
                  //       menuMaxHeight: 300,
                  //     ),
                  //   ),),
                  SizedBox(width: 10.w),

                  /// =============================>  Invoice ==========================>

                  Obx((){
                    if (productListController.orderInvoiceNumberLoading.value) {
                      return const Center(child: CustomLoader());
                    }
                    return Expanded(
                      child: Container(
                          padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.redAccent),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            "Invoice No: ${productListController.invoiceNumber.value.invoiceNo ?? 'N/A'}",
                            style: TextStyle(color: Colors.red),
                          )

                      ),
                    );
                  }

                  ),
                ],
              ),
              SizedBox(height: 16.h),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(
                      width: 220.w,
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: "Type",
                          border: OutlineInputBorder(),
                        ),
                        value: _type,
                        items: _types
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (val) => setState(() => _type = val),
                      ),
                    ),
                    SizedBox(width: 10.w),


                    SizedBox(
                      width: 220.w,
                      child: DropdownButtonFormField<int>(
                        decoration:  InputDecoration(
                          labelText: 'Warehouse',
                          border: OutlineInputBorder(),
                        ),
                        value: _warehouseId,
                        items: productListController.wareHouseList.value.warehouseInfo
                            ?.map((warehouse) => DropdownMenuItem(
                          value: warehouse.id,
                          child: Row(
                            children: [
                              Text(
                                '${warehouse.id ?? 'N/A'} - ',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                warehouse.warehouseName ?? 'N/A',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ))
                            .toList() ?? [],
                        onChanged: (val) => setState(() {
                          _warehouseId = val;
                          if (val != null) {
                            _branch = productListController.wareHouseList.value.warehouseInfo
                                ?.firstWhere((warehouse) => warehouse.id == val, orElse: () =>
                            productListController.wareHouseList.value.warehouseInfo!.isNotEmpty ?
                            productListController.wareHouseList.value.warehouseInfo!.first : WarehouseInfo(id: null, warehouseName: null))
                                ?.warehouseName;
                          }
                        }),
                        isExpanded: true,
                        menuMaxHeight: 300,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              ///======================================> Product Selection Section ==============================>
              // Section with toggle button and search
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: "Select products",
                          // prefixIcon: Icon(Icons.search, color: AppColors.primaryColor),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
                        ),
                        enabled: _isProductListVisible, // Disable search when product list is hidden
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value.toLowerCase();
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  // "+" button to show product list
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 15.sp,
                      ),
                      onPressed: () {
                        setState(() {
                          _isProductListVisible = !_isProductListVisible;
                        });
                      },
                      tooltip: _isProductListVisible ? 'Hide Products' : 'Show Products',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),

              ///======================================> Product Section ==============================>
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Products",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                        fontSize: 16.sp),
                  ),
                  // Add icon with popup to show selected products
                  IconButton(
                    icon: Icon(Icons.add_circle, color: AppColors.primaryColor),
                    tooltip: "View Selected Products",
                    onPressed: () {
                      _showSelectedProductsPopup();
                    },
                  ),
                ],
              ),
              SizedBox(height: 10.h),

              // Product Selection Dropdown - Only visible when toggle is on
              if (_isProductListVisible) ...[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Select Product:",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      _buildProductSelectionDropdown(),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
              ],

              // Selected Products List (similar to existing functionality)
              _selectedProducts.isEmpty
                  ? Container(
                padding: EdgeInsets.all(16.w),
                alignment: Alignment.center,
                child: Text(
                  "No products selected yet. Click the + icon to add products.",
                  style: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )
                  : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _selectedProducts.length,
                itemBuilder: (context, index) {
                  final selectedProduct = _selectedProducts[index];
                  return Card(
                    elevation: 1,
                    margin: EdgeInsets.symmetric(vertical: 6.h),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  selectedProduct["name"] ?? 'N/A',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  "Price: ৳${selectedProduct["price"]}",
                                  style: TextStyle(color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              initialValue: _selectedProductQuantities[index]?.toString() ?? "1",
                              decoration: const InputDecoration(
                                labelText: "Quantity",
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (val) {
                                setState(() {
                                  _selectedProductQuantities[index] = double.tryParse(val) ?? 1;
                                  // Update the quantity in the selected product
                                  _selectedProducts[index]["qty"] = _selectedProductQuantities[index];
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                (selectedProduct["price"] * _selectedProductQuantities[index])
                                    .toStringAsFixed(2),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                _selectedProducts.removeAt(index);
                                _selectedProductQuantities.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: 16.h),
              /// =====================> Grand Total Summary <=====================
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.w),
                margin: EdgeInsets.only(bottom: 16.h),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: AppColors.primaryColor.withOpacity(0.4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order Summary",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Grand Total Quantity:",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          "${_selectedProducts.fold<int>(0, (sum, item) => sum + (item['qty'] as num).toInt())}",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Grand Total Payable:",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          "৳ ${_selectedProducts.fold<num>(0, (sum, item) => sum + (item['price'] as num) * (item['qty'] as num))}",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              /// =================================> Narration  =============================>


              TextFormField(
                controller: _narrationController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: "Narration",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Narration cannot be empty";
                  }
                  if (value.length > 255) {
                    return "Narration cannot exceed 255 characters";
                  }
                  // Optional: Allow only letters, numbers, basic punctuation
                  final validPattern = RegExp(r'^[a-zA-Z0-9\s.,!?()-]*$');
                  if (!validPattern.hasMatch(value)) {
                    return "Invalid characters in narration";
                  }
                  return null; // Valid
                },
              ),

              SizedBox(height: 16.h),

              SizedBox(height: 20.h),
              Obx(() =>
                  CustomButton(
                      loading: productListController.orderLoading.value,
                      title: 'Order Confirm',
                      onpress: () {
                        if (formKey.currentState!.validate()) {
                          final productList = _selectedProducts;

                          // 🧩 Safe extraction of product IDs and numeric fields
                          final productIds = productList.map((p) {
                            final id = p["id"];
                            return id is int ? id : 0;
                          }).toList();

                          final prices = productList.map((p) {
                            final price = p["price"];
                            return price is num ? price.toInt() : 0;
                          }).toList();

                          final quantities = productList.map((p) {
                            final qty = p["qty"];
                            return qty is num ? qty.toInt() : 0;
                          }).toList();

                          final totals = productList.map((p) {
                            final price = p["price"];
                            final qty = p["qty"];
                            if (price is num && qty is num) {
                              return (price * qty).toInt();
                            }
                            return 0;
                          }).toList();

                          // 🧮 Totals
                          final grandTotalQty = quantities.fold(0, (sum, qty) => sum + qty);
                          final grandTotalPayableAmount = totals.fold(0, (sum, t) => sum + t);

                          // 🗓️ Check Date
                          if (_selectedDate == null) {
                            ToastMessageHelper.showToastMessage("Please select a date before confirming.");
                            return;
                          }

                          // 🧾 Use selected vendor ID directly
                          if (_vendorId == null) {
                            ToastMessageHelper.showToastMessage("Please select a valid vendor.");
                            return;
                          }

                          // 🏢 Use selected warehouse ID directly
                          if (_warehouseId == null) {
                            ToastMessageHelper.showToastMessage("Please select a valid warehouse.");
                            return;
                          }

                          final formattedDate =
                              "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}";

                          // 🧠 Debug log (optional)
                          debugPrint('Dealer ID: $_vendorId');
                          debugPrint('Warehouse ID: $_warehouseId');
                          debugPrint('Product IDs: $productIds');

                          // 🚀 Final API call
                          productListController.orderCreateInfo(
                            date: formattedDate,
                            dealerId: _vendorId!,
                            invoiceNo: productListController.invoiceNumber.value.invoiceNo?.toString() ?? 'N/A',
                            warehouseId: _warehouseId!,
                            productId: productIds,
                            price: prices,
                            quantity: quantities,
                            totalPrice: totals,
                            grandTotalQty: grandTotalQty,
                            grandTotalPayableAmount: grandTotalPayableAmount,
                            narration: _narrationController.text.trim(),
                            context: context,
                            totalAmount: totals,
                          );
                        }
                      }

                    // onpress: () {
                    //   if (formKey.currentState!.validate()) {
                    //     final productList = _products;
                    //
                    //     final productIds = productList.map((p) => p["id"] as int).toList();
                    //     final prices = productList.map((p) => (p["price"] as num).toInt()).toList();
                    //     final quantities = productList.map((p) => (p["qty"] as num).toInt()).toList();
                    //     final totals = productList
                    //         .map((p) => ((p["price"] as num) * (p["qty"] as num)).toInt())
                    //         .toList();
                    //
                    //     // 🧮 Step 2: Calculate grand totals
                    //     final grandTotalQty = quantities.fold(0, (sum, qty) => sum + qty);
                    //     final grandTotalPayableAmount = totals.fold(0, (sum, t) => sum + t);
                    //
                    //     // 🗓️ Step 3: Validation check
                    //     if (_selectedDate == null) {
                    //       ToastMessageHelper.showToastMessage("Please select a date before confirming.");
                    //       return;
                    //     }
                    //
                    //     final formattedDate =
                    //         "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}";
                    //
                    //
                    //     productListController.orderCreateInfo(
                    //       date: formattedDate,
                    //       dealerId: productListController.dealerList.value.dealerInfo
                    //           ?.firstWhereOrNull((dealer) => dealer.dealerName == _vendorName)
                    //           ?.id ?? 0,
                    //       invoiceNo: productListController.invoiceNumber.value.invoiceNo?.toString() ?? 'N/A',
                    //       warehouseId: productListController.wareHouseList.value.warehouseInfo
                    //           ?.firstWhereOrNull((w) => w.warehouseName == _branch)
                    //           ?.id ?? 0,
                    //       productId: productIds,
                    //       price: prices,
                    //       quantity: quantities,
                    //       totalPrice: totals,
                    //       grandTotalQty: grandTotalQty,
                    //       grandTotalPayableAmount: grandTotalPayableAmount,
                    //       narration: _narrationController.text.trim(),
                    //       context: context,
                    //       totalAmount: totals,
                    //     );
                    //   }
                    // },
                  ),)
            ],
          ),
        ),
      ),
    );
  }

  // Show a dialog with searchable product list
  Future<void> _showSearchableProductDialog() async {
    final products = (productListController.productList.value.productInfo ?? []);
    List<dynamic> filteredProducts = List.from(products);
    String searchQuery = '';

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Search products...",
                      prefixIcon: Icon(Icons.search, color: AppColors.primaryColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value.toLowerCase();
                        filteredProducts = products.where((product) {
                          final name = (product?.productName ?? '').toLowerCase();
                          final id = (product?.id?.toString() ?? '').toLowerCase();
                          return name.contains(searchQuery) || id.contains(searchQuery);
                        }).toList();
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  Divider(),
                ],
              ),
              content: Container(
                width: double.maxFinite,
                height: MediaQuery.of(context).size.height * 0.6,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredProducts.length,
                  itemBuilder: (BuildContext context, int index) {
                    final product = filteredProducts[index];
                    return ListTile(
                      title: Text(
                        product?.productName ?? 'N/A',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text('ID: ${product?.id ?? 'N/A'}'),
                      onTap: () {
                        _showProductDetailsDialog(product);
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel', style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildProductSelectionDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(
          color: Colors.grey.shade400,
        ),
      ),
      child: TextButton(
        onPressed: () {
          _showSearchableProductDialog();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Select a product...",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14.sp,
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.grey.shade600,
            ),
          ],
        ),
      ),
    );
  }

  // Show product details in a dialog when selected from dropdown
  Future<void> _showProductDetailsDialog(ProductInfo product) async {
    // Get price and stock info for the selected product
    var priceInfo = productListController.productPriceMap[product.id!];
    if (priceInfo == null) {
      // If not in cache, fetch it
      priceInfo = await productListController.getProductWisePriceForProduct(product.id!);
    }

    // Initialize quantity for this product as empty
    String currentQuantity = '';

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                product.productName ?? 'Product Details',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Product ID: ${product.id}",
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Price: ৳${priceInfo?.productInfo?.price ?? 'N/A'}",
                    style: TextStyle(fontSize: 14.sp, color: Colors.green),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Stock: ${priceInfo?.productInfo?.stock ?? 'N/A'}",
                    style: TextStyle(fontSize: 14.sp, color: Colors.red),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: currentQuantity,
                          decoration: InputDecoration(
                            labelText: "Quantity",
                            hintText: "Enter quantity",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            // Update the quantity
                            currentQuantity = value;
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel', style: TextStyle(color: Colors.red)),
                ),
                TextButton(
                  onPressed: () {
                    // Validate that quantity is provided
                    final quantityValue = double.tryParse(currentQuantity);
                    if (quantityValue == null || quantityValue <= 0) {
                      // Show error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Please enter a valid quantity"),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return; // Don't proceed if no valid quantity
                    }

                    // Add product to selected list
                    setState(() {
                      // Check if product is already in the list
                      int existingIndex = -1;
                      for (int i = 0; i < _selectedProducts.length; i++) {
                        if (_selectedProducts[i]['id'] == product.id) {
                          existingIndex = i;
                          break;
                        }
                      }

                      if (existingIndex != -1) {
                        // Update the existing product quantity
                        _selectedProducts[existingIndex] = {
                          'id': product.id,
                          'name': product.productName,
                          'price': double.tryParse(priceInfo?.productInfo?.price ?? "0") ?? 0,
                          'qty': quantityValue,
                        };
                      } else {
                        // Add new product
                        _selectedProducts.add({
                          'id': product.id,
                          'name': product.productName,
                          'price': double.tryParse(priceInfo?.productInfo?.price ?? "0") ?? 0,
                          'qty': quantityValue,
                        });
                      }
                      // Also update the selected product quantities list
                      if (existingIndex != -1) {
                        _selectedProductQuantities[existingIndex] = quantityValue;
                      } else {
                        _selectedProductQuantities.add(quantityValue);
                      }
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Add to Order',
                    style: TextStyle(color: AppColors.primaryColor),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  // Show a dialog with searchable dealer list
  Future<void> _showSearchableDealerDialog() async {
    final dealers = (productListController.dealerList.value.dealerInfo ?? []);
    List<dynamic> filteredDealers = List.from(dealers);
    String searchQuery = '';

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Search vendors...",
                      prefixIcon: Icon(Icons.search, color: AppColors.primaryColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value.toLowerCase();
                        filteredDealers = dealers.where((dealer) {
                          final name = (dealer.dealerName ?? '').toLowerCase();
                          final id = (dealer.id?.toString() ?? '').toLowerCase();
                          return name.contains(searchQuery) || id.contains(searchQuery);
                        }).toList();
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  Divider(),
                ],
              ),
              content: Container(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredDealers.length,
                  itemBuilder: (BuildContext context, int index) {
                    final dealer = filteredDealers[index];
                    return ListTile(
                      title: Text(
                        dealer.dealerName ?? 'N/A',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text('ID: ${dealer.id ?? 'N/A'}'),
                      onTap: () {
                        setState(() {
                          _vendorId = dealer.id;
                          _vendorName = dealer.dealerName;
                        });
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel', style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Show a dialog with selected products
  Future<void> _showSelectedProductsPopup() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Selected Products (${_selectedProducts.length})",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: Container(
            width: double.maxFinite,
            // Limit height to make it scrollable if there are many products
            height: _selectedProducts.length > 5
                ? MediaQuery.of(context).size.height * 0.6
                : null,
            child: _selectedProducts.isEmpty
                ? Center(
              child: Text(
                "No products selected yet.",
                style: TextStyle(color: Colors.grey),
              ),
            )
                : ListView.builder(
              shrinkWrap: true,
              itemCount: _selectedProducts.length,
              itemBuilder: (context, index) {
                final selectedProduct = _selectedProducts[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 8.h),
                  child: Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedProduct["name"] ?? 'N/A',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "ID: ${selectedProduct["id"]}",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              "Price: ${selectedProduct["price"]}",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Qty: ${_selectedProductQuantities[index] ?? 1}",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              "Total: ${(selectedProduct["price"] * (_selectedProductQuantities[index] ?? 1)).toStringAsFixed(2)}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close', style: TextStyle(color: AppColors.primaryColor)),
            ),
          ],
        );
      },
    );
  }

}