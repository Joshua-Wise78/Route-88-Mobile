class Link {
  Link({
    required this.href,
    required this.rel,
    this.method,
  });

  factory Link.fromJson(Map<String, dynamic> json) {
    return Link(
      href: json['href'] as String?,
      rel: json['rel'] as String?,
      method: json['method'] as String?,
    );
  }

  final String? href;
  final String? rel;
  final String? method;
}

class Base {
  Base({
    required this.id,
    required this.latitude,
    required this.longitude,
    this.location,
    this.description,
    this.category,
    this.direction,
    this.routeName,
    this.link,
  });

  factory Base.fromJson(Map<String, dynamic> json) {
    return Base(
      id: json['id'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      location: json['location'] as String?,
      description: json['description'] as String?,
      category: json['category'] as String?,
      direction: json['direction'] as String?,
      routeName: json['routeName'] as String?,
      link: json['link'] != null
          ? Link.fromJson(json['link'] as Map<String, dynamic>)
          : null,
    );
  }

  final String id;
  final double latitude;
  final double longitude;
  final String? location;
  final String? description;
  final String? category;
  final String? direction;
  final String? routeName;
  final Link? link;
}
