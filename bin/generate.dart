// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';

const _preservedKeywords = [
  'few',
  'many',
  'one',
  'other',
  'two',
  'zero',
  'male',
  'female',
];

void main(List<String> args) {
  if (_isHelpCommand(args)) {
    _printHelperDisplay();
  } else {
    handleLangFiles(_generateOption(args));
  }
}

bool _isHelpCommand(List<String> args) {
  return args.length == 1 && (args[0] == '--help' || args[0] == '-h');
}

void _printHelperDisplay() {
  var parser = _generateArgParser(null);
  stdout.writeln(parser.usage);
}

GenerateOptions _generateOption(List<String> args) {
  var generateOptions = GenerateOptions();
  var parser = _generateArgParser(generateOptions);
  parser.parse(args);
  return generateOptions;
}

ArgParser _generateArgParser(GenerateOptions? generateOptions) {
  var parser = ArgParser();

  parser.addOption(
    'source-dir',
    abbr: 'S',
    defaultsTo: 'resources/langs',
    callback: (String? x) => generateOptions!.sourceDir = x,
    help: 'Folder containing localization files',
  );

  parser.addOption(
    'source-file',
    abbr: 's',
    callback: (String? x) => generateOptions!.sourceFile = x,
    help: 'File to use for localization',
  );

  parser.addOption(
    'output-dir',
    abbr: 'O',
    defaultsTo: 'lib/generated',
    callback: (String? x) => generateOptions!.outputDir = x,
    help: 'Output folder stores for the generated file',
  );

  parser.addOption(
    'output-file',
    abbr: 'o',
    defaultsTo: 'codegen_loader.g.dart',
    callback: (String? x) => generateOptions!.outputFile = x,
    help: 'Output file name',
  );

  parser.addOption(
    'format',
    abbr: 'f',
    defaultsTo: 'json',
    callback: (String? x) => generateOptions!.format = x,
    help: 'Support json or keys formats',
    allowed: ['json', 'keys'],
  );

  parser.addFlag(
    'skip-unnecessary-keys',
    abbr: 'u',
    defaultsTo: false,
    callback: (bool? x) => generateOptions!.skipUnnecessaryKeys = x,
    help: 'If true - Skip unnecessary keys of nested objects.',
  );

  return parser;
}

class GenerateOptions {
  String? sourceDir;
  String? sourceFile;
  String? templateLocale;
  String? outputDir;
  String? outputFile;
  String? format;
  bool? skipUnnecessaryKeys;

  @override
  String toString() {
    return 'format: $format sourceDir: $sourceDir sourceFile: $sourceFile outputDir: $outputDir outputFile: $outputFile skipUnnecessaryKeys: $skipUnnecessaryKeys';
  }
}

void handleLangFiles(GenerateOptions options) async {
  final current = Directory.current;
  final source = Directory.fromUri(Uri.parse(options.sourceDir!));
  final output = Directory.fromUri(Uri.parse(options.outputDir!));
  final sourcePath = Directory(path.join(current.path, source.path));
  final outputPath = Directory(
    path.join(current.path, output.path, options.outputFile),
  );

  if (!await sourcePath.exists()) {
    stderr.writeln('Source path does not exist');
    return;
  }

  var files = await dirContents(sourcePath);
  if (options.sourceFile != null) {
    final sourceFile = File(path.join(source.path, options.sourceFile!));
    if (!await sourceFile.exists()) {
      stderr.writeln('Source file does not exist (${sourceFile.path})');
      return;
    }
    files = [sourceFile];
  } else {
    //filtering format
    files = files
        .where(
          (f) =>
              f.path.endsWith('.json') ||
              f.path.endsWith('.yaml') ||
              f.path.endsWith('.yml') ||
              f.path.endsWith('.dart'),
        )
        .toList();
  }

  if (files.isNotEmpty) {
    generateFile(files, outputPath, options);
  } else {
    stderr.writeln('Source path empty');
  }
}

Future<List<FileSystemEntity>> dirContents(Directory dir) {
  final files = <FileSystemEntity>[];
  final completer = Completer<List<FileSystemEntity>>();
  final lister = dir.list(recursive: false);
  lister.listen(
    (file) => files.add(file),
    onDone: () => completer.complete(files),
    onError: (e) => completer.completeError(e),
  );
  return completer.future;
}

void generateFile(
  List<FileSystemEntity> files,
  Directory outputPath,
  GenerateOptions options,
) async {
  var generatedFile = File(outputPath.path);
  if (!generatedFile.existsSync()) {
    generatedFile.createSync(recursive: true);
  }

  var classBuilder = StringBuffer();

  switch (options.format) {
    case 'json':
      await _writeJson(classBuilder, files);
      break;
    case 'keys':
      await _writeKeys(classBuilder, files, options.skipUnnecessaryKeys);
      break;
    // case 'csv':
    //   await _writeCsv(classBuilder, files);
    // break;
    default:
      stderr.writeln('Format not supported');
  }

  classBuilder.writeln('}');
  generatedFile.writeAsStringSync(classBuilder.toString());

  stdout.writeln('All done! File generated in ${outputPath.path}');
}

Future _writeKeys(
  StringBuffer classBuilder,
  List<FileSystemEntity> files,
  bool? skipUnnecessaryKeys,
) async {
  var outputFileContent = '''
// DO NOT EDIT. This is code generated via package:flutter_bantu_wallet_module/generate.dart

// ignore_for_file: constant_identifier_names

abstract class  LocaleKeys {
''';

  Map<String, dynamic>? translations;
  for (final file in files) {
    final fileData = File(file.path);
    final fileContent = await fileData.readAsString();

    if (file.path.endsWith('.json')) {
      translations = json.decode(fileContent);
    } else if (file.path.endsWith('.yaml') || file.path.endsWith('.yml')) {
      translations = loadYaml(fileContent);
    } else if (file.path.endsWith('.dart')) {
      // Extract the langMap
      final regex = RegExp(
        r'const Map<String, dynamic> langMap = ({.*?});',
        dotAll: true,
      );
      final match = regex.firstMatch(fileContent);
      if (match != null) {
        // try {
        translations = jsonDecode(match.group(1)!);
        // } catch (e) {
        //   //Fallback on eval if can't parse as json
        //   translations = eval(match.group(1)!);
        //
        // }
      } else {
        stderr.writeln(
          'Dart file must contain a const Map<String, dynamic> named langMap',
        );
        return;
      }
    } else {
      stderr.writeln('Unsupported file format: ${file.path}');
      return;
    }

    if (translations != null) {
      outputFileContent += _resolve(translations, skipUnnecessaryKeys);
    }
  }

  classBuilder.writeln(outputFileContent);
}

String _resolve(
  Map<String, dynamic> translations,
  bool? skipUnnecessaryKeys, [
  String? accKey,
]) {
  var fileContent = '';

  final sortedKeys = translations.keys.toList();

  final canIgnoreKeys = skipUnnecessaryKeys == true;

  bool containsPreservedKeywords(Map<String, dynamic> map) =>
      map.keys.any((element) => _preservedKeywords.contains(element));

  for (var key in sortedKeys) {
    var ignoreKey = false;
    if (translations[key] is Map) {
      // If key does not contain keys for plural(), gender() etc. and option is enabled -> ignore it
      ignoreKey = !containsPreservedKeywords(
            translations[key] as Map<String, dynamic>,
          ) &&
          canIgnoreKeys;

      var nextAccKey = key;
      if (accKey != null) {
        nextAccKey = '$accKey.$key';
      }

      fileContent +=
          _resolve(translations[key], skipUnnecessaryKeys, nextAccKey);
    }

    if (!_preservedKeywords.contains(key)) {
      accKey != null && !ignoreKey
          ? fileContent +=
              "  static const ${accKey.replaceAll('.', '_')}_$key = '$accKey.$key';\n"
          : !ignoreKey
              ? fileContent += "  static const $key = '$key';\n"
              : null;
    }
  }

  return fileContent;
}

Future _writeJson(
  StringBuffer classBuilder,
  List<FileSystemEntity> files,
) async {
  var gFile = '''
// DO NOT EDIT. This is code generated via package:flutter_bantu_wallet_module/generate.dart

// ignore_for_file: prefer_single_quotes, avoid_renaming_method_parameters, constant_identifier_names

import 'dart:ui';

import 'package:flutter_bantu_wallet_module/flutter_bantu_wallet_module.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  ''';

  final listLocales = [];

  for (var file in files) {
    Map<String, dynamic>? data;
    final localeName = path
        .basename(file.path)
        .replaceFirst(RegExp(r'\.(json|yaml|yml|dart)$'), '')
        .replaceAll('-', '_');
    listLocales.add('"$localeName": _$localeName');
    final fileData = File(file.path);
    final fileContent = await fileData.readAsString();
    if (file.path.endsWith('.json')) {
      data = json.decode(fileContent);
    } else if (file.path.endsWith('.yaml') || file.path.endsWith('.yml')) {
      data = loadYaml(fileContent);
    } else if (file.path.endsWith('.dart')) {
      // Extract the langMap
      final regex = RegExp(
        r'const Map<String, dynamic> langMap = ({.*?});',
        dotAll: true,
      );
      final match = regex.firstMatch(fileContent);
      if (match != null) {
        // try {
        data = jsonDecode(match.group(1)!);
        // } catch (e) {
        //   //Fallback on eval if can't parse as json
        //   data = eval(match.group(1)!);
        // }
      } else {
        stderr.writeln(
          'Dart file must contain a const Map<String, dynamic> named langMap',
        );
        return;
      }
    } else {
      stderr.writeln('Unsupported file format: ${file.path}');
      return;
    }

    if (data != null) {
      final mapString = const JsonEncoder.withIndent('  ').convert(data);
      gFile += 'static const Map<String,dynamic> _$localeName = $mapString;\n';
    }
  }

  gFile +=
      'static const Map<String, Map<String,dynamic>> mapLocales = {${listLocales.join(', ')}};';
  classBuilder.writeln(gFile);
}

// _writeCsv(StringBuffer classBuilder, List<FileSystemEntity> files) async {
//   List<String> listLocales = List();
//   final fileData = File(files.first.path);

//   // CSVParser csvParser = CSVParser(await fileData.readAsString());

//   // List listLangs = csvParser.getLanguages();
//   for(String localeName in listLangs){
//     listLocales.add('"$localeName": $localeName');
//     String mapString = JsonEncoder.withIndent("  ").convert(csvParser.getLanguageMap(localeName)) ;

//     classBuilder.writeln(
//       '  static const Map<String,dynamic> $localeName = ${mapString};\n');
//   }

//   classBuilder.writeln(
//       '  static const Map<String, Map<String,dynamic>> mapLocales = \{${listLocales.join(', ')}\};');

// }
