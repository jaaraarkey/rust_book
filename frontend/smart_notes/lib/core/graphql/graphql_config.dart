import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class GraphQLConfig {
  static const String _baseUrl = 'http://127.0.0.1:8000'; // Backend server URL
  static const String _graphqlEndpoint = '$_baseUrl/graphql';
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static HttpLink get httpLink => HttpLink(_graphqlEndpoint);

  static Future<AuthLink> get authLink async {
    return AuthLink(
      getToken: () async {
        final token = await _secureStorage.read(key: 'jwt_token');
        return token != null ? 'Bearer $token' : null;
      },
    );
  }

  static Future<GraphQLClient> get client async {
    final authLinkInstance = await authLink;

    final Link link = Link.from([
      authLinkInstance,
      httpLink,
    ]);

    return GraphQLClient(
      cache: GraphQLCache(store: InMemoryStore()),
      link: link,
    );
  }

  // Helper method to store JWT token
  static Future<void> saveToken(String token) async {
    await _secureStorage.write(key: 'jwt_token', value: token);
  }

  // Helper method to retrieve JWT token
  static Future<String?> getToken() async {
    return await _secureStorage.read(key: 'jwt_token');
  }

  // Helper method to remove JWT token
  static Future<void> removeToken() async {
    await _secureStorage.delete(key: 'jwt_token');
  }

  // Helper method to check if user is authenticated
  static Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
