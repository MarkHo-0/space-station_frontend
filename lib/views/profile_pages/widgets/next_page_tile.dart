import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:space_station/views/_share/unknown_error_popup.dart';

class NextPageTile extends StatelessWidget {
  final IconData? leadingIcon;
  final String title;
  final Widget? nextPage;

  const NextPageTile({
    super.key,
    this.leadingIcon,
    required this.title,
    this.nextPage,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: leadingIcon != null
          ? Icon(
              leadingIcon,
              color: Theme.of(context).textTheme.bodyLarge!.color,
            )
          : null,
      trailing: leadingIcon == null
          ? Icon(
              Icons.arrow_forward_ios,
              color: Theme.of(context).primaryColor,
            )
          : null,
      onTap: () {
        //如果沒設定下一頁，則彈出錯誤
        if (nextPage == null) {
          return showUnkownErrorDialog(context);
        }
        //跳轉到下一頁
        Navigator.of(context).push(CupertinoPageRoute(
          builder: ((_) => nextPage!),
          title: title,
        ));
      },
    );
  }
}
