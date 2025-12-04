import 'package:flutter/material.dart';

class AdminDesktopHomepageBannersPage extends StatelessWidget {
  const AdminDesktopHomepageBannersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [],
            ),
          );
        },
      ),
    );
  }
}
