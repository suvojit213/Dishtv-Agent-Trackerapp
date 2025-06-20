import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:dishtv_agent_tracker/core/constants/app_colors.dart';
import 'package:dishtv_agent_tracker/domain/entities/csat_entry.dart';
import 'package:dishtv_agent_tracker/presentation/common/widgets/custom_app_bar.dart';
import 'package:dishtv_agent_tracker/presentation/common/widgets/custom_card.dart';
import 'package:dishtv_agent_tracker/presentation/common/widgets/custom_button.dart';
import 'package:dishtv_agent_tracker/domain/repositories/performance_repository.dart'; // Import PerformanceRepository

class AddCSATEntryScreen extends StatefulWidget {
  final CSATEntry? entryToEdit;

  const AddCSATEntryScreen({Key? key, this.entryToEdit}) : super(key: key);

  @override
  State<AddCSATEntryScreen> createState() => _AddCSATEntryScreenState();
}

class _AddCSATEntryScreenState extends State<AddCSATEntryScreen> {
  late DateTime _selectedDate;
  late int _t2Count;
  late int _b2Count;
  late int _nCount;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.entryToEdit != null) {
      _selectedDate = widget.entryToEdit!.date;
      _t2Count = widget.entryToEdit!.t2Count;
      _b2Count = widget.entryToEdit!.b2Count;
      _nCount = widget.entryToEdit!.nCount;
    } else {
      _selectedDate = DateTime.now();
      _t2Count = 0;
      _b2Count = 0;
      _nCount = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.entryToEdit != null ? 'Edit CSAT Entry' : 'Add CSAT Entry',
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Section
            _buildSectionTitle(context, 'Date'),
            CustomCard(
              child: InkWell(
                onTap: () => _selectDate(context),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).inputDecorationTheme.fillColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        DateFormat('dd MMM yyyy').format(_selectedDate),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // T2 Count Section
            _buildSectionTitle(context, 'T2 Count (Positive Feedback)'),
            CustomCard(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: TextFormField(
                initialValue: _t2Count.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Enter T2 count',
                  prefixIcon: Icon(Icons.thumb_up, color: AppColors.accentGreen),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    _t2Count = int.tryParse(value) ?? 0;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),

            // B2 Count Section
            _buildSectionTitle(context, 'B2 Count (Negative Feedback)'),
            CustomCard(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: TextFormField(
                initialValue: _b2Count.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Enter B2 count',
                  prefixIcon: Icon(Icons.thumb_down, color: AppColors.accentRed),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    _b2Count = int.tryParse(value) ?? 0;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),

            // N Count Section
            _buildSectionTitle(context, 'N Count (Neutral Feedback)'),
            CustomCard(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: TextFormField(
                initialValue: _nCount.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Enter N count',
                  prefixIcon: Icon(Icons.remove, color: AppColors.textSecondary),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    _nCount = int.tryParse(value) ?? 0;
                  });
                },
              ),
            ),
            const SizedBox(height: 24),

            // Preview Section
            if (_t2Count > 0 || _b2Count > 0 || _nCount > 0) ...[
              _buildSectionTitle(context, 'Preview'),
              CustomCard(
                child: Column(
                  children: [
                    _buildPreviewRow('Total Survey Hits', '${_t2Count + _b2Count + _nCount}'),
                    const Divider(),
                    _buildPreviewRow('T2 Score', '${_calculateScore(_t2Count).toStringAsFixed(2)}%'),
                    _buildPreviewRow('B2 Score', '${_calculateScore(_b2Count).toStringAsFixed(2)}%'),
                    _buildPreviewRow('N Score', '${_calculateScore(_nCount).toStringAsFixed(2)}%'),
                    const Divider(),
                    _buildPreviewRow(
                      'CSAT Percentage',
                      '${_calculateCSAT().toStringAsFixed(2)}%',
                      isHighlight: true,
                      color: _calculateCSAT() >= 60 ? AppColors.accentGreen : AppColors.accentRed,
                    ),
                    if (_calculateCSAT() < 60)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.accentRed.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                color: AppColors.accentRed,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'CSAT below 60% - Needs Improvement',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.accentRed,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: widget.entryToEdit != null ? 'Update CSAT Entry' : 'Add CSAT Entry',
                onPressed: _isLoading ? null : _submitEntry,
                icon: widget.entryToEdit != null ? Icons.update : Icons.add,
              ),
            ),

            if (widget.entryToEdit != null) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: 'Delete Entry',
                  onPressed: _isLoading ? null : () => _showDeleteConfirmationDialog(context),
                  isPrimary: false,
                  icon: Icons.delete_outline,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  Widget _buildPreviewRow(String label, String value, {bool isHighlight = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color ?? (isHighlight ? AppColors.dishTvOrange : null),
            ),
          ),
        ],
      ),
    );
  }

  double _calculateScore(int count) {
    final total = _t2Count + _b2Count + _nCount;
    if (total == 0) return 0.0;
    return (100 / total) * count;
  }

  double _calculateCSAT() {
    return _calculateScore(_t2Count) - _calculateScore(_b2Count);
  }
  Future<void> _selectDate(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppColors.dishTvOrange,
            ),
          ),
          child: child!,
        );
      },
    );
    if (selectedDate != null) {
      setState(() {
        _selectedDate = selectedDate;
      });
    }
  }

  void _submitEntry() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final entry = CSATEntry(
        id: widget.entryToEdit?.id,
        date: _selectedDate,
        t2Count: _t2Count,
        b2Count: _b2Count,
        nCount: _nCount,
      );

      await context.read<PerformanceRepository>().saveCSATEntry(entry); // Use the repository

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.entryToEdit != null
                  ? 'CSAT entry updated successfully!'
                  : 'CSAT entry added successfully!',
            ),
            backgroundColor: AppColors.accentGreen,
          ),
        );
        Navigator.pop(context, true); // Signal success to previous screen
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save CSAT entry: $e'),
            backgroundColor: AppColors.accentRed,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
          shape: Theme.of(context).dialogTheme.shape,
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this CSAT entry? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _deleteEntry();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteEntry() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.entryToEdit?.id != null) {
        await context.read<PerformanceRepository>().deleteCSATEntry(widget.entryToEdit!.id!); // Use the repository
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('CSAT entry deleted successfully!'),
            backgroundColor: AppColors.accentGreen,
          ),
        );
        Navigator.pop(context, true); // Signal success to previous screen
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete CSAT entry: $e'),
            backgroundColor: AppColors.accentRed,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}


