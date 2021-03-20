class Role {
  double id;
  String name;
  String defaultRoute;
  String allowedRoutesStr;
  List<String> allowedRoutes;
  bool state;
  String status;
  DateTime createdDate;
  DateTime updatedDate;

  Role(
      {this.id,
      this.createdDate,
      this.updatedDate,
      this.name,
      this.state,
      this.status,
      this.allowedRoutes,
      this.allowedRoutesStr,
      this.defaultRoute});

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdDate': createdDate,
        'updatedDate': updatedDate,
        'name': name,
        'state': state,
        'status': status,
        'allowedRoutes': allowedRoutes,
        'allowedRoutesStr': allowedRoutesStr,
        'defaultRoute': defaultRoute
      };
}
