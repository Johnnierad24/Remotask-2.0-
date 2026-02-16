import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/payment_method_logo.dart';
import '../widgets/skeleton_loader.dart';
import '../widgets/payment_status_dialog.dart';
import '../widgets/billing_address_form.dart';
import '../utils/currency_formatter.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final ApiService _apiService = ApiService();
  
  Map<String, dynamic>? _wallet;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadWallet();
  }

  Future<void> _loadWallet() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final wallet = await _apiService.getWallet();
      setState(() {
        _wallet = wallet;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _showWithdrawDialog() {
    final TextEditingController amountController = TextEditingController();
    String paymentMethod = 'MPESA';
    bool saveInfo = false;
    bool isLoading = false;
    String? errorText;
    String selectedCurrency = 'USD';
    double transactionFee = 2.5; // Example static fee, can be dynamic

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Row(
            children: [
              const Text('Request Withdrawal'),
              const SizedBox(width: 8),
              if (!bool.fromEnvironment('dart.vm.product', defaultValue: false))
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('TEST', style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Multi-currency support
                Row(
                  children: [
                    const Text('Currency:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    DropdownButton<String>(
                      value: selectedCurrency,
                      items: const [
                        DropdownMenuItem(value: 'USD', child: Text('USD')),
                        DropdownMenuItem(value: 'KES', child: Text('KES')),
                        DropdownMenuItem(value: 'EUR', child: Text('EUR')),
                      ],
                      onChanged: (val) => setDialogState(() => selectedCurrency = val!),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Amount ($selectedCurrency)',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.attach_money),
                    errorText: errorText,
                  ),
                  onChanged: (_) {
                    setDialogState(() => errorText = null);
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: paymentMethod,
                  decoration: const InputDecoration(
                    labelText: 'Payment Method',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'MPESA',
                      child: Row(children: [
                        PaymentMethodLogo(method: 'MPESA', size: 20),
                        const SizedBox(width: 8),
                        const Text('M-Pesa'),
                        SizedBox(width: 8),
                        Icon(Icons.flash_on, color: Colors.orange, size: 16),
                        Text(' Popular', style: TextStyle(color: Colors.orange, fontSize: 12)),
                      ]),
                    ),
                    DropdownMenuItem(
                      value: 'CARD',
                      child: Row(children: [PaymentMethodLogo(method: 'CARD', size: 20), SizedBox(width: 8), Text('Card (Visa, Mastercard, Amex)')]),
                    ),
                    DropdownMenuItem(
                      value: 'CASH_APP',
                      child: Row(children: [PaymentMethodLogo(method: 'CASH_APP', size: 20), SizedBox(width: 8), Text('Cash App Pay')]),
                    ),
                    DropdownMenuItem(
                      value: 'AMAZON_PAY',
                      child: Row(children: [PaymentMethodLogo(method: 'AMAZON_PAY', size: 20), SizedBox(width: 8), Text('Amazon Pay')]),
                    ),
                    DropdownMenuItem(
                      value: 'LINK',
                      child: Row(children: [PaymentMethodLogo(method: 'LINK', size: 20), SizedBox(width: 8), Text('Link (1-click checkout)')]),
                    ),
                    DropdownMenuItem(
                      value: 'AIRTEL_MONEY',
                      child: Row(children: [Icon(Icons.phone_android, size: 20), SizedBox(width: 8), Text('Airtel Money')]),
                    ),
                    DropdownMenuItem(
                      value: 'MTN_MOMO',
                      child: Row(children: [Icon(Icons.phone_android, size: 20), SizedBox(width: 8), Text('MTN MoMo')]),
                    ),
                    DropdownMenuItem(
                      value: 'BANK',
                      child: Row(children: [Icon(Icons.account_balance, size: 20), SizedBox(width: 8), Text('Bank Transfer')]),
                    ),
                  ],
                  onChanged: (value) {
                    setDialogState(() => paymentMethod = value!);
                  },
                ),
                // Show billing address form for card payments
                if (paymentMethod == 'CARD') ...[
                  const SizedBox(height: 16),
                  const Text('Billing Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8),
                  BillingAddressForm(onAddressChanged: (address) {
                    // Store billing address for payment processing
                  }),
                ],
                const SizedBox(height: 12),
                // Transaction fee disclosure
                Row(
                  children: [
                    Icon(Icons.info_outline, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text('Transaction fee: ', style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                    Text('$selectedCurrency ${transactionFee.toStringAsFixed(2)}', style: TextStyle(fontSize: 12, color: Colors.grey[700], fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                // Help/support link
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () {
                      // TODO: Link to payment support/FAQ
                    },
                    icon: Icon(Icons.help_outline, size: 18),
                    label: Text('Need help?', style: TextStyle(fontSize: 13)),
                  ),
                ),
                Row(
                  children: [
                    Image.asset('assets/ssl.png', height: 20),
                    const SizedBox(width: 6),
                    const Text('256-bit SSL encryption', style: TextStyle(fontSize: 12)),
                    const SizedBox(width: 12),
                    Image.asset('assets/pci.png', height: 20),
                    const SizedBox(width: 6),
                    const Text('PCI DSS compliant', style: TextStyle(fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 12),
                CheckboxListTile(
                  value: saveInfo,
                  onChanged: (val) => setDialogState(() => saveInfo = val ?? false),
                  title: const Text('Save your info for secure 1-click checkout with Link', style: TextStyle(fontSize: 13)),
                  subtitle: const Text('Pay faster at FreelanceConnect and thousands of businesses.', style: TextStyle(fontSize: 11)),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            Tooltip(
              message: (amountController.text.isEmpty || double.tryParse(amountController.text) == null || double.tryParse(amountController.text)! <= 0)
                  ? 'Enter a valid amount to enable'
                  : isLoading ? 'Processing...' : '',
              child: ElevatedButton(
                onPressed: (isLoading || amountController.text.isEmpty || double.tryParse(amountController.text) == null || double.tryParse(amountController.text)! <= 0)
                    ? null
                    : () async {
                        final amount = double.tryParse(amountController.text);
                        setDialogState(() { isLoading = true; });
                        try {
                          await _apiService.requestWithdrawal(amount!, paymentMethod);
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (ctx) => PaymentStatusDialog(
                              status: PaymentStatus.success,
                              title: 'Withdrawal Submitted!',
                              message: 'Your withdrawal request for ${CurrencyFormatter.formatDisplay(amount, selectedCurrency)} via $paymentMethod has been submitted successfully.',
                            ),
                          );
                          _loadWallet();
                        } catch (e) {
                          setDialogState(() { isLoading = false; });
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (ctx) => PaymentStatusDialog(
                              status: PaymentStatus.failure,
                              title: 'Withdrawal Failed',
                              message: 'Unable to process your withdrawal of ${CurrencyFormatter.formatDisplay(amount ?? 0, selectedCurrency)} via $paymentMethod.\n\nError: ${e.toString()}',
                            ),
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: isLoading
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Request', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadWallet,
          ),
        ],
      ),
      body: _isLoading
          ? const WalletSkeletonLoader()
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_error!, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadWallet,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadWallet,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Balance Card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.blue, Colors.blueAccent],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Available Balance',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                CurrencyFormatter.formatDisplay(_wallet?['balance'] ?? 0, 'USD'),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: _showWithdrawDialog,
                                icon: const Icon(Icons.account_balance_wallet),
                                label: const Text('Withdraw'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.blue,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Transaction History
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Transaction History',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Navigate to full transaction history
                              },
                              child: const Text('See All'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Transactions List
                        if (_wallet?['transactions'] != null &&
                            _wallet!['transactions'].isNotEmpty)
                          ..._wallet!['transactions'].map<Widget>((transaction) {
                            return _TransactionCard(transaction: transaction);
                          }).toList()
                        else
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32),
                              child: Text(
                                'No transactions yet',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final Map<String, dynamic> transaction;

  const _TransactionCard({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final type = transaction['transaction_type'] ?? 'UNKNOWN';
    final amount = transaction['amount'] ?? 0;
    final status = transaction['status'] ?? 'PENDING';
    
    final isDeposit = type == 'DEPOSIT';
    final isEarning = type == 'EARNING';
    final isPositive = isDeposit || isEarning;

    IconData icon;
    Color iconColor;
    
    if (isDeposit) {
      icon = Icons.arrow_downward;
      iconColor = Colors.green;
    } else if (isEarning) {
      icon = Icons.work_outline;
      iconColor = Colors.green;
    } else {
      icon = Icons.arrow_upward;
      iconColor = Colors.red;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.1),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(
          _formatTransactionType(type),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          _formatDate(transaction['created_at']),
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${isPositive ? '+' : '-'}${CurrencyFormatter.formatDisplay(amount, 'USD')}',
              style: TextStyle(
                color: isPositive ? Colors.green : Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _getStatusColor(status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: _getStatusColor(status),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTransactionType(String type) {
    switch (type) {
      case 'EARNING':
        return 'Task Earning';
      case 'DEPOSIT':
        return 'Wallet Deposit';
      case 'WITHDRAWAL':
        return 'Withdrawal';
      default:
        return type;
    }
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'Unknown';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'Unknown';
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'COMPLETED':
        return Colors.green;
      case 'FAILED':
        return Colors.red;
      case 'PENDING':
      default:
        return Colors.orange;
    }
  }
}
