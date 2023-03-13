class ModelsModel {
  String id;
  int created;
  String root;

  ModelsModel({
    required this.id,
    required this.created,
    required this.root,
  });

  factory ModelsModel.fromJson(Map<String, dynamic> json) => ModelsModel(
        id: json['id'],
        created: json['created'],
        root: json['root'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> ModelsModel = new Map<String, dynamic>();
    ModelsModel['id'] = id;
    ModelsModel['created'] = created;
    ModelsModel['root'] = root;
    return ModelsModel;
  }

  static List<ModelsModel> modelsFromSnapshot(List modelSnapshot) {
    return modelSnapshot.map((e) => ModelsModel.fromJson(e)).toList();
  }
}
