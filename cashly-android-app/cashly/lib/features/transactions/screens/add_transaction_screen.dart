import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/transaction_provider.dart';
import '../../../core/models/transaction_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/validators.dart';
import '../../../core/utils/helpers.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/custom_button.dart';

class AddTransactionScreen extends StatefulWidget {
  final TransactionModel? transaction;
  
  const AddTransactionScreen({Key? key, this.transaction}) : super(key: key);

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  
  String _selectedType = 'expense';
  String _selectedCategory = AppConstants.expenseCategories[0];
  DateTime _selectedDate = DateTime.now();

  bool get isEditMode => widget.transaction != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      _titleController.text = widget.transaction!.title;
      _amountController.text = widget.transaction!.amount.toString();
      _noteController.text = widget.transaction!.note ?? '';
      _selectedType = widget.transaction!.type;
      _selectedCategory = widget.transaction!.category;
      _selectedDate = widget.transaction!.date;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  List<String> get _categories {
    return _selectedType == 'income'
        ? AppConstants.incomeCategories
        : AppConstants.expenseCategories;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);
    
    if (authProvider.currentUser == null) return;

    final transaction = TransactionModel(
      id: widget.transaction?.id,
      userId: authProvider.currentUser!.id!,
      type: _selectedType,
      amount: double.parse(_amountController.text),
      category: _selectedCategory,
      title: _titleController.text.trim(),
      note: _noteController.text.trim().isEmpty 
          ? null 
          : _noteController.text.trim(),
      date: _selectedDate,
    );

    bool success;
    if (isEditMode) {
      success = await transactionProvider.updateTransaction(transaction);
    } else {
      success = await transactionProvider.createTransaction(transaction);
    }

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEditMode ? 'Transaction updated' : 'Transaction added',
          ),
          backgroundColor: AppColors.success,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(transactionProvider.errorMessage ?? 'Operation failed'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Transaction' : 'Add Transaction'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Type Selector
              Row(
                children: [
                  Expanded(
                    child: _buildTypeCard('Income', 'income', Icons.arrow_upward, AppColors.success),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTypeCard('Expense', 'expense', Icons.arrow_downward, AppColors.error),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              CustomTextField(
                controller: _titleController,
                labelText: 'Title',
                hintText: 'e.g., Grocery Shopping',
                prefixIcon: Icons.title,
                validator: Validators.validateTransactionTitle,
              ),
              
              const SizedBox(height: 20),
              
              CustomTextField(
                controller: _amountController,
                labelText: 'Amount',
                hintText: '0.00',
                prefixIcon: Icons.attach_money,
                keyboardType: TextInputType.number,
                validator: Validators.validateAmount,
              ),
              
              const SizedBox(height: 20),
              
              // Category Dropdown
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),
              
              const SizedBox(height: 20),
              
              // Date Picker
              CustomTextField(
                controller: TextEditingController(
                  text: Helpers.formatDate(_selectedDate),
                ),
                labelText: 'Date',
                hintText: 'Select date',
                prefixIcon: Icons.calendar_today,
                readOnly: true,
                onTap: () => _selectDate(context),
              ),
              
              const SizedBox(height: 20),
              
              CustomTextField(
                controller: _noteController,
                labelText: 'Note (Optional)',
                hintText: 'Add notes about this transaction',
                prefixIcon: Icons.notes,
                maxLines: 3,
              ),
              
              const SizedBox(height: 30),
              
              Consumer<TransactionProvider>(
                builder: (context, transactionProvider, child) {
                  return CustomButton(
                    text: isEditMode ? 'Update Transaction' : 'Add Transaction',
                    onPressed: _handleSave,
                    isLoading: transactionProvider.isLoading,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeCard(String label, String value, IconData icon, Color color) {
    final isSelected = _selectedType == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = value;
          _selectedCategory = _categories[0];
        });
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? color : Colors.grey,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? color : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
