class StudentNotice {
  final int id;
  final String title;
  final String description;
  final String category;
  final String date;
  final String createdBy;
  final String createdAt;
  final String? attachmentUrl;

  StudentNotice({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.date,
    required this.createdBy,
    required this.createdAt,
    required this.attachmentUrl,
  });

  factory StudentNotice.fromJson(Map<String, dynamic> json) {
    return StudentNotice(
      id: int.parse(json['id'].toString()),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      date: json['date'] ?? '',
      createdBy: json['createdBy'] ?? '',
      createdAt: json['createdAt'] ?? '',
      attachmentUrl: json['attachmentUrl'],
    );
  }
}
