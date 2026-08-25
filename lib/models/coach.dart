class Review {
  final String reviewer;
  final double rating;
  final String comment;

  Review({required this.reviewer, required this.rating, required this.comment});
}

class Coach {
  final String name;
  final String specialty;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final int experienceYears;
  final String bio;
  final List<Review> reviews;

  Coach({
    required this.name,
    required this.specialty,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.experienceYears,
    required this.bio,
    required this.reviews,
  });
}
