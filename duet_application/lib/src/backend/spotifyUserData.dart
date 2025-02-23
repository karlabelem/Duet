import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;
import 'userProfile.dart';

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

  static final String _clientId = dotenv.env['CLIENT_ID']!;
  static final String _clientSecret = dotenv.env['CLIENT_SECRET']!;
  static final String _redirectUri = dotenv.env['REDIRECT_URI']!;
  static final String _spotifyAuthUrl = 'https://accounts.spotify.com/authorize';
  static final String _spotifyTokenUrl = 'https://accounts.spotify.com/api/token';
  static final String _spotifyApiUrl = 'https://api.spotify.com/v1';


  //
  // Calls connectWithSpotify() to initiate Spotify authentication.
  // Saves the new profile to Firestore. Use it when user connects to Spotify for the first time.
  //
  static Future<SpotifyUserData> createSpotifyProfile(String uuid) async {
    final user = await SpotifyUserData.connectWithSpotify(uuid);
    await user.save();
    return user;
  }
  //
  // Refreshes the user's Spotify data and saves the updated information to Firestore.
  //
  Future<void> updateSpotifyData() async {
    await refreshAccessToken();
    await fetchUserData();
    setFavoriteArtists(await fetchArtists());
    setFavoriteTracks(await fetchLibrary());
    await save();
  }
  //
  // Retrieves stored Spotify user data from Firestore.
  //
  static Future<SpotifyUserData?> get(String uuid) async {
    final doc = await FirebaseFirestore.instance.collection('spotify_users').doc(uuid).get();
    if (doc.exists) {
      return SpotifyUserData.fromMap(doc.data()!);
    }
    return null;
  }

  //
  // Handles Spotify's OAuth authentication.
  // Exchanges an authorization code for an access token.
  // Fetches and saves user data.
  //
  static Future<SpotifyUserData> connectWithSpotify(String uuid) async {
    try {
      final result = await FlutterWebAuth.authenticate(
        url: '$_spotifyAuthUrl?response_type=code&client_id=$_clientId'
            '&redirect_uri=${Uri.encodeComponent(_redirectUri)}'
            '&scope=${Uri.encodeComponent("user-top-read user-library-read user-read-email user-read-private")}',
        callbackUrlScheme: Uri.parse(_redirectUri).scheme,
      );

      final code = Uri.parse(result).queryParameters['code'];
      if (code == null) throw Exception("Failed to retrieve authorization code");

      final tokenResponse = await http.post(
        Uri.parse(_spotifyTokenUrl),
        headers: {
          'Authorization': 'Basic ${base64Encode(utf8.encode('$_clientId:$_clientSecret'))}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'grant_type': 'authorization_code',
          'code': code,
          'redirect_uri': _redirectUri,
        },
      );

      if (tokenResponse.statusCode != 200) throw Exception('Token fetch failed');
      final tokenData = jsonDecode(tokenResponse.body);

      final user = SpotifyUserData(
        uuid: uuid,
        accessToken: tokenData['access_token'],
        refreshToken: tokenData['refresh_token'],
        username: '',
        email: '',
      );

      await user.fetchUserData();
      await user.save();
      return user;
    } catch (e) {
      throw Exception('Spotify connection failed: $e');
    }
  }
  //
  // Refreshes the user's Spotify access token.
  // Updates Firestore with the new token.
  //
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

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setAccessToken(data['access_token']);
      await save();
    } else {
      throw Exception('Failed to refresh access token');
    }
  }

  void setUsername(String newUsername) => username = newUsername;
  void setEmail(String newEmail) => email = newEmail;
  void setAccessToken(String newAccessToken) => accessToken = newAccessToken;
  void setRefreshToken(String newRefreshToken) => refreshToken = newRefreshToken;
  void setFavoriteArtists(List<dynamic> newFavoriteArtists) => favoriteArtists = newFavoriteArtists;
  void setFavoriteTracks(List<dynamic> newFavoriteTracks) => favoriteTracks = newFavoriteTracks;

  //
  // Fetches Spotify user profile details (name, email) and updates local variables.
  //
  Future<void> fetchUserData() async {
    final response = await _spotifyRequest('$_spotifyApiUrl/me');
    username = response['display_name'] ?? '';
    email = response['email'] ?? '';
  }
  
  //
  // Gets the user's top artists.
  //
  Future<List<dynamic>> fetchArtists({int limit = 20}) async {
    final response = await _spotifyRequest('$_spotifyApiUrl/me/top/artists?limit=$limit');
    setFavoriteArtists(response['items']);
    return favoriteArtists!;
  }

  //
  // Fetches saved tracks from Spotify.
  //
  Future<List<dynamic>> fetchLibrary({int limit = 20}) async {
    final response = await _spotifyRequest('$_spotifyApiUrl/me/tracks?limit=$limit');
    return response['items'];
  }
  //
  // Makes an authenticated request to the Spotify API and automatically refreshes the access token if needed.
  //
  Future<dynamic> _spotifyRequest(String url) async {
    var response = await http.get(Uri.parse(url), headers: {'Authorization': 'Bearer $accessToken'});
    if (response.statusCode == 401) {
      await refreshAccessToken();
      response = await http.get(Uri.parse(url), headers: {'Authorization': 'Bearer $accessToken'});
    }
    return jsonDecode(response.body);
  }

  Map<String, dynamic> toMap() => {
        'uuid': uuid,
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'username': username,
        'email': email,
        'favoriteArtists': favoriteArtists,
        'favoriteTracks': favoriteTracks,
      };

  factory SpotifyUserData.fromMap(Map<String, dynamic> data) => SpotifyUserData(
        uuid: data['uuid'] ?? '',
        username: data['username'] ?? '',
        email: data['email'] ?? '',
        accessToken: data['accessToken'] ?? '',
        refreshToken: data['refreshToken'] ?? '',
        favoriteArtists: data['favoriteArtists'] != null ? List<dynamic>.from(data['favoriteArtists']) : null,
        favoriteTracks: data['favoriteTracks'] != null ? List<dynamic>.from(data['favoriteTracks']) : null,
      );

  //
  // Saves the current state of the object to Firestore.
  //
  Future<void> save() async {
    await FirebaseFirestore.instance.collection('spotify_users').doc(uuid).set(toMap());
  }
}
