import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

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
            'net_err_title'.i18n(),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(
            'net_err_subtitle'.i18n(),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 300,
            child: Text(
              'net_err_solution'.i18n(),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.justify,
            ),
          )
        ],
      ),
    );
  }
}
