// Copyright (c) 2012, Lukas Renggli <renggli@gmail.com>

#library('all_tests_jenkins');

#import('package:unittest/unittest.dart');

#import('all_tests.dart', prefix: 'all');

void main() {
  configure(new JenkinsConfiguration());
  all.main();
}

class JenkinsConfiguration extends Configuration {

  bool printed = false;

  void onStart() {
    // nothing to do
  }

  void onDone(int passed, int failed, int errors, List<TestCase> results, String uncaughtError) {
    if (!printed) {
      print('<?xml version="1.0" encoding="UTF-8" ?>');
      print('<testsuite name="All tests" tests="${results.length}" failures="$failed" errors="$errors">');
      for (var testcase in results) {
        print('  <testcase name="${_xml(testcase.description)}">');
        if (testcase.result == 'fail') {
          print('    <failure>${_xml(testcase.message)}</failure>');
        } else if (testcase.result == 'error') {
          print('    <error>${_xml(testcase.message)}</error>');
        }
        if (testcase.stackTrace != null && testcase.stackTrace != '') {
          print('    <system-err>${_xml(testcase.stackTrace)}</system-err>');
        }
        print('  </testcase>');
      }
      if (uncaughtError != null && uncaughtError != '') {
        print('  <system-err>${_xml(uncaughtError)}</system-err>');
      }
      print('</testsuite>');
      printed = true;
    }
  }

  String _xml(String string) {
    return string.replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;');
  }

}