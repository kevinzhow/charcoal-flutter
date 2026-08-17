/// Command-line discovery and setup tools for Charcoal UI.
library;

import 'dart:io';

import 'src/runner.dart';

export 'package:charcoal_catalog/charcoal_catalog.dart'
    show
        CharcoalCatalogSearch,
        CharcoalPatternSearchResult,
        CharcoalSearchResult,
        CharcoalTokenSearchResult;

export 'src/agent_instructions.dart'
    show
        buildCharcoalManagedBlock,
        charcoalAgentEndMarker,
        charcoalAgentStartMarker,
        charcoalManagedBlockPattern;
export 'src/agent_skill.dart'
    show
        charcoalPageDesignSkillName,
        charcoalPageDesignSkillVersion,
        charcoalSkillDirectoryHash,
        charcoalSkillInstallManifest,
        readCharcoalSkillManifest,
        resolveCharcoalSkillSource;
export 'src/benchmark.dart'
    show
        CharcoalBenchmarkFormatException,
        CharcoalBenchmarkReport,
        charcoalBenchmarkArtifactKeys,
        charcoalBenchmarkConfigurations,
        charcoalBenchmarkGraderHardFailures,
        charcoalBenchmarkGraderScoreGuidance,
        charcoalBenchmarkGraderScoreLimits,
        charcoalBenchmarkHardFailures,
        charcoalBenchmarkScoreLimits,
        charcoalBenchmarkV2ArtifactKeys,
        evaluateCharcoalBenchmark;
export 'src/benchmark_runner.dart'
    show
        CharcoalAutomatedAssessment,
        CharcoalBenchmarkExecution,
        CharcoalBenchmarkInvocation,
        CharcoalBenchmarkProcessResult,
        CharcoalBenchmarkProcessRunner,
        CharcoalBenchmarkRunException,
        CharcoalBenchmarkRunOptions,
        CharcoalBenchmarkRunner,
        assessCharcoalBenchmarkCandidate,
        resolveCharcoalFlutterExecutable;
export 'src/codex_benchmark_adapter.dart'
    show
        CharcoalCodexAdapterException,
        CharcoalCodexAdapterOptions,
        CharcoalCodexProcessInvocation,
        buildCharcoalCodexExecutorInvocation,
        buildCharcoalCodexGraderInvocation,
        charcoalCodexAdapterVersion,
        charcoalCodexReasoningEfforts,
        parseCharcoalCodexAdapterArguments,
        readCharcoalCodexRequest,
        runCharcoalCodexProcess;
export 'src/page_experience.dart'
    show
        CharcoalPageSpecValidation,
        buildCharcoalPageExperienceTemplate,
        charcoalPageExperienceSpecVersion,
        validateCharcoalPageExperienceSpec;

/// Runs the Charcoal CLI without terminating the host process.
///
/// Supplying sinks and a working directory keeps this entry point straightforward to test and
/// embed in other Dart tools.
Future<int> runCharcoalCli(
  List<String> arguments, {
  StringSink? output,
  StringSink? errorOutput,
  Directory? workingDirectory,
}) {
  final machineReadable = arguments.contains('--json');
  final sanitizedArguments = arguments.where((argument) => argument != '--json').toList();
  final environment = CharcoalCliEnvironment(
    errorOutput: errorOutput ?? stderr,
    machineReadable: machineReadable,
    output: output ?? stdout,
    workingDirectory: workingDirectory ?? Directory.current,
  );
  return CharcoalCommandRunner(environment).execute(sanitizedArguments);
}
