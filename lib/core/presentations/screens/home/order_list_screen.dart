import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sbms_apps/core/presentations/widgets/custom_button.dart';
import '../../../../controllers/product_list_controller.dart';
import '../../../constants/app_colors.dart';
import '../../../helpers/toast_message_helper.dart';
import '../../../models/product_list_model.dart';
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


  List<Map<String, dynamic>> _selectedProducts = [];
  List<double> _selectedProductQuantities = [];
  List<int> _selectedProductDiscounts = [];
  List<int> _selectedProductBonuses = [];
  bool _isProductListVisible = false;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _narrationController = TextEditingController();
  DateTime? _selectedDate;
  String? _vendorName;
  int? _vendorId;
  int? _warehouseId;
  String? _type;
  final List<String> _types = ["Finished Goods"];
  String? _dealerType;
  final List<String> _dealerTypes = ["Cash Dealer", "Credit Dealer"];
  int _dealerCreditDuration = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          "Order Create",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold),
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

              /// ========================> All Fields in Column Layout ===========================>
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),

                  /// =============================> Invoice Field ==========================>
                  Obx(() {
                    if (productListController.orderInvoiceNumberLoading.value) {
                      return const Center(child: CustomLoader());
                    }
                    return GestureDetector(
                      onTap: () {
                        // Show a dialog with invoice information or options
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted) {
                            _showInvoiceInfoDialog();
                          }
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.redAccent),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x08000000),
                              offset: Offset(0, 4),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Text(
                          "Invoice No: ${productListController.invoiceNumber.value.invoiceNo ?? '100068'}",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }),
                  SizedBox(height: 16.h),

                  /// =============================> Warehouse Field ==========================>
                  DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelText: 'Warehouse',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                    ),
                    value: _warehouseId,
                    items: [
                      DropdownMenuItem(
                        value: null,
                        child: Text(
                          'Select Warehouse',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                      ...?productListController.wareHouseList.value.warehouseInfo?.map((warehouse) => DropdownMenuItem(
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
                      )).toList(),
                    ],
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a warehouse';
                      }
                      return null;
                    },
                    onChanged: (val) {
                      setState(() {
                        _warehouseId = val;
                        if (val != null) {
                          // Add your logic here
                        }
                      });
                    },
                    isExpanded: true,
                    menuMaxHeight: 300,
                  ),

                  SizedBox(height: 16.h),

                  /// =============================> Type Field ==========================>
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Type",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                    ),
                    value: _type,
                    items: _types
                        .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ))
                        .toList(),
                    onChanged: (val) => setState(() => _type = val),
                  ),

                  SizedBox(height: 16.h),
                  /// =============================> Date Field ==========================>
                  GestureDetector(
                    onTap: _pickDate,
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Date",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          suffixIcon: const Icon(Icons.calendar_today, color: AppColors.primaryColor),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                        ),
                        controller: TextEditingController(
                          text: _selectedDate == null
                              ? ''
                              : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),


                    /// =============================> Vendor Field with Search ==========================>
                    Container(
                    decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x08000000),
                        offset: Offset(0, 4),
                        blurRadius: 4,
                      ),
                    ],
                  ),
          child: ListTile(
            leading: Icon(Icons.business, color: AppColors.primaryColor),
            title: Text(
              _vendorName ?? "Select Vendor",
              style: TextStyle(
                color: _vendorName != null ? Colors.black : Colors.grey.shade600,
                fontSize: 16.sp,
              ),
            ),
            trailing: Icon(Icons.arrow_drop_down),
            onTap: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  _showSearchableDealerDialog();
                }
              });
            },
          ),
        ),


                  SizedBox(height: 16.h),

                  /// =============================> Dealer Type Field ==========================>
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Dealer Type",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                    ),
                    value: _dealerType,
                    items: _dealerTypes
                        .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        _dealerType = val;
                        // Reset duration when changing to Cash Dealer
                        if (val == "Cash Dealer") {
                          _dealerCreditDuration = 0;
                        }
                      });
                    },
                  ),

                  SizedBox(height: 16.h),
                  /// =============================> Dealer Credit Duration ==========================>
                  if (_dealerType != "Cash Dealer") ...[
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Dealer Credit Duration (Days)",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          // Convert to int, default to 0 if invalid
                          _dealerCreditDuration = int.tryParse(value) ?? 0;
                        });
                      },
                    ),
                    SizedBox(height: 16.h),
                  ],

                ],
              ),
              SizedBox(height: 16.h),
              ///======================================> Product Selection Section ==============================>

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
                      // Use WidgetsBinding to ensure dialog shows after frame rendering
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          _showSelectedProductsPopup();
                        }
                      });
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
                  : // ======== Improved Product List Item Widget ========

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _selectedProducts.length,
                itemBuilder: (context, index) {
                  final selectedProduct = _selectedProducts[index];
                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.symmetric(vertical: 8.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ===== Product Header with Delete Button =====
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      selectedProduct["name"] ?? 'N/A',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.sp,
                                        color: Colors.black87,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4.h),
                                    Row(
                                      children: [
                                        Text(
                                          "৳ ${selectedProduct["price"]}",
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: Icon(Icons.delete_outline, color: Colors.red),
                                  iconSize: 22.sp,
                                  onPressed: () {
                                    setState(() {
                                      _selectedProducts.removeAt(index);
                                      _selectedProductQuantities.removeAt(index);
                                      _selectedProductDiscounts.removeAt(index);
                                      _selectedProductBonuses.removeAt(index);
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 12.h),
                          Divider(height: 1, color: Colors.grey.shade300),
                          SizedBox(height: 12.h),

                          // ===== Input Fields - Two Rows Layout =====

                          Row(
                            children: [
                              // Quantity Field
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Quantity",
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.grey.shade700,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 6.h),
                                    TextFormField(
                                      initialValue: _selectedProductQuantities[index]?.toString() ?? "1",
                                      decoration: InputDecoration(
                                        hintText: "0",
                                        filled: true,
                                        fillColor: Colors.grey.shade50,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8.r),
                                          borderSide: BorderSide(color: Colors.grey.shade300),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8.r),
                                          borderSide: BorderSide(color: Colors.grey.shade300),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8.r),
                                          borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                                        prefixIcon: Icon(Icons.format_list_numbered, size: 18.sp, color: AppColors.primaryColor),
                                      ),
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(fontWeight: FontWeight.w600),
                                      onChanged: (val) {
                                        setState(() {
                                          _selectedProductQuantities[index] = double.tryParse(val) ?? 1;
                                          _selectedProducts[index]["qty"] = _selectedProductQuantities[index];
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 12.w),

                              // Discount Field
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Dis",
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.grey.shade700,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 6.h),
                                    TextFormField(
                                      initialValue: _selectedProductDiscounts[index]?.toString() ?? "0",
                                      decoration: InputDecoration(
                                        hintText: "0",
                                        filled: true,
                                        fillColor: Colors.orange.shade50,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8.r),
                                          borderSide: BorderSide(color: Colors.orange.shade200),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8.r),
                                          borderSide: BorderSide(color: Colors.orange.shade200),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8.r),
                                          borderSide: BorderSide(color: Colors.orange, width: 2),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                                        suffixText: "",
                                        suffixStyle: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                                      ),
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(fontWeight: FontWeight.w600, color: Colors.orange.shade900),
                                      onChanged: (val) {
                                        setState(() {
                                          _selectedProductDiscounts[index] = int.tryParse(val) ?? 0;
                                          _selectedProducts[index]["discount"] = _selectedProductDiscounts[index];
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 12.h),

                          // Second Row: Bonus & Total
                          Row(
                            children: [
                              // Bonus Field
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Bonus",
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.grey.shade700,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 6.h),
                                    TextFormField(
                                      initialValue: _selectedProductBonuses[index]?.toString() ?? "0",
                                      decoration: InputDecoration(
                                        hintText: "0",
                                        filled: true,
                                        fillColor: Colors.blue.shade50,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8.r),
                                          borderSide: BorderSide(color: Colors.blue.shade200),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8.r),
                                          borderSide: BorderSide(color: Colors.blue.shade200),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8.r),
                                          borderSide: BorderSide(color: Colors.blue, width: 2),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                                        suffixText: "",
                                        suffixStyle: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                                      ),
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(fontWeight: FontWeight.w600, color: Colors.blue.shade900),
                                      onChanged: (val) {
                                        setState(() {
                                          _selectedProductBonuses[index] = int.tryParse(val) ?? 0;
                                          _selectedProducts[index]["bonus"] = _selectedProductBonuses[index];
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 12.w),

                              // Total Amount Display
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Total Amount",
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.grey.shade700,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 6.h),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade50,
                                        border: Border.all(color: Colors.green.shade300, width: 1.5),
                                        borderRadius: BorderRadius.circular(8.r),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Display Subtotal (Price * Quantity)
                                          Row(
                                            children: [
                                              Text(
                                                "৳",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14.sp,
                                                  color: Colors.green.shade700,
                                                ),
                                              ),
                                              SizedBox(width: 4.h,),
                                              Text(
                                                (selectedProduct["price"] * _selectedProductQuantities[index]).toStringAsFixed(2),
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: Colors.green.shade600,
                                                  decoration: _selectedProductDiscounts[index] > 0 ? TextDecoration.lineThrough : null,
                                                ),
                                              ),
                                              if (_selectedProductDiscounts[index] > 0)
                                                SizedBox(width: 4.h,),
                                              if (_selectedProductDiscounts[index] > 0)
                                                Text(
                                                  "৳ ${(selectedProduct["price"] * _selectedProductQuantities[index] - ((selectedProduct["price"] * _selectedProductQuantities[index]) * _selectedProductDiscounts[index] / 100)).toStringAsFixed(2)}",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14.sp,
                                                    color: Colors.red.shade700,
                                                  ),
                                                ),
                                            ],
                                          ),
                                          if (_selectedProductDiscounts[index] > 0)
                                            Row(
                                              children: [
                                                Text(
                                                  "${_selectedProductDiscounts[index]}% Discount:",
                                                  style: TextStyle(
                                                    fontSize: 10.sp,
                                                    color: Colors.orange.shade700,
                                                  ),
                                                ),
                                                SizedBox(width: 4.h,),
                                                Text(
                                                  "৳ ${((selectedProduct["price"] * _selectedProductQuantities[index]) * _selectedProductDiscounts[index] / 100).toStringAsFixed(2)}",
                                                  style: TextStyle(
                                                    fontSize: 10.sp,
                                                    color: Colors.orange.shade700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
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
                          "Gross receivable:",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          "৳ ${_calculateGrossReceivable().toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Discount amount:",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          "৳ ${_calculateTotalDiscount().toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade700,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Net receivable amount:",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          "৳ ${_calculateGrandTotalWithDiscount()}",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Quantity:",
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
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Bonus:",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          "${_calculateTotalBonus()}",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
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
                // validator: (value) {
                //   if (value == null || value.trim().isEmpty) {
                //     return "Narration cannot be empty";
                //   }
                //   if (value.length > 255) {
                //     return "Narration cannot exceed 255 characters";
                //   }
                //   // Optional: Allow only letters, numbers, basic punctuation
                //   final validPattern = RegExp(r'^[a-zA-Z0-9\s.,!?()-]*$');
                //   if (!validPattern.hasMatch(value)) {
                //     return "Invalid characters in narration";
                //   }
                //   return null; // Valid
                // },
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

                          final totals = productList.asMap().map((index, p) {
                            final price = p["price"];
                            final qty = p["qty"];
                            final discountPercent = _selectedProductDiscounts[index] ?? 0;
                            if (price is num && qty is num) {
                              double subTotal = price.toDouble() * qty.toDouble();
                              double discountAmount = (subTotal * discountPercent) / 100;
                              return MapEntry(index, (subTotal - discountAmount).toInt());
                            }
                            return MapEntry(index, 0);
                          }).values.toList();

                          // 🧮 Extract discount and bonus values for each product
                          final discountValues = productList.map((p) {
                            final discount = p["discount"];
                            return discount is int ? discount : 0;
                          }).toList();

                          final bonusValues = productList.map((p) {
                            final bonus = p["bonus"];
                            return bonus is int ? bonus : 0;
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

                          // 🚀 Final API call - pass the selected dealer type string directly
                          productListController.orderCreateInfo(
                            date: formattedDate,
                            dealerId: _vendorId!,
                            invoiceNo: productListController.invoiceNumber.value.invoiceNo?.toString() ?? 'N/A',
                            warehouseId: _warehouseId!,
                            dealerCreditDuration: _dealerType == "Cash Dealer" ? 0 : _dealerCreditDuration,
                            productId: productIds,
                            price: prices,
                            quantity: quantities,
                            totalPrice: totals,
                            grandTotalQty: grandTotalQty,
                            grandTotalPayableAmount: grandTotalPayableAmount,
                            narration: _narrationController.text.trim(),
                            context: context,
                            discount: discountValues,
                            bonus: bonusValues,
                            dealerType: _dealerType ?? 'Cash Dealer' // Pass the selected string value directly

                          );
                        }
                      }

                  ),)
            ],
          ),
        ),
      ),
    );
  }


  Future<void> _showSearchableProductDialog() async {
    // Check if the widget is still mounted before showing the dialog
    if (!mounted) return;

    final products = (productListController.productList.value.productInfo ?? []);
    // Sort products by ID in ascending order
    var sortedProducts = List.from(products)..sort((a, b) {
      final idA = a?.id ?? 0;
      final idB = b?.id ?? 0;
      return idA.compareTo(idB);
    });
    List<dynamic> filteredProducts = List.from(sortedProducts);
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
                        filteredProducts = sortedProducts.where((product) {
                          final name = (product?.productName ?? '').toLowerCase();
                          final id = (product?.id?.toString() ?? '').toLowerCase();
                          return name.contains(searchQuery) || id.contains(searchQuery);
                        }).toList();
                        // Sort the filtered results by ID
                        filteredProducts.sort((a, b) {
                          final idA = a?.id ?? 0;
                          final idB = b?.id ?? 0;
                          return idA.compareTo(idB);
                        });
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
                        // Close the search dialog first, then show the product details dialog
                        Navigator.of(context).pop();
                        // Use WidgetsBinding to ensure proper timing between closing one dialog and opening another
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _showProductDetailsDialog(product);
                        });
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
          // Use WidgetsBinding to ensure dialog shows after frame rendering
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _showSearchableProductDialog();
            }
          });
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


  Future<void> _showProductDetailsDialog(ProductInfo product) async {
    // Check if the widget is still mounted before showing the dialog
    if (!mounted) return;

    var priceInfo = productListController.productPriceMap[product.id!];
    if (priceInfo == null) {
      priceInfo = await productListController.getProductWisePriceForProduct(product.id!);
    }

    String currentQuantity = '';
    String currentDiscount = '0';
    String currentBonus = '0';

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
              content: SingleChildScrollView(  // Make sure content is scrollable if needed
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Product ID: ${product.id}",
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "Price: ৳ ${priceInfo?.productInfo?.price ?? 'N/A'}",
                      style: TextStyle(fontSize: 14.sp, color: Colors.green),
                    ),
                    // SizedBox(height: 8.h),
                    // Text(
                    //   "Stock: ${priceInfo?.productInfo?.stock ?? 'N/A'}",
                    //   style: TextStyle(fontSize: 14.sp, color: Colors.red),
                    // ),
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
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: currentDiscount,
                            decoration: InputDecoration(
                              labelText: "Discount %",
                              hintText: "Enter discount",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              // Update the discount
                              currentDiscount = value;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: currentBonus,
                            decoration: InputDecoration(
                              labelText: "Bonus",
                              hintText: "Enter bonus",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              // Update the bonus
                              currentBonus = value;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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

                    final discountValue = int.tryParse(currentDiscount) ?? 0;
                    final bonusValue = int.tryParse(currentBonus) ?? 0;

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

                        _selectedProducts[existingIndex] = {
                          'id': product.id,
                          'name': product.productName,
                          'price': double.tryParse(priceInfo?.productInfo?.price ?? "0") ?? 0,
                          'qty': quantityValue,
                          'discount': discountValue,
                          'bonus': bonusValue,
                        };

                        _selectedProductQuantities[existingIndex] = quantityValue;
                        _selectedProductDiscounts[existingIndex] = discountValue;
                        _selectedProductBonuses[existingIndex] = bonusValue;
                      } else {
                        // Add new product
                        _selectedProducts.add({
                          'id': product.id,
                          'name': product.productName,
                          'price': double.tryParse(priceInfo?.productInfo?.price ?? "0") ?? 0,
                          'qty': quantityValue,
                          'discount': discountValue,
                          'bonus': bonusValue,
                        });

                        _selectedProductQuantities.add(quantityValue);
                        _selectedProductDiscounts.add(discountValue);
                        _selectedProductBonuses.add(bonusValue);
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



  Future<void> _showSearchableDealerDialog() async {
    // Check if the widget is still mounted before showing the dialog
    if (!mounted) return;

    final dealers = (productListController.dealerList.value.dealerInfo ?? []);
    // Sort all dealers alphabetically by name initially
    List<dynamic> sortedDealers = List.from(dealers);
    sortedDealers.sort((a, b) {
      final nameA = (a.dealerName ?? '').toLowerCase();
      final nameB = (b.dealerName ?? '').toLowerCase();
      return nameA.compareTo(nameB);
    });
    List<dynamic> filteredDealers = List.from(sortedDealers);
    String searchQuery = '';

    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {  // ✅ Renamed context to dialogContext
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {  // ✅ This is for dialog state only
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
                      setDialogState(() {  // ✅ Update only dialog state for filtering
                        searchQuery = value.toLowerCase();
                        filteredDealers = dealers.where((dealer) {
                          final name = (dealer.dealerName ?? '').toLowerCase();
                          final id = (dealer.id?.toString() ?? '').toLowerCase();
                          return name.contains(searchQuery) || id.contains(searchQuery);
                        }).toList();
                        // Sort the filtered dealers alphabetically by name
                        filteredDealers.sort((a, b) {
                          final nameA = (a.dealerName ?? '').toLowerCase();
                          final nameB = (b.dealerName ?? '').toLowerCase();
                          return nameA.compareTo(nameB);
                        });
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  Divider(),
                ],
              ),
              content: Container(
                width: double.maxFinite,
                height: 400,
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
                        // ✅ Close dialog first
                        Navigator.of(dialogContext).pop();

                        // ✅ Update parent widget state AFTER dialog closes
                        // Use the main widget's setState (not the dialog's)
                        setState(() {
                          _vendorId = dealer.id;
                          _vendorName = dealer.dealerName;
                        });
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
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




  Future<void> _showSelectedProductsPopup() async {
    // Check if the widget is still mounted before showing the dialog
    if (!mounted) return;

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
                              "Disc: ${selectedProduct["discount"] ?? 0}",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            Text(
                              "Bonus: ${selectedProduct["bonus"] ?? 0}",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.blue,
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


  Future<void> _showInvoiceInfoDialog() async {
    // Check if widget is still mounted
    if (!mounted) return;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Invoice Information"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Current Invoice No: ${productListController.invoiceNumber.value.invoiceNo ?? 'N/A'}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "This invoice number is auto-generated for your new order. "
                "It will be unique and sequential.",
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // Method to calculate total discount amount
  double _calculateTotalDiscount() {
    double totalDiscount = 0.0;

    for (int i = 0; i < _selectedProducts.length; i++) {
      final product = _selectedProducts[i];
      final price = product['price'] as num;
      final quantity = _selectedProductQuantities[i];
      final discountPercent = _selectedProductDiscounts[i] as int;

      // Calculate subtotal: price * quantity
      double subTotal = price.toDouble() * quantity;

      // Calculate discount amount: (subtotal * discountPercent) / 100
      double discountAmount = (subTotal * discountPercent) / 100;

      totalDiscount += discountAmount;
    }

    return totalDiscount;
  }

  // Method to calculate gross receivable (total before discount)
  double _calculateGrossReceivable() {
    double grossTotal = 0.0;

    for (int i = 0; i < _selectedProducts.length; i++) {
      final product = _selectedProducts[i];
      final price = product['price'] as num;
      final quantity = _selectedProductQuantities[i];

      // Calculate subtotal: price * quantity
      double subTotal = price.toDouble() * quantity;
      grossTotal += subTotal;
    }

    return grossTotal;
  }

  // Method to calculate grand total with discount
  double _calculateGrandTotalWithDiscount() {
    double total = 0.0;

    for (int i = 0; i < _selectedProducts.length; i++) {
      final product = _selectedProducts[i];
      final price = product['price'] as num;
      final quantity = _selectedProductQuantities[i];
      final discountPercent = _selectedProductDiscounts[i] as int;

      // Calculate subtotal: price * quantity
      double subTotal = price.toDouble() * quantity;

      // Calculate discount: (subtotal * discountPercent) / 100
      double discountAmount = (subTotal * discountPercent) / 100;

      // Calculate final amount: subtotal - discountAmount
      double finalAmount = subTotal - discountAmount;

      total += finalAmount;
    }

    return total;
  }

  // Method to calculate total bonus
  int _calculateTotalBonus() {
    int totalBonus = 0;

    for (int i = 0; i < _selectedProductBonuses.length; i++) {
      totalBonus += _selectedProductBonuses[i];
    }

    return totalBonus;
  }

}


