/// Stand-in for the network in the Agent Ready simulations.
///
/// The examples have no backend, so a request "completes" after a fixed delay. The delay is
/// product behaviour, not a visual value: a real application awaits its own service here and has
/// no such file. This is the one file under `agent_examples/` that writes `Duration` literals; the
/// consumer-rule test (`example/test/consumer_rules_test.dart`) lists it as the only R6 exemption.
library;

/// How long a simulated request takes.
enum SimulatedLatency {
  /// Saving a small change, such as publishing a draft.
  save(Duration(milliseconds: 300)),

  /// Publishing new content or retrying a failed send.
  publish(Duration(milliseconds: 320)),

  /// Delivering a chat message.
  send(Duration(milliseconds: 420));

  const SimulatedLatency(this.duration);

  /// The simulated round trip.
  final Duration duration;
}

/// Completes after [latency], like a request to a backend.
Future<void> simulateRequest(SimulatedLatency latency) =>
    Future<void>.delayed(latency.duration);
