import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../constants/api_endpoints.dart';

class GraphQLClientManager {
  static GraphQLClientManager? _instance;
  late GraphQLCache _cache;
  late HttpLink _httpLink;
  late AuthLink? _authLink;
  late Link _link;

  GraphQLClientManager._internal();

  static GraphQLClientManager get instance {
    _instance ??= GraphQLClientManager._internal();
    return _instance!;
  }

  void initialize({String? token}) {
    _cache = GraphQLCache(store: InMemoryStore());

    _httpLink = HttpLink(
      ApiEndpoints.graphqlEndpoint,
      defaultHeaders: {
        'Content-Type': 'application/json',
      },
    );

    if (token != null) {
      _authLink = AuthLink(
        getToken: () async => 'Bearer $token',
      );
      _link = _authLink!.concat(_httpLink);
    } else {
      _link = _httpLink;
    }
  }

  ValueNotifier<GraphQLClient> getClient() {
    return ValueNotifier(
      GraphQLClient(
        link: _link,
        cache: _cache,
      ),
    );
  }

  void updateToken(String token) {
    _authLink = AuthLink(
      getToken: () async => 'Bearer $token',
    );
    _link = _authLink!.concat(_httpLink);
  }

  void clearToken() {
    _authLink = null;
    _link = _httpLink;
  }

  void clearCache() {
    _cache.store.reset();
  }
}
