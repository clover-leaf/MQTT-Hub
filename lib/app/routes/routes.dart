import 'package:bee/app/app.dart';
import 'package:bee/login/login.dart';
import 'package:bee/tiles_overview/view/view.dart';
import 'package:flutter/material.dart';

List<Page<dynamic>> onGenerateAppViewPages(
  AppStatus state,
  List<Page<dynamic>> pages,
) {
  switch (state) {
    case AppStatus.unauthenticated:
      return [LoginPage.page()];

    case AppStatus.authenticated:
      return [TilesOverviewPage.page()];
  }
}
