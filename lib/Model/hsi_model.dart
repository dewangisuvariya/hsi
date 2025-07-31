

class AboutHsiSection {
  final int id;
  final String sectionName;
  final String sectionType;
  final String image;

  AboutHsiSection({
    required this.id,
    required this.sectionName,
    required this.sectionType,
    required this.image,
  });

  factory AboutHsiSection.fromJson(Map<String, dynamic> json) {
    return AboutHsiSection(
      id: json['id'],
      sectionName: json['section_name'],
      sectionType: json['section_type'],
      image: json['image'],
    );
  }
}