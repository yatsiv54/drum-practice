class TagDef {
  final String name;           
  final int color;             

  const TagDef({required this.name, required this.color});

  factory TagDef.fromJson(Map<String, dynamic> j) =>
      TagDef(name: j['name'] as String, color: j['color'] as int);

  Map<String, dynamic> toJson() => {'name': name, 'color': color};
}
