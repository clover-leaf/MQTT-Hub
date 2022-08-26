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

    case AppStatus.userAuthenticated:
      return [TilesOverviewPage.page(isAdmin: false)];

    case AppStatus.adminAuthenticated:
      return [TilesOverviewPage.page(isAdmin: true)];
  }
}
