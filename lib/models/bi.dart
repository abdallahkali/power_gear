/// نص ثنائي اللغة (عربي / إنجليزي)
class Bi {
  final String ar, en;
  const Bi(this.ar, this.en);
  String of(String lang) => lang == 'ar' ? ar : en;
  Map<String, dynamic> toJson() => {'ar': ar, 'en': en};
  factory Bi.fromJson(Map<String, dynamic> j) => Bi(j['ar'] as String, j['en'] as String);
}
