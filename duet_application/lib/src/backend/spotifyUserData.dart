import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:flutter_web_auth/flutter_web_auth.dart'; // For OAuth handling
import 'package:http/http.dart' as http;  // For HTTP requests
import 'userProfile.dart';  // Assuming userProfile.dart contains the UserProfileData class

class SpotifyUserData {
  final String uuid;
  String username;
  String email;
  String accessToken;
  String refreshToken;
  List<dynamic>? favoriteArtists;
  List<dynamic>? favoriteTracks;

  SpotifyUserData({
    required this.uuid,
    required this.accessToken,
    required this.refreshToken,
    required this.username,
    required this.email,
    this.favoriteArtists,
    this.favoriteTracks,
  });

  // Convert Spotify data to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'username': username,
      'email': email,
      'favoriteArtists': favoriteArtists,
      'favoriteTracks': favoriteTracks,
    };
  }

  // Create SpotifyUserData from a Firestore document snapshot
  factory SpotifyUserData.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SpotifyUserData(
      uuid: data['uuid'],
      accessToken: data['accessToken'],
      refreshToken: data['refreshToken'],
      username: data['username'],
      email: data['email'],
      favoriteArtists: data['favoriteArtists'] ?? [],
      favoriteTracks: data['favoriteTracks'] ?? [],
    );
  }

  // Save or update Spotify data in Firestore
  Future<void> save() async {
    final userRef = FirebaseFirestore.instance.collection('spotify_users').doc(uuid);
    await userRef.set(this.toMap(), SetOptions(merge: true));  // Merges the data, without overwriting
  }

  // Fetch Spotify data from Firestore
  static Future<SpotifyUserData?> fetch(String uuid) async {
    final userRef = FirebaseFirestore.instance.collection('spotify_users').doc(uuid);
    final snapshot = await userRef.get();
    if (snapshot.exists) {
      return SpotifyUserData.fromFirestore(snapshot);
    }
    return null;
  }

  // This class initiates the login and retrieves an authentication code.
  Future<String> authenticateSpotify() async {
    final clientId = 'YOUR_SPOTIFY_CLIENT_ID';
    final clientSecret = 'YOUR_SPOTIFY_CLIENT_SECRET';
    final redirectUri = 'yourapp://callback';
    
    final authUrl = 'https://accounts.spotify.com/authorize'
        '?client_id=$clientId'
        '&response_type=code'
        '&redirect_uri=$redirectUri'
        '&scope=user-top-read';
        
    final result = await FlutterWebAuth.authenticate(
        url: authUrl, callbackUrlScheme: 'yourapp');
        
    final code = Uri.parse(result).queryParameters['code'];
    
    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      body: {
        'grant_type': 'authorization_code',
        'code': code!,
        'redirect_uri': redirectUri,
        'client_id': clientId,
        'client_secret': clientSecret,
      },
    );
    
    final Map<String, dynamic> tokenData = json.decode(response.body);
    return tokenData['access_token'];
  }

  // Fetches the user's top artists
  Future<List<dynamic>> fetchTopArtists(String accessToken) async {
    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/me/top/artists'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    final data = json.decode(response.body);
    return data['items']; // List of artist objects
  }

  // Fetches the user's top tracks
  Future<List<dynamic>> fetchTopTracks(String accessToken) async {
    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/me/top/tracks'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    final data = json.decode(response.body);
    return data['items']; // List of track objects
  }
}

// Spotify service class
class SpotifyService {
  Future<String> authenticate() async {
    return await SpotifyUserData().authenticateSpotify();  // Handle Spotify authentication
  }

  Future<List<dynamic>> getTopArtists(String accessToken) async {
    return await SpotifyUserData().fetchTopArtists(accessToken);
  }

  Future<List<dynamic>> getTopTracks(String accessToken) async {
    return await SpotifyUserData().fetchTopTracks(accessToken);
  }
}

// Updates user profile with Spotify data
Future<void> updateSpotifyData(UserProfileData userProfile) async {
  final spotifyService = SpotifyService();
  
  // Step 1: Authenticate and fetch Spotify data
  final accessToken = await spotifyService.authenticate();
  final topArtists = await spotifyService.getTopArtists(accessToken);
  final topTracks = await spotifyService.getTopTracks(accessToken);
  
  // Step 2: Link the Spotify data to UserProfileData
  userProfile.spotifyAccessToken = accessToken;
  userProfile.favoriteArtists = topArtists;
  userProfile.favoriteTracks = topTracks;
  
  // Step 3: Save updated profile data to Firestore
  await userProfile.saveToFirestore();
}
