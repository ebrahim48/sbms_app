import 'package:flutter/material.dart';
import '../../../core/models/dealer_info_model.dart';

class SearchableDealerDropdown extends StatefulWidget {
  final List<DealerInfo>? dealers;
  final int? selectedDealerId;
  final Function(int? dealerId)? onChanged;
  final String? Function(int? value)? validator;
  final String labelText;

  const SearchableDealerDropdown({
    Key? key,
    this.dealers,
    this.selectedDealerId,
    this.onChanged,
    this.validator,
    this.labelText = "Dealer",
  }) : super(key: key);

  @override
  State<SearchableDealerDropdown> createState() => _SearchableDealerDropdownState();
}

class _SearchableDealerDropdownState extends State<SearchableDealerDropdown> {
  final TextEditingController _searchController = TextEditingController();
  TextEditingController? _displayController;
  List<DealerInfo> _allDealers = [];
  String _selectedText = "";

  @override
  void initState() {
    super.initState();
    _allDealers = widget.dealers?.toList() ?? [];

    // Set initial selected text
    if (widget.selectedDealerId != null && widget.dealers != null) {
      final selectedDealer = widget.dealers!
          .firstWhere((dealer) => dealer.id == widget.selectedDealerId, orElse: () => DealerInfo());
      _selectedText = selectedDealer.dealerName ?? '';
    }

    // Initialize the display controller with the initial selected text
    _displayController = TextEditingController(text: _selectedText);
  }

  @override
  void didUpdateWidget(SearchableDealerDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update dealers list if it changes
    if (oldWidget.dealers != widget.dealers) {
      _allDealers = widget.dealers?.toList() ?? [];
    }

    // Update selected text if selectedDealerId changes from parent
    if (oldWidget.selectedDealerId != widget.selectedDealerId) {
      if (widget.selectedDealerId != null && widget.dealers != null) {
        final selectedDealer = widget.dealers!
            .firstWhere((dealer) => dealer.id == widget.selectedDealerId, orElse: () => DealerInfo());
        final newSelectedText = selectedDealer.dealerName ?? '';
        _selectedText = newSelectedText;

        // Also update the display controller to reflect the change immediately
        if (_displayController != null) {
          _displayController!.text = newSelectedText;
        }
      } else {
        _selectedText = '';
        if (_displayController != null) {
          _displayController!.text = '';
        }
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _displayController?.dispose();
    super.dispose();
  }

  Future<void> _openSearchDialog() async {
    // Create a local search controller for this dialog session
    final searchController = TextEditingController();
    var localFilteredDealers = List<DealerInfo>.from(_allDealers);

    void filterDealers(String query) {
      if (query.isEmpty) {
        localFilteredDealers = List.from(_allDealers);
      } else {
        localFilteredDealers = _allDealers
            .where((dealer) {
              final dealerName = dealer.dealerName?.toLowerCase() ?? '';
              final dealerId = dealer.id?.toString() ?? '';
              final queryLower = query.toLowerCase();
              return dealerName.contains(queryLower) ||
                  dealerId.contains(query);
            })
            .toList();
      }
    }

    // Check if the widget is still mounted before showing the dialog
    if (!mounted) return;

    // Get the correct context for showing dialogs
    final BuildContext dialogContext = context;

    final result = await showDialog<int>(
      context: dialogContext,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text("Select Dealer"),
              content: SizedBox(
                width: double.maxFinite,
                height: 400, // Fixed height to avoid overflow issues
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        hintText: "Search dealers...",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (String value) {
                        filterDealers(value);
                        setState(() {}); // Rebuild the dialog to update the list
                      },
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: localFilteredDealers.length,
                        itemBuilder: (context, index) {
                          final dealer = localFilteredDealers[index];
                          return ListTile(
                            title: Text(
                              dealer.dealerName ?? 'N/A',
                              style: const TextStyle(fontSize: 14),
                            ),
                            subtitle: Text(
                              'ID: ${dealer.id ?? 'N/A'}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            onTap: () {
                              Navigator.of(context).pop(dealer.id);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Cancel"),
                ),
              ],
            );
          },
        );
      },
    );

    // Check if the widget is still mounted after the dialog is closed
    if (mounted && result != null) {
      widget.onChanged?.call(result);

      // Update selected text
      final selectedDealer = widget.dealers?.firstWhere(
            (dealer) => dealer.id == result,
            orElse: () => DealerInfo(),
          );
      final newSelectedText = selectedDealer?.dealerName ?? '';

      setState(() {
        _selectedText = newSelectedText;
      });

      // Also update the display controller directly to ensure the text updates immediately
      if (_displayController != null) {
        _displayController!.text = newSelectedText;
      }
    }

    // Dispose the local search controller after the dialog is closed
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Ensure the display controller has the correct text value
    if (_displayController != null && _displayController!.text != _selectedText) {
      _displayController!.text = _selectedText;
    }

    return TextFormField(
      controller: _displayController!,
      decoration: InputDecoration(
        labelText: widget.labelText,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: const Icon(Icons.arrow_drop_down),
          onPressed: () {
            // Add a check to ensure the widget is still mounted
            if (mounted) {
              // Use WidgetsBinding to ensure dialog shows after frame rendering
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  _openSearchDialog();
                }
              });
            }
          },
        ),
      ),
      readOnly: true, // Make it read-only since we'll handle selection via the dialog
      validator: widget.validator != null
          ? (value) => widget.validator!(widget.selectedDealerId)
          : null,
      onTap: () {
        // Add a check to ensure the widget is still mounted
        if (mounted) {
          // Use WidgetsBinding to ensure dialog shows after frame rendering
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _openSearchDialog();
            }
          });
        }
      },
    );
  }
}