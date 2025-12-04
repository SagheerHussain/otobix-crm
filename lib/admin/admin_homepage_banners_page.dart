import 'package:flutter/material.dart';

class AdminHomepageBannersPage extends StatelessWidget {
  const AdminHomepageBannersPage({super.key});

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
