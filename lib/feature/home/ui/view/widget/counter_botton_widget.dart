import 'package:flutter/material.dart';

class CounterBottonWidget extends StatelessWidget {
  const CounterBottonWidget({super.key, required int counter})
    : _counter = counter;

  final int _counter;
 

  @override
  Widget build(BuildContext context) {
     final theme = Theme.of(context);
    return Container(
      width: 250,
      height: 250,
      decoration: BoxDecoration(
        shape: BoxShape.circle,

        color: Theme.of(context).primaryColor,
      ),
      child: Center(
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.secondaryHeaderColor,
          ),
          child: Center(
            child: Text(
              _counter.toString(),
              style: TextStyle(
                fontSize: 65,
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
