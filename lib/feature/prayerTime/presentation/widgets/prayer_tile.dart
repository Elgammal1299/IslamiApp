

import 'package:adhan/adhan.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PrayerTileWidget extends StatelessWidget {
  final Prayer prayer;
  final DateTime time;
  final bool isCurrent;
  final String Function(Prayer) displayName;
  final String Function(DateTime) format;
  final IconData Function(Prayer) iconFor;

  const PrayerTileWidget({
    super.key,
    required this.prayer,
    required this.time,
    required this.isCurrent,
    required this.displayName,
    required this.format,
    required this.iconFor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isCurrent ? 2 : 0,
      color: isCurrent ? Colors.green.withOpacity(0.08) : null,
      child: ListTile(
        leading: Icon(iconFor(prayer), color: isCurrent ? Colors.green : null),
        title: Text(displayName(prayer)),
        trailing: Text(format(time)),
      ),
    );
  }
}

/// 🔁 ValueListenableBuilder لاثنين
class ValueListenableBuilder2<A, B> extends StatelessWidget {
  final ValueListenable<A> first;
  final ValueListenable<B> second;
  final Widget Function(BuildContext, A, B, Widget?) builder;
  final Widget? child;

  const ValueListenableBuilder2({
    super.key,
    required this.first,
    required this.second,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<A>(
      valueListenable: first,
      builder: (context, a, _) {
        return ValueListenableBuilder<B>(
          valueListenable: second,
          builder: (context, b, _) => builder(context, a, b, child),
        );
      },
    );
  }
}
