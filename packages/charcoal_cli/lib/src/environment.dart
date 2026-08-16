import 'dart:convert';
import 'dart:io';

final class CharcoalCliEnvironment {
  const CharcoalCliEnvironment({
    required this.output,
    required this.errorOutput,
    required this.workingDirectory,
    required this.machineReadable,
  });

  final StringSink output;
  final StringSink errorOutput;
  final Directory workingDirectory;
  final bool machineReadable;

  void result(String type, Object? data, {required String text}) {
    if (machineReadable) {
      output.write(
        '${jsonEncode(<String, Object?>{'apiVersion': 1, 'type': type, 'data': data})}\n',
      );
    } else {
      output.write('$text\n');
    }
  }

  void failure(CharcoalCliFailure failure) {
    if (machineReadable) {
      errorOutput.write(
        '${jsonEncode(<String, Object?>{
          'apiVersion': 1,
          'error': failure.message,
          'code': failure.code,
          if (failure.suggestions.isNotEmpty) 'suggestions': failure.suggestions,
        })}\n',
      );
    } else {
      errorOutput.write('Error [${failure.code}]: ${failure.message}\n');
      if (failure.suggestions.isNotEmpty) {
        errorOutput.write('Suggestions: ${failure.suggestions.join(', ')}\n');
      }
    }
  }
}

final class CharcoalCliFailure implements Exception {
  const CharcoalCliFailure(
    this.code,
    this.message, {
    this.exitCode = 1,
    this.suggestions = const <String>[],
  });

  final String code;
  final String message;
  final int exitCode;
  final List<String> suggestions;
}
