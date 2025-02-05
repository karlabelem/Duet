// Example usage
/*
void main() {
  User userA = User(
    id: "1",
    favoriteArtists: {"Taylor Swift", "Drake"},
    favoriteGenres: {"Pop", "Hip-Hop"},
    audioFeatures: [0.8, 0.6, 0.7], // Example tempo, energy, danceability
  );

  User userB = User(
    id: "2",
    favoriteArtists: {"Drake", "Kanye West"},
    favoriteGenres: {"Hip-Hop", "Rap"},
    audioFeatures: [0.7, 0.6, 0.8],
  );

  User userC = User(
    id: "3",
    favoriteArtists: {"Billie Eilish", "Lorde"},
    favoriteGenres: {"Indie Pop", "Alternative"},
    audioFeatures: [0.5, 0.4, 0.6],
  );

  List<User> allUsers = [userB, userC];

  List<Map<String, dynamic>> matches = findBestMatches(userA, allUsers);

  for (var match in matches) {
    print("Matched with ${match['user'].id} - Score: ${match['score'].toStringAsFixed(2)}");
  }
}
*/


// Data structure
class User {
  String id;
  Set<String> favoriteArtists;
  Set<String> favoriteGenres;
  List<double> audioFeatures; // e.g., tempo, energy, danceability
  
  User({required this.id, required this.favoriteArtists, required this.favoriteGenres, required this.audioFeatures});
}


// Similarity measure (for sets)
double jaccardSimilarity(Set<String> set1, Set<String> set2) {
  if (set1.isEmpty || set2.isEmpty) return 0.0;

  int intersectionSize = set1.intersection(set2).length;
  int unionSize = set1.union(set2).length;

  return intersectionSize / unionSize;
}

// Another (for numerical)
import 'dart:math';

double cosineSimilarity(List<double> vec1, List<double> vec2) {
  if (vec1.length != vec2.length || vec1.isEmpty) return 0.0;

  double dotProduct = 0.0;
  double norm1 = 0.0;
  double norm2 = 0.0;

  for (int i = 0; i < vec1.length; i++) {
    dotProduct += vec1[i] * vec2[i];
    norm1 += vec1[i] * vec1[i];
    norm2 += vec2[i] * vec2[i];
  }

  if (norm1 == 0 || norm2 == 0) return 0.0;

  return dotProduct / (sqrt(norm1) * sqrt(norm2));
}

// Compute overall match score
double computeMatchScore(User user1, User user2, {double artistWeight = 0.4, double genreWeight = 0.3, double audioWeight = 0.3}) {
  double artistSim = jaccardSimilarity(user1.favoriteArtists, user2.favoriteArtists);
  double genreSim = jaccardSimilarity(user1.favoriteGenres, user2.favoriteGenres);
  double audioSim = cosineSimilarity(user1.audioFeatures, user2.audioFeatures);

  return (artistSim * artistWeight) + (genreSim * genreWeight) + (audioSim * audioWeight);
}

// Find best matches
List<Map<String, dynamic>> findBestMatches(User targetUser, List<User> allUsers) {
  List<Map<String, dynamic>> matches = [];

  for (User user in allUsers) {
    if (user.id == targetUser.id) continue; // Skip self-matching

    double score = computeMatchScore(targetUser, user);
    matches.add({'user': user, 'score': score});
  }

  // Sort matches by score in descending order
  matches.sort((a, b) => b['score'].compareTo(a['score']));

  return matches;
}


