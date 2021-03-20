class FcmPushNotificationRequest {
  String title;
  String message;
  String topic;
  String token;

  FcmPushNotificationRequest(
      {this.message, this.topic, this.token, this.title});

  factory FcmPushNotificationRequest.fromJson(Map<String, dynamic> json) =>
      FcmPushNotificationRequest(
        title: json["title"],
        message: json["message"],
        token: json["token"],
        topic: json["topic"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "message": message,
        "token": token,
        "topic": topic,
      };
}
