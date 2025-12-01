import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/budget_provider.dart';
import '../../../core/models/budget_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/validators.dart';
import '../../../core/utils/helpers.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/custom_button.dart';

class AddBudgetScreen extends StatefulWidget {
  final BudgetModel? budget;
  
  const AddBudgetScreen({Key? key, this.budget}) : super(key: key);

  @override
  State<AddBudgetScreen> createState() => _AddBudgetScreenState();
}

class _AddBudgetScreenState extends State<AddBudgetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  String _selectedCategory = AppConstants.expenseCategories[0];
  String _selectedPeriod = 'monthly';
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));

  bool get isEditMode => widget.budget != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      _nameController.text = widget.budget!.name;
      _amountController.text = widget.budget!.amount.toString();
      _descriptionController.text = widget.budget!.description ?? '';
      _selectedCategory = widget.budget!.category;
      _selectedPeriod = widget.budget!.period;
      _startDate = widget.budget!.startDate;
      _endDate = widget.budget!.endDate;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final budgetProvider = Provider.of<BudgetProvider>(context, listen: false);
    
    if (authProvider.currentUser == null) return;

    final budget = BudgetModel(
      id: widget.budget?.id,
      userId: authProvider.currentUser!.id!,
      name: _nameController.text.trim(),
      amount: double.parse(_amountController.text),
      category: _selectedCategory,
      period: _selectedPeriod,
      startDate: _startDate,
      endDate: _endDate,
      description: _descriptionController.text.trim().isEmpty 
          ? null 
          : _descriptionController.text.trim(),
    );

    bool success;
    if (isEditMode) {
      success = await budgetProvider.updateBudget(budget);
    } else {
      success = await budgetProvider.createBudget(budget);
    }

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEditMode ? 'Budget updated successfully' : 'Budget created successfully',
          ),
          backgroundColor: AppColors.success,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(budgetProvider.errorMessage ?? 'Operation failed'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Budget' : 'Add Budget'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                controller: _nameController,
                labelText: 'Budget Name',
                hintText: 'e.g., Monthly Groceries',
                prefixIcon: Icons.label_outline,
                validator: Validators.validateBudgetName,
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
                items: AppConstants.expenseCategories.map((category) {
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
              
              // Period Dropdown
              DropdownButtonFormField<String>(
                value: _selectedPeriod,
                decoration: const InputDecoration(
                  labelText: 'Period',
                  prefixIcon: Icon(Icons.calendar_today_outlined),
                ),
                items: const [
                  DropdownMenuItem(value: 'daily', child: Text('Daily')),
                  DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
                  DropdownMenuItem(value: 'monthly', child: Text('Monthly')),
                  DropdownMenuItem(value: 'yearly', child: Text('Yearly')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedPeriod = value!;
                  });
                },
              ),
              
              const SizedBox(height: 20),
              
              // Date Range
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: TextEditingController(
                        text: Helpers.formatDate(_startDate),
                      ),
                      labelText: 'Start Date',
                      hintText: 'Select date',
                      prefixIcon: Icons.date_range,
                      readOnly: true,
                      onTap: () => _selectDate(context, true),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      controller: TextEditingController(
                        text: Helpers.formatDate(_endDate),
                      ),
                      labelText: 'End Date',
                      hintText: 'Select date',
                      prefixIcon: Icons.date_range,
                      readOnly: true,
                      onTap: () => _selectDate(context, false),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              CustomTextField(
                controller: _descriptionController,
                labelText: 'Description (Optional)',
                hintText: 'Add notes about this budget',
                prefixIcon: Icons.notes,
                maxLines: 3,
              ),
              
              const SizedBox(height: 30),
              
              Consumer<BudgetProvider>(
                builder: (context, budgetProvider, child) {
                  return CustomButton(
                    text: isEditMode ? 'Update Budget' : 'Create Budget',
                    onPressed: _handleSave,
                    isLoading: budgetProvider.isLoading,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
