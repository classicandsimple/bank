import 'package:flutter/material.dart';
import 'dart:math';

import '../models/transaction.dart';
import '../styles/styles.dart';


class BankBottomAppBar extends StatefulWidget {
  final double balance;
  final Function transactionCallback;

  const BankBottomAppBar(
      {super.key, required this.transactionCallback, required this.balance});

  @override
  State<BankBottomAppBar> createState() {
    return _BankBottomAppBarState();
  }
}

class _BankBottomAppBarState extends State<BankBottomAppBar> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                double amount = Random().nextDouble() * 999.98 + 0.01;
                widget.transactionCallback(amount, TransactionType.deposit);
              },
              style: depositElevatedButtonStyle,
              child: Text(
                "Depósito",
                style: transactionTextElevatedButtonStyle,
              ),
            ),
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                double amount = Random().nextDouble() * 999.99 + 0.01;
                if (widget.balance - amount >= 0) {
                  widget.transactionCallback(amount, TransactionType.withdraw);
                } else {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Saldo insuficiente!"),
                      content: Text(
                        "Seu saldo atual é de R\$${widget.balance.toStringAsFixed(2)} e você precisa de R\$${amount.toStringAsFixed(2)} para completar a transação. Por favor, tente novamente ou deposite mais dinheiro.",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "OK",
                            style: TextStyle(
                              color: Color(0xFF1DA756),
                              fontSize: 20,
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }
              },
              style: withdrawlevatedButtonStyle,
              child: Text(
                "Saque",
                style: transactionTextElevatedButtonStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
