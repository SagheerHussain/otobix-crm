// widgets/pager_widget.dart
import 'package:flutter/material.dart';
import 'package:otobix_crm/utils/app_colors.dart';

class PagerWidget extends StatelessWidget {
  final int current;
  final int total;
  final bool hasPrev;
  final bool hasNext;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final void Function(int page) onGoTo;

  const PagerWidget({
    super.key,
    required this.current,
    required this.total,
    required this.hasPrev,
    required this.hasNext,
    required this.onPrev,
    required this.onNext,
    required this.onGoTo,
  });

  List<dynamic> _visiblePages(int current, int total) {
    if (total <= 7) {
      return List<int>.generate(total, (i) => i + 1);
    }
    final start = (current - 2).clamp(1, total);
    final end = (current + 2).clamp(1, total);

    final set = <int>{1, total};
    for (int i = start; i <= end; i++) set.add(i);

    final pages = set.toList()..sort();

    final withDots = <dynamic>[];
    for (int i = 0; i < pages.length; i++) {
      withDots.add(pages[i]);
      if (i < pages.length - 1 && pages[i + 1] != pages[i] + 1) {
        withDots.add('…');
      }
    }
    return withDots;
  }

  Widget _pageChip(BuildContext context, dynamic item, bool isActive) {
    if (item is String) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Text('…',
            style: TextStyle(color: AppColors.grey.withValues(alpha: .9))),
      );
    }

    final int pageNum = item as int;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: () => onGoTo(pageNum),
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.green.withValues(alpha: .15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isActive
                  ? AppColors.green
                  : AppColors.grey.withValues(alpha: .5),
            ),
          ),
          child: Text(
            '$pageNum',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isActive ? AppColors.green : AppColors.black,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pageItems = _visiblePages(current, total);
    final jumpController = TextEditingController(text: current.toString());

    return Row(
      children: [
        OutlinedButton.icon(
          onPressed: hasPrev ? onPrev : null,
          icon: const Icon(Icons.chevron_left),
          label: const Text('Prev'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.green,
            side: const BorderSide(color: AppColors.green),
          ),
        ),
        Expanded(
          child: Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ...pageItems.map(
                    (it) => _pageChip(context, it, it is int && it == current)),
                const SizedBox(width: 16),
                Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border:
                        Border.all(color: AppColors.grey.withValues(alpha: .6)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 50,
                        child: TextField(
                          controller: jumpController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Page',
                            isDense: true,
                          ),
                          onSubmitted: (value) {
                            final p = int.tryParse(value.trim());
                            if (p == null) return;
                            if (p < 1 || p > total) return;
                            onGoTo(p);
                          },
                        ),
                      ),
                      const SizedBox(width: 5),
                      SizedBox(
                        height: 30,
                        child: ElevatedButton(
                          onPressed: () {
                            final p = int.tryParse(jumpController.text.trim());
                            if (p == null) return;
                            if (p < 1 || p > total) return;
                            onGoTo(p);
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            elevation: 0,
                            foregroundColor: AppColors.green,
                          ),
                          child: const Text('Go'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        OutlinedButton.icon(
          onPressed: hasNext ? onNext : null,
          icon: const Icon(Icons.chevron_right),
          label: const Text('Next'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.green,
            side: const BorderSide(color: AppColors.green),
          ),
        ),
      ],
    );
  }
}
