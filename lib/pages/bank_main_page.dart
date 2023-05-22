import 'package:bank/widgets/bank_bottom_app_bar.dart';
import 'package:flutter/material.dart';

import '../models/transaction.dart';

class BankMainPage extends StatefulWidget {
  const BankMainPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<BankMainPage> createState() {
    return _BankMainPageState();
  }
}

class _BankMainPageState extends State<BankMainPage> {
  final List<Transaction> _transactionsDatabase = [];
  final ScrollController _scrollController = ScrollController();

  double get _balance {
    return _transactionsDatabase.fold(0, (previousValue, element) {
      switch (element.type) {
        case TransactionType.deposit:
          return previousValue + element.amount;
        default:
          return previousValue - element.amount;
      }
    });
  }

  void _addTransaction(double amount, TransactionType type) {
    setState(() {
      _transactionsDatabase.add(Transaction(amount, type, DateTime.now()));
    });

    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Saldo: R\$ ${_balance.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Histórico de transações:",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )),
          Expanded(
            child: Center(
              child: ListView.builder(
                controller: _scrollController,
                reverse: false,
                itemCount: _transactionsDatabase.length,
                itemBuilder: (context, index) {
                  final transaction = _transactionsDatabase[index];
                  return Center(
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            transaction.type == TransactionType.deposit
                                ? Icons.arrow_upward_rounded
                                : Icons.arrow_downward_rounded,
                            color: transaction.type == TransactionType.deposit
                                ? Colors.green
                                : Colors.red,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "${transaction.type == TransactionType.deposit ? "Depósito" : "Saque"} de R\$ ${transaction.amount.toStringAsFixed(2)}",
                            style: TextStyle(
                              color: transaction.type == TransactionType.deposit
                                      ? Colors.green
                                      : Colors.red,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      subtitle: Center(
                        child: Text(
                            "${transaction.date.day}/${transaction.date.month}/${transaction.date.year}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BankBottomAppBar(balance: _balance, transactionCallback: _addTransaction)
    );
  }
}
