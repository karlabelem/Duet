import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'userProfile.dart';

enum MusicGenre {
  rock,
  pop,
  jazz,
  classical,
  hipHop,
  electronic,
  country,
  reggae,
  blues,
  metal,
  folk,
  punk,
  soul,
  rnb,
  latin,
  disco,
  funk,
  techno,
  house,
  trance,
  dubstep,
  drumAndBass,
  ambient,
  indie,
  alternative,
  kpop,
  jpop,
  cpop,
  world,
  soundtrack,
}

class SpotifyUserData {
  // TODO !!
  // These should be unique per user not the same for everyone -> dynamic
  static const String _clientId = '4dbf19a959ff4c3bb0992c29ce581668';
  static const String _clientSecret = 'e4fa3a54db064be3bdae30d26bb33b12';
  static const String _redirectUri = 'https://api.spotify.com';
  static const String _spotifyAuthUrl = 'https://accounts.spotify.com/authorize';
  static const String _spotifyTokenUrl = 'https://accounts.spotify.com/api/token';
  static const String _spotifyApiUrl = 'https://api.spotify.com/v1';

  final String uuid;
  String? username;
  String email;
  String? accessToken;
  String? refreshToken;
  List<dynamic>?
      favoriteArtists; // IDK if we should limit these data structures
  List<dynamic>? favoriteTracks;
  List<dynamic>? favoriteGenres;

  SpotifyUserData({
    required this.uuid,
    this.accessToken,
    this.refreshToken,
    this.username,
    required this.email,
    this.favoriteArtists,
    this.favoriteTracks,
    this.favoriteGenres,
  });

  /// Create and store a new Spotify profile in Firestore.
  static Future<SpotifyUserData> createSpotifyProfile(String uuid) async {
    final user = await SpotifyUserData.connectWithSpotify(uuid);
    await user.save(); // Save user data in Firestore
    return user;
  }

  /// Update the stored Spotify data when the user logs in.
  Future<void> updateSpotifyData() async {
    await refreshAccessToken(); // Ensure token is up-to-date
    await fetchUserData(); // Get latest user details
    favoriteArtists = await fetchArtists(); // Get latest artists
    favoriteTracks = await fetchLibrary(); // Get latest tracks
    await save(); // Save updated data in Firestore
  }

  // Get user data from Firestore
  static Future<SpotifyUserData> get(String uuid) async {
    final doc = await FirebaseFirestore.instance
        .collection('spotify_users')
        .doc(uuid)
        .get();
    return SpotifyUserData.fromMap(doc.data()!);
  }

  // TODO!!!
  // should be authenticating with spotify page to get the data using username and email. !!!
  // Connect with Spotify OAuth flow
  static Future<SpotifyUserData> connectWithSpotify(String uuid) async {
    final result = await FlutterWebAuth.authenticate(
      url:
          '$_spotifyAuthUrl?response_type=code&client_id=$_clientId&redirect_uri=$_redirectUri&scope=user-top-read user-library-read',
      callbackUrlScheme: _redirectUri.split(':')[0],
    );

    final code = Uri.parse(result).queryParameters['code'];
    final tokenResponse = await http.post(
      Uri.parse(_spotifyTokenUrl),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$_clientId:$_clientSecret'))}',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$_clientId:$_clientSecret'))}',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'grant_type': 'authorization_code',
        'code': code,
        'redirect_uri': _redirectUri,
      },
    );

    final tokenData = jsonDecode(tokenResponse.body);
    final user = SpotifyUserData(
      uuid: uuid,
      accessToken: tokenData['access_token'],
      refreshToken: tokenData['refresh_token'],
      username: '', // TODO: username missing
      email: '', // TODO: email missing
    );

    await user.fetchUserData();
    return user;
  }

  // Refresh access token
  Future<void> refreshAccessToken() async {
    final response = await http.post(
      Uri.parse(_spotifyTokenUrl),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$_clientId:$_clientSecret'))}',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'grant_type': 'refresh_token',
        'refresh_token': refreshToken,
      },
    );

    final data = jsonDecode(response.body);
    accessToken = data['access_token'];
  }

  // TODO
  // SETTER METHODS MISSING

  // GETTER METHODS

  // Fetch user profile data
  Future<void> fetchUserData() async {
    final response = await _spotifyRequest('$_spotifyApiUrl/me');
    username = response['display_name'] ?? '';
    email = response['email'] ?? '';
  }

  // Fetch top artists
  Future<List<dynamic>> fetchArtists({int limit = 20}) async {
    final response = await _spotifyRequest(
      '$_spotifyApiUrl/me/top/artists?limit=$limit',
    );
    favoriteArtists = response['items'];
    return favoriteArtists!;
  }

  // Fetch user's library (saved tracks)
  Future<List<dynamic>> fetchLibrary({int limit = 20}) async {
    final response = await _spotifyRequest(
      '$_spotifyApiUrl/me/tracks?limit=$limit',
    );
    return response['items'];
  }

  // Fetch specific songs
  Future<List<dynamic>> fetchSongs(List<String> trackIds) async {
    final response = await _spotifyRequest(
      '$_spotifyApiUrl/tracks?ids=${trackIds.join(',')}',
    );
    return response['tracks'];
  }

  // Fetch saved albums
  Future<List<dynamic>> fetchAlbums({int limit = 20}) async {
    final response = await _spotifyRequest(
      '$_spotifyApiUrl/me/albums?limit=$limit',
    );
    return response['items'];
  }

  // Fetch genre based on top artists
  Future<List<String>> fetchGenre() async {
    final artists = await fetchArtists();
    final genres = <String>{};  
    for (final artist in artists) {
      genres.addAll((artist['genres'] as List).cast<String>());
    }
    return genres.toList();
  }

  // Helper method for Spotify API requests
  Future<dynamic> _spotifyRequest(String url) async {
    var response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 401) {
      await refreshAccessToken();
      response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
    }

    return jsonDecode(response.body);
  }

  // Convert to Firestore map
  Map<String, dynamic> toMap() {

    return {
      'uuid': uuid,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'username': username,
      'email': email,
      'favoriteArtists': favoriteArtists,
      'favoriteTracks': favoriteTracks,
      'favoriteGenres': favoriteGenres,
    };
  }

  // Create from Firestore data
  factory SpotifyUserData.fromMap(Map<String, dynamic> data) {
    return SpotifyUserData(
      uuid: data['uuid'] ?? '',
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      accessToken: data['accessToken'] ?? '',
      refreshToken: data['refreshToken'] ?? '',
      favoriteArtists: data['favoriteArtists'] != null
          ? List<dynamic>.from(data['favoriteArtists'])
          : null,
      favoriteTracks: data['favoriteTracks'] != null
          ? List<dynamic>.from(data['favoriteTracks'])
          : null,
    );
  }

  // Save to Firestore
  Future<void> save() async {
    await FirebaseFirestore.instance
        .collection('spotify_users')
        .doc(uuid)
        .set(toMap());
  }

  List<Map<String, dynamic>> getFavoriteGenres() {
    // Fetch the favorite genres from Firestore or any other source
    // Here, we assume that the genres are stored in the 'favoriteGenres' field
    return favoriteGenres!.map((genre) => {'name': genre}).toList();
  }
}

