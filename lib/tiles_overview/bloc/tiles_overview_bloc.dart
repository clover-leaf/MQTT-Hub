import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:gateway_client/gateway_client.dart' hide FieldId;
import 'package:rfc_6901/rfc_6901.dart';
import 'package:user_repository/user_repository.dart';

part 'tiles_overview_event.dart';
part 'tiles_overview_state.dart';

class TilesOverviewBloc extends Bloc<TilesOverviewEvent, TilesOverviewState> {
  TilesOverviewBloc(this._userRepository, {required bool isAdmin})
      : super(TilesOverviewState(isAdmin: isAdmin)) {
    on<InitializationRequested>(_onInitialized);
    on<GatewayStatusSubscriptionRequested>(
      _onGatewayStatusSubscribed,
      transformer: concurrent(),
    );
    on<GatewayStatusCloseSubscriptionRequested>(
      _onGatewayStatusCloseSubscribed,
      transformer: concurrent(),
    );
    on<BrokerConnectionRequested>(
      _onBrokerConnected,
      transformer: concurrent(),
    );
    on<GatewayListenRequested>(
      _onGatewayListened,
      transformer: concurrent(),
    );
    on<GatewayPublishRequested>(
      _onGatewayPublished,
      transformer: concurrent(),
    );
    on<BrokerSubscriptionRequested>(_onBrokerSubscribed);
    on<ProjectSubscriptionRequested>(_onProjectSubscribed);
    on<DashboardSubscriptionRequested>(_onDashboardSubscribed);
    on<TileSubscriptionRequested>(_onTileSubscribed);
    on<DeviceSubscriptionRequested>(_onDeviceSubscribed);
    on<AttributeSubscriptionRequested>(_onAttributeSubscribed);
    on<SelectedProjectChanged>(_onSelectedProjectChanged);
    on<SelectedDashboardChanged>(_onSelectedDashboardChanged);
    on<LogoutRequested>(_onLogout);
  }

  final UserRepository _userRepository;

  Future<void> _onLogout(
    LogoutRequested event,
    Emitter<TilesOverviewState> emit,
  ) async {
    emit(state.copyWith(status: TilesOverviewStatus.processing));
    final brokers = List<Broker>.from(state.brokers);
    final gatewayClientView =
        Map<FieldId, GatewayClient>.from(state.gatewayClientView);
    final brokerTopicPayloads =
        Map<String, Map<String, String?>>.from(state.brokerTopicPayloads);
    for (final br in brokers) {
      // close its status stream
      final gatewayClient = gatewayClientView[br.id];
      if (gatewayClient != null) {
        add(GatewayStatusCloseSubscriptionRequested(gatewayClient));
        // remove it from brTpPl
        brokerTopicPayloads.remove(br.id);
        // disconnect old gwCl
        gatewayClient.disconnect();
      }
      // remove it from gwClView
      gatewayClientView.remove(br.id);
    }
    _userRepository.resetStream();
    emit(
      state.copyWith(
        status: TilesOverviewStatus.normal,
        isLogout: true,
        gatewayClientView: gatewayClientView,
        brokerTopicPayloads: brokerTopicPayloads,
      ),
    );
  }

  Future<void> _onInitialized(
    InitializationRequested event,
    Emitter<TilesOverviewState> emit,
  ) async {
    emit(state.copyWith(status: TilesOverviewStatus.processing));
    add(const BrokerSubscriptionRequested());
    add(const ProjectSubscriptionRequested());
    add(const DashboardSubscriptionRequested());
    add(const TileSubscriptionRequested());
    add(const DeviceSubscriptionRequested());
    add(const AttributeSubscriptionRequested());

    await _userRepository.initialize();
    emit(state.copyWith(status: TilesOverviewStatus.normal));

    // clone and update gatewayClients
    final gatewayClientView =
        Map<FieldId, GatewayClient>.from(state.gatewayClientView);
    for (final broker in state.brokers) {
      // create new gateway client
      final gatewayClient = _userRepository.createClient(
        brokerID: broker.id,
        url: broker.url,
        port: broker.port,
        account: broker.account,
        password: broker.password,
      );
      gatewayClientView[broker.id] = gatewayClient;
      add(GatewayStatusSubscriptionRequested(gatewayClient));
      add(BrokerConnectionRequested(gatewayClient));
    }
    emit(state.copyWith(gatewayClientView: gatewayClientView));
  }

  Future<void> _onGatewayStatusSubscribed(
    GatewayStatusSubscriptionRequested event,
    Emitter<TilesOverviewState> emit,
  ) async {
    await emit.forEach<ConnectionStatus>(
      _userRepository.getConnectionStatus(event.gatewayClient),
      onData: (status) {
        final brokerStatusView =
            Map<FieldId, ConnectionStatus>.from(state.brokerStatusView);
        brokerStatusView[event.gatewayClient.brokerID] = status;
        if (status.isDisconnected) {
          final gwClExist =
              state.gatewayClientView.containsKey(event.gatewayClient.brokerID);
          final brTopicExist = state.brokerTopicPayloads
              .containsKey(event.gatewayClient.brokerID);
          final brStExist =
              state.brokerStatusView.containsKey(event.gatewayClient.brokerID);
          // if it disconnected because mqtt broker error
          if (gwClExist && brTopicExist && brStExist) {
            add(BrokerConnectionRequested(event.gatewayClient));
          }
        }
        return state.copyWith(brokerStatusView: brokerStatusView);
      },
    );
  }

  Future<void> _onGatewayStatusCloseSubscribed(
    GatewayStatusCloseSubscriptionRequested event,
    Emitter<TilesOverviewState> emit,
  ) async {
    await _userRepository.closeConnectionStatusStream(event.gatewayClient);
    final brokerStatusView =
        Map<FieldId, ConnectionStatus>.from(state.brokerStatusView)
          ..remove(event.gatewayClient.brokerID);
    emit(state.copyWith(brokerStatusView: brokerStatusView));
  }

  Future<void> _onBrokerConnected(
    BrokerConnectionRequested event,
    Emitter<TilesOverviewState> emit,
  ) async {
    try {
      await event.gatewayClient.connect();
      // clone and update brokerTopicPayloads
      final brokerTopicPayloads =
          Map<FieldId, Map<String, String?>>.from(state.brokerTopicPayloads);
      final brokerTopic = brokerTopicPayloads[event.gatewayClient.brokerID] ??
          <String, String?>{};
      for (final dv in state.devices) {
        if (dv.brokerID == event.gatewayClient.brokerID) {
          event.gatewayClient.subscribe(dv.topic);
          brokerTopic[dv.topic] = null;
        }
      }
      brokerTopicPayloads[event.gatewayClient.brokerID] = brokerTopic;
      add(GatewayListenRequested(event.gatewayClient));
      emit(state.copyWith(brokerTopicPayloads: brokerTopicPayloads));
    } catch (e) {
      Future.delayed(
        const Duration(seconds: 6),
        () => add(BrokerConnectionRequested(event.gatewayClient)),
      );
    }
  }

  Future<void> _onGatewayListened(
    GatewayListenRequested event,
    Emitter<TilesOverviewState> emit,
  ) async {
    await emit.forEach<Map<String, String>>(
      _userRepository.getPublishMessage(event.gatewayClient),
      onData: (message) {
        final brokerID = message['broker_id']!;
        final topic = message['topic']!;
        final payload = message['payload']!;
        // clone
        final tileValueView = Map<FieldId, String?>.from(state.tileValueView);
        final brokerTopicPayloads =
            Map<FieldId, Map<String, String?>>.from(state.brokerTopicPayloads);
        final brokerTopic = brokerTopicPayloads[event.gatewayClient.brokerID] ??
            <String, String?>{};
        // update brokerTopicPayloads
        brokerTopic[topic] = payload;
        brokerTopicPayloads[brokerID] = brokerTopic;
        for (final tile in state.tiles) {
          final dv = state.deviceView[tile.deviceID]!;
          // update tile value view if device's broker and topic match
          // with payload's broker and topic
          if (dv.brokerID == brokerID && dv.topic == topic) {
            final att = state.attributeView[tile.attributeID]!;
            final value = readJson(
              expression: att.jsonPath,
              payload: payload,
            );
            tileValueView[tile.id] = value;
          }
        }
        return state.copyWith(
          brokerTopicPayloads: brokerTopicPayloads,
          tileValueView: tileValueView,
        );
      },
    );
  }

  void _onGatewayPublished(
    GatewayPublishRequested event,
    Emitter<TilesOverviewState> emit,
  ) {
    final activeDevice = state.deviceView[event.deviceID];
    final activeAttribute = state.attributeView[event.attributeID];
    final expression = activeAttribute?.jsonPath;
    final topic = activeDevice?.topic;
    final brokerID = activeDevice?.brokerID;
    if (expression != null && topic != null && brokerID != null) {
      final client = state.gatewayClientView[brokerID];
      final connectionStatus = state.brokerStatusView[brokerID];
      if (client != null &&
          connectionStatus != null &&
          connectionStatus.isConnected) {
        final payload = writeJson(expression: expression, value: event.value);
        _userRepository.publishMessage(
          client,
          topic: topic,
          payload: payload,
        );
      }
    }
  }

  Future<void> _onBrokerSubscribed(
    BrokerSubscriptionRequested event,
    Emitter<TilesOverviewState> emit,
  ) async {
    await emit.forEach<List<Broker>>(
      _userRepository.subscribeBrokerStream(),
      onData: (brokers) {
        final brokerView = {for (final br in brokers) br.id: br};
        // clone
        final gatewayClientView =
            Map<FieldId, GatewayClient>.from(state.gatewayClientView);
        final brokerTopicPayloads =
            Map<FieldId, Map<String, String?>>.from(state.brokerTopicPayloads);
        // hanlde new broker
        final newBrokers = brokers.where(
          (br) => !state.brokerView.keys.contains(br.id),
        );
        for (final br in newBrokers) {
          // create new gateway client
          final gatewayClient = _userRepository.createClient(
            brokerID: br.id,
            url: br.url,
            port: br.port,
            account: br.account,
            password: br.password,
          );
          gatewayClientView[br.id] = gatewayClient;
          brokerTopicPayloads[br.id] = <String, String?>{};
          add(GatewayStatusSubscriptionRequested(gatewayClient));
          add(BrokerConnectionRequested(gatewayClient));
        }
        // handle edited brokers
        final editedBrokers = brokers.where(
          (br) =>
              state.brokerView.keys.contains(br.id) &&
              state.brokerView[br.id] != brokerView[br.id],
        );
        for (final br in editedBrokers) {
          // only restart gateway client when either
          // url, port, account, password has changed
          if (state.brokerView[br.id]!.url != brokerView[br.id]!.url ||
              state.brokerView[br.id]!.port != brokerView[br.id]!.port ||
              state.brokerView[br.id]!.account != brokerView[br.id]!.account ||
              state.brokerView[br.id]!.password !=
                  brokerView[br.id]!.password) {
            // disconnect old gwCl
            final oldGatewayClient = gatewayClientView[br.id];
            if (oldGatewayClient != null) {
              oldGatewayClient.disconnect();
            }
            // create new gateway client
            final gatewayClient = _userRepository.createClient(
              brokerID: br.id,
              url: br.url,
              port: br.port,
              account: br.account,
              password: br.password,
            );
            gatewayClientView[br.id] = gatewayClient;
            add(GatewayStatusSubscriptionRequested(gatewayClient));
            add(BrokerConnectionRequested(gatewayClient));
          }
        }
        // handle deleted brokers
        final deletedBrokers =
            state.brokers.where((br) => !brokerView.keys.contains(br.id));
        for (final br in deletedBrokers) {
          // close its status stream
          final gatewayClient = gatewayClientView[br.id];
          if (gatewayClient != null) {
            add(GatewayStatusCloseSubscriptionRequested(gatewayClient));
            // remove it from brTpPl
            brokerTopicPayloads.remove(br.id);
            // disconnect old gwCl
            gatewayClient.disconnect();
          }
          // remove it from gwClView
          gatewayClientView.remove(br.id);
        }
        return state.copyWith(
          brokers: brokers,
          gatewayClientView: gatewayClientView,
          brokerTopicPayloads: brokerTopicPayloads,
        );
      },
    );
  }

  Future<void> _onDeviceSubscribed(
    DeviceSubscriptionRequested event,
    Emitter<TilesOverviewState> emit,
  ) async {
    await emit.forEach<List<Device>>(
      _userRepository.subscribeDeviceStream(),
      onData: (devices) {
        final deviceView = {for (final dv in devices) dv.id: dv};
        // clone
        final brokerTopicPayloads =
            Map<FieldId, Map<String, String?>>.from(state.brokerTopicPayloads);
        // handle new device
        final newDevices = devices.where(
          (dv) => !state.deviceView.keys.contains(dv.id),
        );
        for (final dv in newDevices) {
          if (brokerTopicPayloads.containsKey(dv.brokerID)) {
            final brokerTopic = brokerTopicPayloads[dv.brokerID]!;
            if (!brokerTopic.containsKey(dv.topic)) {
              brokerTopic[dv.topic] = null;
              final brokerStatus = state.brokerStatusView[dv.brokerID];
              final gatewayClient = state.gatewayClientView[dv.brokerID];
              if (gatewayClient != null &&
                  brokerStatus != null &&
                  brokerStatus.isConnected) {
                gatewayClient.subscribe(dv.topic);
              }
              brokerTopicPayloads[dv.brokerID] = brokerTopic;
            }
          }
        }
        // handle edited devices
        final editedDevices = devices.where(
          (dv) =>
              state.deviceView.keys.contains(dv.id) &&
              state.deviceView[dv.id] != deviceView[dv.id],
        );
        for (final dv in editedDevices) {
          final oldDevice = state.deviceView[dv.id]!;
          // only handle when device changed broker or topic

          if (oldDevice.brokerID != dv.brokerID ||
              oldDevice.topic != dv.topic) {
            // delete old topic from old brokerTopic
            if (brokerTopicPayloads.containsKey(oldDevice.brokerID)) {
              final oldBrokerTopic = brokerTopicPayloads[oldDevice.brokerID]!;
              if (oldBrokerTopic.containsKey(oldDevice.topic)) {
                oldBrokerTopic.remove(oldDevice.topic);
                final brokerStatus = state.brokerStatusView[oldDevice.brokerID];
                final oldGatewayClient =
                    state.gatewayClientView[oldDevice.brokerID];
                if (oldGatewayClient != null &&
                    brokerStatus != null &&
                    brokerStatus.isConnected) {
                  // unsubscribe old topic
                  oldGatewayClient.unsubscribe(oldDevice.topic);
                }
                brokerTopicPayloads[oldDevice.brokerID] = oldBrokerTopic;
              }
            }
            // add new topic to brokerTopic
            if (brokerTopicPayloads.containsKey(oldDevice.brokerID)) {
              final newBrokerTopic = brokerTopicPayloads[dv.brokerID]!;
              if (!newBrokerTopic.containsKey(dv.topic)) {
                newBrokerTopic[dv.topic] = null;
                final brokerStatus = state.brokerStatusView[dv.brokerID];
                final gatewayClient = state.gatewayClientView[dv.brokerID];
                if (gatewayClient != null &&
                    brokerStatus != null &&
                    brokerStatus.isConnected) {
                  gatewayClient.subscribe(dv.topic);
                }
                brokerTopicPayloads[dv.brokerID] = newBrokerTopic;
              }
            }
          }
        }
        // handle deleted devices
        final deleteDevices =
            state.devices.where((dv) => !deviceView.keys.contains(dv.id));
        for (final dv in deleteDevices) {
          if (brokerTopicPayloads.containsKey(dv.brokerID)) {
            final brokerTopic = brokerTopicPayloads[dv.brokerID]!;
            if (brokerTopic.containsKey(dv.topic)) {
              brokerTopic.remove(dv.topic);
              final brokerStatus = state.brokerStatusView[dv.brokerID];
              final gatewayClient = state.gatewayClientView[dv.brokerID];
              if (gatewayClient != null &&
                  brokerStatus != null &&
                  brokerStatus.isConnected) {
                // unsubscribe old topic
                gatewayClient.unsubscribe(dv.topic);
              }
              brokerTopicPayloads[dv.brokerID] = brokerTopic;
            }
          }
        }
        return state.copyWith(
          devices: devices,
          brokerTopicPayloads: brokerTopicPayloads,
        );
      },
    );
  }

  Future<void> _onTileSubscribed(
    TileSubscriptionRequested event,
    Emitter<TilesOverviewState> emit,
  ) async {
    await emit.forEach<List<Tile>>(
      _userRepository.subscribeTileStream(),
      onData: (tiles) {
        final tileView = {for (final tl in tiles) tl.id: tl};
        // clone
        final tileValueView = Map<FieldId, String?>.from(state.tileValueView);
        // handle new tile and edited tile
        final newTiles = tiles.where(
          (tl) => !state.tileView.keys.contains(tl.id),
        );
        final editedTiles = tiles.where(
          (dv) =>
              state.deviceView.keys.contains(dv.id) &&
              state.deviceView[dv.id] != tileView[dv.id],
        );
        for (final tl in [...newTiles, ...editedTiles]) {
          final dv = state.deviceView[tl.deviceID];
          final att = state.attributeView[tl.attributeID];
          final brokerTopic = state.brokerTopicPayloads[dv?.brokerID];
          if (brokerTopic != null &&
              brokerTopic.containsKey(dv?.topic) &&
              att != null) {
            final payload = brokerTopic[dv?.topic];
            if (payload == null) {
              tileValueView[tl.id] = null;
            } else {
              final value = readJson(
                expression: att.jsonPath,
                payload: payload,
              );
              tileValueView[tl.id] = value;
            }
          }
        }
        // handle deleted tiles
        final deletedTiles =
            state.tiles.where((tl) => !tileView.keys.contains(tl.id));
        for (final tl in deletedTiles) {
          tileValueView.remove(tl.id);
        }
        return state.copyWith(tiles: tiles, tileValueView: tileValueView);
      },
    );
  }

  Future<void> _onProjectSubscribed(
    ProjectSubscriptionRequested event,
    Emitter<TilesOverviewState> emit,
  ) async {
    await emit.forEach<List<Project>>(
      _userRepository.subscribeProjectStream(),
      onData: (projects) {
        final projectView = {for (final pr in projects) pr.id: pr};
        final newProjects =
            projects.where((pr) => !state.projectView.containsKey(pr.id));
        final deletedProjects =
            state.projects.where((pr) => !projectView.containsKey(pr.id));
        // clone
        final projectDashboardView =
            Map<FieldId, String?>.from(state.projectDashboardView);
        var selectedProjectID = state.selectedProjectID;
        // handle new project
        for (final pr in newProjects) {
          final dashboards =
              state.dashboards.where((db) => db.projectID == pr.id).toList();
          projectDashboardView[pr.id] =
              dashboards.isNotEmpty ? dashboards.first.id : null;
        }
        if (selectedProjectID == null && newProjects.isNotEmpty) {
          selectedProjectID = newProjects.first.id;
        }
        for (final pr in deletedProjects) {
          projectDashboardView.remove(pr.id);
        }
        if (projects.isEmpty) {
          selectedProjectID = null;
        }
        return state.copyWith(
          projects: projects,
          projectDashboardView: projectDashboardView,
          selectedProjectID: () => selectedProjectID,
        );
      },
    );
  }

  Future<void> _onDashboardSubscribed(
    DashboardSubscriptionRequested event,
    Emitter<TilesOverviewState> emit,
  ) async {
    await emit.forEach<List<Dashboard>>(
      _userRepository.subscribeDashboardStream(),
      onData: (dashboards) {
        // clone
        final projectDashboardView =
            Map<FieldId, String?>.from(state.projectDashboardView);
        final newProjectDashboardView = {
          for (final pr in state.projects)
            pr.id: projectDashboardView[pr.id] ??
                dashboards.firstWhere((db) => db.projectID == pr.id).id
        };
        return state.copyWith(
          dashboards: dashboards,
          projectDashboardView: newProjectDashboardView,
        );
      },
    );
  }

  Future<void> _onAttributeSubscribed(
    AttributeSubscriptionRequested event,
    Emitter<TilesOverviewState> emit,
  ) async {
    await emit.forEach<List<Attribute>>(
      _userRepository.subscribeAttributeStream(),
      onData: (attributes) {
        return state.copyWith(attributes: attributes);
      },
    );
  }

  void _onSelectedProjectChanged(
    SelectedProjectChanged event,
    Emitter<TilesOverviewState> emit,
  ) {
    emit(state.copyWith(selectedProjectID: () => event.projectID));
  }

  void _onSelectedDashboardChanged(
    SelectedDashboardChanged event,
    Emitter<TilesOverviewState> emit,
  ) {
    // clone
    final projectDashboardView =
        Map<FieldId, String?>.from(state.projectDashboardView);
    projectDashboardView[state.selectedProjectID!] = event.dashboardID;
    emit(state.copyWith(projectDashboardView: projectDashboardView));
  }

  /// get value in json by expression
  String readJson({required String expression, required String payload}) {
    try {
      final decoded = jsonDecode(payload);
      final pointer = JsonPointer(expression);
      final value = pointer.read(decoded);
      if (value == null) {
        return '?';
      }
      switch (value.runtimeType) {
        case String:
          return value as String;
        default:
          return value.toString();
      }
    } catch (e) {
      return '?';
    }
  }

  /// write value to json by expression
  String writeJson({required String expression, required String value}) {
    try {
      final pointer = JsonPointer(expression);
      final payload = pointer.write({}, value);
      return jsonEncode(payload);
    } catch (e) {
      throw Exception();
    }
  }
}
