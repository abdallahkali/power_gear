import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'l10n.dart';

final _num = NumberFormat.decimalPattern('en');

String money(BuildContext c, int v) => '${_num.format(v)} ${c.t('currency')}';
String fmtDate(BuildContext c, DateTime d) => DateFormat('d MMM yyyy • h:mm a', c.lang).format(d);
