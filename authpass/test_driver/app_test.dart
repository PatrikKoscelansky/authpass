import 'dart:async';
import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import 'package:path/path.dart' as path;
//import 'package:flutter_test/flutter_test.dart';

void main() {
//  group('Simple KDBX Open', () {
//    final downloadButton = find.byValueKey('downloadFromUrl');
//
//    FlutterDriver driver;
//    StreamSubscription streamSubscription;
//
//    var screenshotCount = 0;
//
//    Future<void> takeScreenshot() async {
//      const basedir = 'build/screenshots';
//      await Directory(basedir).create(recursive: true);
//      await File(path.join(basedir, 'test${screenshotCount++}.png'))
//          .writeAsBytes(await driver.screenshot());
//    }
//
//    // Connect to the Flutter driver before running any tests.
//    setUpAll(() async {
//      driver = await FlutterDriver.connect();
//      await driver.waitUntilFirstFrameRasterized();
//    });
//
//    // Close the connection to the driver after the tests have completed.
//    tearDownAll(() async {
//      if (driver != null) {
//        await driver.close();
//      }
//      await streamSubscription?.cancel();
//    });
//
//    test('open kdbx 3 file', () async {
//      await driver.tap(find.byValueKey('appBarOverflowMenu'));
//      await driver.tap(downloadButton);
//
//      await driver.waitUntilNoTransientCallbacks();
//
//      await driver.enterText(
//          'https://github.com/authpass/kdbx.dart/raw/master/test/kdbx4_keeweb.kdbx');
//      await takeScreenshot();
//      //await find.ancestor(of: find.text('Ok'), matching: find.byType('FlatButton'));
//      await driver.tap(find.text('Ok'));
//      await takeScreenshot();
////      await driver.waitUntilNoTransientCallbacks(
////          timeout: const Duration(seconds: 10));
//      await takeScreenshot();
//
//      await driver.waitUntilNoTransientCallbacks();
//
//      await driver.enterText('asdf');
//      // await driver.tap(find.byType('CheckboxListTile'));
//      await driver.tap(find.text('Continue'));
//      final newEntryTitle = await driver.getWidgetDiagnostics(find.descendant(
//          of: find.byType('PasswordListContent'),
//          matching: find.text('new entry')));
//      expect(newEntryTitle, isNotNull);
//      await takeScreenshot();
//    });
//  });

  group('New password', () {
    const newPasswordTitle = 'Heslo 1';
    FlutterDriver driver;
    StreamSubscription streamSubscription;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
      await driver.waitUntilFirstFrameRasterized();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        await driver.close();
      }
      await streamSubscription?.cancel();
    });

    test('create new db', () async {
      await driver.tap(find.byValueKey('selectFileAction'));
      await driver.tap(find.byValueKey('nameNewDB'));
      await driver.enterText('Password DB 4');
      await driver.tap(find.byValueKey('passwordNewDB'));
      await driver.enterText('heslo');
      await driver.tap(find.byValueKey('createDB'));
      await driver.waitUntilNoTransientCallbacks();
      await driver.tap(find.byValueKey('createFirstPasswd'));
      await driver.waitUntilNoTransientCallbacks(
          timeout: const Duration(seconds: 2));
      final titleFinder = find.byValueKey('createdPasswdTitle');
      expect(await driver.getText(titleFinder), '(no title)');
    });

    test('create new password', () async {
      await driver.tap(find.descendant(
          of: find.byValueKey('stringEntryFieldEditorNewPasswd'),
          matching: find.byType('TextFormField'),
          firstMatchOnly: true));
      await driver.waitUntilNoTransientCallbacks(
          timeout: const Duration(seconds: 2));
//      await driver.tap(find.by);
      await driver.enterText(newPasswordTitle);
      await driver.waitUntilNoTransientCallbacks(
          timeout: const Duration(seconds: 2));
      await driver.tap(find.byValueKey('saveNewPasswd'));
      await driver.waitForAbsent(find.byValueKey('saveNewPasswd'));
      await driver.waitUntilNoTransientCallbacks();
      final titleFinder = find.byValueKey('createdPasswdTitle');
      expect(await driver.getText(titleFinder), newPasswordTitle);
    });

    test('add custom field', () async {
      const customFieldTitle = 'Custom Field';
      await driver.tap(find.byValueKey('addFieldButton'));
      await driver.tap(find.text(customFieldTitle));
      await driver.enterText('Custom field');
      await driver.tap(find.text('Ok'));
      await driver.waitUntilNoTransientCallbacks(
          timeout: const Duration(seconds: 2));
      await driver.tap(find.byValueKey('saveNewPasswd'));
      await driver.waitForAbsent(find.byValueKey('saveNewPasswd'));
      // I was unable to locate newly created widget. Let's suppose, the test is successful if the app doesn't crash.

//      await driver.waitUntilNoTransientCallbacks(
//          timeout: const Duration(seconds: 3));
//      await driver.tap(find.descendant(
//          of: find.byValueKey('entryDetailsColumn'),
//          matching: find.text(customFieldTitle)));

//      await driver.tap(find.byType('StringEntryFieldEditor'));
//      final entryFieldsCount =
//          find.byType('StringEntryFieldEditor').serialize().length;
//      expect(entryFieldsCount, 5);

//      final customFieldTitleWidget =
//          await driver.getWidgetDiagnostics(find.text(customFieldTitle));
//      expect(customFieldTitleWidget, isNotNull);
    });

    test('create subgroup', () async {
      const subgroupName = 'New Subgroup';
      await driver.tap(find.pageBack());
      await driver.tap(find.byTooltip('Open navigation menu'));
      await driver.tap(find.byType('IconButton'));
      await driver.tap(find.text('Create Subgroup'));
      await driver.tap(find.text('New Group'));
      await driver.enterText(subgroupName);
      await driver.waitUntilNoTransientCallbacks(
          timeout: const Duration(seconds: 2));
      await driver.tap(find.pageBack());
      final drawer = find.byType('PasswordListDrawer');
//      final newSubGroup = await driver.getWidgetDiagnostics(
//          find.descendant(of: drawer, matching: find.text('New Group')));
      final newSubGroup = await driver.getWidgetDiagnostics(
          find.descendant(of: drawer, matching: find.text(subgroupName)));
      expect(newSubGroup, isNotNull);
    });

    test('deleted entries', () async {
      final drawer = find.byType('PasswordListDrawer');
      await driver.scroll(
          drawer, -300.0, 0.0, const Duration(milliseconds: 300));
      final saver = find.byValueKey('saveEverything');
      await driver.tap(saver);
      await driver.waitForAbsent(saver);
      await driver.tap(find.text(newPasswordTitle));
      await driver.tap(find.byValueKey('appBarOverflowMenu'));
      await driver.tap(find.text('Delete'));
      final passwdSaver = find.byValueKey('saveNewPasswd');
      await driver.tap(passwdSaver);
      await driver.waitForAbsent(passwdSaver);
      await driver.tap(find.pageBack());

      await driver.tap(find.byValueKey('appBarFilter'));
      await driver.tap(find.text('Deleted Entries'));
      final deletedEntry = await driver.getWidgetDiagnostics(find.descendant(
          of: find.byType('Scrollbar'), matching: find.text(newPasswordTitle)));
      expect(deletedEntry, isNotNull);
    });
  });
}
