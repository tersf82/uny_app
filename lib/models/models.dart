
class User {
  final int id;
  final String name;
  final String photoUrl;
  final double rating;
  final Map characteristics;
  final List<CommentModel> reviews;

  User(
      {required this.id,
      required this.name,
      required this.photoUrl,
      required this.rating,
      required this.characteristics,
      required this.reviews});

}

class CommentModel {
  final int id;
  final String email;
  final String name;
  final int postId;
  final String body;

  CommentModel(
      {required this.id,
        required this.email,
        required this.name,
        required this.postId,
        required this.body});

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
        id: json['id'],
        email: json['email'],
        name: json['name'],
        postId: json['postId'],
        body: json['body']);
  }
}

class Characteristic {

  final int id;
  final String title;
  final String emoji;

  Characteristic(
      {required this.id,
        required this.title,
        required this.emoji,
      });
}


