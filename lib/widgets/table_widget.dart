import 'package:flutter/material.dart';
import 'package:otobix_crm/utils/app_colors.dart';

class TableWidget extends StatefulWidget {
  final String title;
  final double height; // total height (header + body)
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final double? minTableWidth;

  // NEW: fixed widths per column (same length as columns)
  final List<double>? columnWidths;

  // Styling
  final double headingRowHeight;
  final double dataRowMinHeight;
  final double dataRowMaxHeight;
  final double columnSpacing;
  final double horizontalMargin;
  final double titleSize;

  // Loading
  final bool isLoading;

  const TableWidget({
    super.key,
    required this.title,
    required this.height,
    required this.columns,
    required this.rows,
    this.minTableWidth,
    this.columnWidths, // <-- NEW
    this.headingRowHeight = 44,
    this.dataRowMinHeight = 40,
    this.dataRowMaxHeight = 56,
    this.columnSpacing = 0,
    this.horizontalMargin = 16,
    this.titleSize = 16,
    this.isLoading = false,
  });

  @override
  State<TableWidget> createState() => _TableWidgetState();
}

class _TableWidgetState extends State<TableWidget> {
  // Horizontal scroll (sync header <-> body)
  final ScrollController _hHeader = ScrollController();
  final ScrollController _hBody = ScrollController();

  // Vertical scroll (body only)
  final ScrollController _vBody = ScrollController();

  bool _syncing = false;

  @override
  void initState() {
    super.initState();

    _hHeader.addListener(() {
      if (_syncing) return;
      _syncing = true;
      if (_hBody.hasClients && _hBody.offset != _hHeader.offset) {
        _hBody.jumpTo(_hHeader.offset);
      }
      _syncing = false;
    });

    _hBody.addListener(() {
      if (_syncing) return;
      _syncing = true;
      if (_hHeader.hasClients && _hHeader.offset != _hBody.offset) {
        _hHeader.jumpTo(_hBody.offset);
      }
      _syncing = false;
    });
  }

  @override
  void dispose() {
    _hHeader.dispose();
    _hBody.dispose();
    _vBody.dispose();
    super.dispose();
  }

  // ---------- Helpers: apply fixed widths to columns & rows ----------
  List<DataColumn> _columnsWithWidths() {
    final widths = widget.columnWidths;
    if (widths == null || widths.length != widget.columns.length) {
      return widget.columns;
    }
    return List<DataColumn>.generate(widget.columns.length, (i) {
      final orig = widget.columns[i];
      return DataColumn(
        numeric: orig.numeric,
        tooltip: orig.tooltip,
        onSort: orig.onSort,
        label: SizedBox(
          width: widths[i],
          child: _NoWrap(child: orig.label),
        ),
      );
    });
  }

  List<DataRow> _rowsWithWidths() {
    final widths = widget.columnWidths;
    if (widths == null || widths.length != widget.columns.length) {
      return widget.rows;
    }

    return widget.rows.map((row) {
      final cells = <DataCell>[];
      for (int i = 0; i < row.cells.length; i++) {
        final orig = row.cells[i];
        final w = i < widths.length ? widths[i] : null;
        cells.add(
          DataCell(
            w == null
                ? _NoWrap(child: orig.child)
                : SizedBox(width: w, child: _NoWrap(child: orig.child)),
            placeholder: orig.placeholder,
            showEditIcon: orig.showEditIcon,
            onTap: orig.onTap,
            onLongPress: orig.onLongPress,
            onDoubleTap: orig.onDoubleTap,
            onTapCancel: orig.onTapCancel,
            onTapDown: orig.onTapDown,
          ),
        );
      }
      return DataRow(
        key: row.key,
        selected: row.selected,
        onSelectChanged: row.onSelectChanged,
        color: row.color,
        cells: cells,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final minTableWidth =
        widget.minTableWidth ?? (MediaQuery.of(context).size.width - 250);

    final columns = _columnsWithWidths();
    final rows = _rowsWithWidths();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            widget.title,
            style: TextStyle(
              color: AppColors.black,
              fontSize: widget.titleSize,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.grey.withValues(alpha: 0.25)),
          ),
          child: Column(
            children: [
              // -------- Header (no Scrollbar shown here) --------
              SingleChildScrollView(
                controller: _hHeader,
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: minTableWidth),
                  child: DataTable(
                    headingRowHeight: widget.headingRowHeight,
                    dataRowMinHeight: widget.dataRowMinHeight,
                    dataRowMaxHeight: widget.dataRowMaxHeight,
                    columnSpacing: widget.columnSpacing,
                    horizontalMargin: widget.horizontalMargin,
                    columns: columns,
                    rows: const <DataRow>[], // header-only
                  ),
                ),
              ),

              // -------- Body (vertical + horizontal scroll; scrollbars visible) --------
              widget.isLoading
                  ? SizedBox(
                      height: widget.height - widget.headingRowHeight,
                      child: const Center(
                        child: Text(
                          'Loading...',
                          style: TextStyle(
                            color: AppColors.green,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    )
                  : SizedBox(
                      height: widget.height - widget.headingRowHeight,
                      child: Scrollbar(
                        controller: _vBody,
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          controller: _vBody,
                          scrollDirection: Axis.vertical,
                          child: Scrollbar(
                            controller: _hBody,
                            thumbVisibility:
                                true, // horizontal thumb for body only
                            notificationPredicate: (n) =>
                                n.metrics.axis == Axis.horizontal,
                            child: SingleChildScrollView(
                              controller: _hBody,
                              scrollDirection: Axis.horizontal,
                              child: ConstrainedBox(
                                constraints:
                                    BoxConstraints(minWidth: minTableWidth),
                                child: DataTable(
                                  headingRowHeight: 0, // hide duplicate header
                                  dataRowMinHeight: widget.dataRowMinHeight,
                                  dataRowMaxHeight: widget.dataRowMaxHeight,
                                  columnSpacing: widget.columnSpacing,
                                  horizontalMargin: widget.horizontalMargin,
                                  columns: columns,
                                  rows: rows,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Prevent text wrapping/overflow differences between header/body
class _NoWrap extends StatelessWidget {
  final Widget child;
  const _NoWrap({required this.child});

  @override
  Widget build(BuildContext context) {
    if (child is Text) {
      final t = child as Text;
      return Text(
        t.data ?? '',
        style: t.style,
        maxLines: 1,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
        textAlign: t.textAlign,
      );
    }
    return child;
  }
}
