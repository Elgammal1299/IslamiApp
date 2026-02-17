import 'package:flutter/material.dart';

class customErrorWidget extends StatelessWidget {
  const customErrorWidget({super.key, this.onPressed});
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error, size: 50, color: Colors.red),
        const SizedBox(height: 10),
        Text(
          'تأكد من اتصالك بالإنترنت وحاول مرة أخرى.',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: onPressed,
          child: const Text('إعادة المحاولة'),
        ),
      ],
    );
  }
}
