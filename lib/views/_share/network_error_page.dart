import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';

class NetworkErrorPage extends StatelessWidget {
  const NetworkErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.mobiledata_off,
            color: Theme.of(context).primaryColor,
            size: 100,
          ),
          Text(
            context.getString('net_err_title'),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(
            context.getString('net_err_subtitle'),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 300,
            child: Text(
              context.getString('net_err_solution'),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.justify,
            ),
          )
        ],
      ),
    );
  }
}
