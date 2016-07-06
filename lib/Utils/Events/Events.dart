library ClientCommon.Events.Events;

import 'package:harvest/harvest.dart';

enum TEvt
{
  ENTITY_CHANGE
}

class SysEvent extends DomainEvent {
  final TEvt type;
  final String source;
  final dynamic data;
  SysEvent(this.type, this.source, [this.data]);
}
