import 'package:flutter/material.dart';
import 'package:otobix_crm/utils/app_colors.dart';

class TableWidget extends StatelessWidget {
  final String title;
  final List<DataColumn> columns;
  final List<DataRow> rows;

  const TableWidget({
    super.key,
    required this.title,
    required this.columns,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.grey.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
            child: Text(
              title,
              style: TextStyle(
                color: AppColors.green,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(),
          // Scrollable table
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Scrollbar(
              thumbVisibility: true,
              radius: const Radius.circular(8),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowHeight: 40,
                    dataRowHeight: 45,
                    horizontalMargin: 10,
                    columnSpacing: 30,
                    headingTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                    dataTextStyle: TextStyle(
                      color: AppColors.black,
                      fontSize: 14,
                    ),
                    border: TableBorder(
                      horizontalInside: BorderSide(
                        color: AppColors.grey.withValues(alpha: 0.3),
                        width: 0.7,
                      ),
                    ),
                    columns: columns,
                    rows: rows,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
