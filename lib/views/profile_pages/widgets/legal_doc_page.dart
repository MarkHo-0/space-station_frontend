import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../_share/loading_page.dart';
import '../../forum_pages/widgets/dynamic_textbox/dynamic_textbox.dart';

class LegalDocPage extends StatelessWidget {
  final String docName;
  const LegalDocPage(this.docName, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: loadDoc(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const LoadingPage();
          }

          if (snapshot.data == null || snapshot.data!.isEmpty) {
            Navigator.of(context).pop();
          }

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: DynamicTextBox(snapshot.data!),
            ),
          );
        },
      ),
    );
  }

  Future<String> loadDoc() {
    return rootBundle
        .loadString('assets/legal_docs/$docName.txt')
        .catchError((_) => '');
  }
}
