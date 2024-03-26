import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pocket_quake/components/earthquake_report_card.dart';
import 'package:pocket_quake/globals.dart';
import 'package:pocket_quake/utils/extensions.dart';

class Reports extends StatefulWidget {
  const Reports({super.key});

  @override
  State<StatefulWidget> createState() => _ReportsState();
}

class _ReportsState extends State<Reports>
    with AutomaticKeepAliveClientMixin<Reports> {
  @override
  get wantKeepAlive => true;

  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final ScrollController _controller = ScrollController();
  bool _isScrollToTopVisible = false;

  Future<void> _refreshReports() {
    return Global.api.getReportList(limit: 50).then((data) {
      setState(() {
        Global.reports = data;
      });
    }).catchError((e) {
      context.scaffold.showSnackBar(SnackBar(content: Text(e.toString())));
    });
  }

  void _scrollToTop() {
    _controller.animateTo(
      0,
      duration: const Duration(seconds: 1),
      curve: Easing.standard,
    );
  }

  @override
  void initState() {
    super.initState();

    if (Global.reports.isEmpty) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _refreshIndicatorKey.currentState?.show();
      });
      _refreshReports();
    }

    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.minScrollExtent) {
        setState(() {
          _isScrollToTopVisible = false;
        });
      } else {
        setState(() {
          _isScrollToTopVisible = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.viewReports),
      ),
      floatingActionButton: AnimatedScale(
        scale: _isScrollToTopVisible ? 1 : 0,
        duration: const Duration(milliseconds: 200),
        child: FloatingActionButton.small(
          onPressed: _scrollToTop,
          child: const Icon(Symbols.vertical_align_top_rounded),
        ),
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        backgroundColor: context.colors.surfaceVariant,
        onRefresh: _refreshReports,
        child: ListView.builder(
          padding: const EdgeInsets.all(12.0),
          controller: _controller,
          itemCount: Global.reports.length,
          itemBuilder: (context, index) =>
              EarthquakeReportCard(report: Global.reports[index]),
        ),
      ),
    );
  }
}
